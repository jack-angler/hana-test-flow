import crypto from 'node:crypto'
import fs from 'node:fs'
import path from 'node:path'
import { execFileSync } from 'node:child_process'

const inputPath = process.argv[2]

if (!inputPath) {
  console.error('Usage: node scripts/generate-scenario-sql.mjs <xlsx-path>')
  process.exit(1)
}

const resolvedInputPath = path.resolve(inputPath)
const workbookName = path.basename(resolvedInputPath, path.extname(resolvedInputPath))
const outputDir = path.resolve('guide/scenario/generated')
const outputPath = path.join(outputDir, `${workbookName}.sql`)
const tempDir = path.join(
  process.env.TEMP ?? process.env.TMP ?? '.',
  `hana-xlsx-${crypto.randomUUID()}`,
)

function xmlEscapePattern(text) {
  return text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
}

function decodeXml(text) {
  return text
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&amp;/g, '&')
    .replace(/&quot;/g, '"')
    .replace(/&apos;/g, "'")
}

function readXml(filePath) {
  return fs.readFileSync(filePath, 'utf8')
}

function attr(xml, name) {
  const match = xml.match(new RegExp(`${xmlEscapePattern(name)}="([^"]*)"`, 'u'))
  return match?.[1] ?? ''
}

function extractTags(xml, tagName) {
  return [...xml.matchAll(new RegExp(`<${tagName}\\b[^>]*>[\\s\\S]*?<\\/${tagName}>`, 'gu'))].map(
    (match) => match[0],
  )
}

function extractTagText(xml, tagName) {
  const matches = [...xml.matchAll(new RegExp(`<${tagName}\\b[^>]*>([\\s\\S]*?)<\\/${tagName}>`, 'gu'))]
  return decodeXml(matches.map((match) => match[1]).join(''))
}

function unzipWorkbook() {
  fs.mkdirSync(tempDir, { recursive: true })
  execFileSync('powershell.exe', [
    '-NoProfile',
    '-Command',
    `Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory(${JSON.stringify(resolvedInputPath)}, ${JSON.stringify(tempDir)})`,
  ])
}

function parseSharedStrings() {
  const sharedStringsPath = path.join(tempDir, 'xl/sharedStrings.xml')

  if (!fs.existsSync(sharedStringsPath)) {
    return []
  }

  const xml = readXml(sharedStringsPath)

  return extractTags(xml, 'si').map((si) => extractTagText(si, 't'))
}

function parseWorkbookSheets() {
  const workbookXml = readXml(path.join(tempDir, 'xl/workbook.xml'))
  const relsXml = readXml(path.join(tempDir, 'xl/_rels/workbook.xml.rels'))
  const relationships = new Map()

  for (const relationship of [...relsXml.matchAll(/<Relationship\b[^>]*\/>/gu)].map((match) => match[0])) {
    relationships.set(attr(relationship, 'Id'), attr(relationship, 'Target'))
  }

  return [...workbookXml.matchAll(/<sheet\b[^>]*\/>/gu)].map((match, index) => {
    const sheetXml = match[0]
    const rid = attr(sheetXml, 'r:id')
    const target = relationships.get(rid)

    return {
      index: index + 1,
      name: attr(sheetXml, 'name'),
      file: path.join(tempDir, 'xl', target),
    }
  })
}

function cellColumn(cellRef) {
  return cellRef.replace(/[0-9]/g, '')
}

function parseSheetRows(sheet, sharedStrings) {
  const xml = readXml(sheet.file)
  const rows = []

  for (const rowXml of extractTags(xml, 'row')) {
    const row = {}
    row.__rowNumber = Number(attr(rowXml, 'r'))

    for (const cellXml of [...rowXml.matchAll(/<c\b[^>]*>[\s\S]*?<\/c>/gu)].map((match) => match[0])) {
      const ref = attr(cellXml, 'r')
      const type = attr(cellXml, 't')
      const rawValue = extractTagText(cellXml, 'v')
      let value = ''

      if (type === 's') {
        value = sharedStrings[Number(rawValue)] ?? ''
      } else if (type === 'inlineStr') {
        value = extractTagText(cellXml, 't')
      } else {
        value = rawValue
      }

      row[cellColumn(ref)] = value.trim()
    }

    rows.push(row)
  }

  return rows
}

function sqlString(value) {
  if (value === null || value === undefined || value === '') {
    return 'NULL'
  }

  return `'${String(value).replace(/\\/g, '\\\\').replace(/'/g, "''")}'`
}

function contentHash(testCase) {
  return crypto
    .createHash('sha256')
    .update(
      JSON.stringify([
        testCase.scenarioMenu,
        testCase.scenarioCode,
        testCase.caseCode,
        testCase.name,
        testCase.location,
        testCase.precondition,
        testCase.testSteps,
        testCase.expectedResult,
      ]),
    )
    .digest('hex')
}

function findDuplicateKeys(cases) {
  const seen = new Map()
  const duplicates = []

  cases.forEach((testCase, index) => {
    const key = `${testCase.scenarioCode}::${testCase.caseCode}`
    const previous = seen.get(key)

    if (previous) {
      duplicates.push({
        key,
        first: previous,
        current: {
          sheetName: testCase.sheetName,
          rowNumber: testCase.rowNumber,
          scenarioCode: testCase.scenarioCode,
          caseCode: testCase.caseCode,
          name: testCase.name,
          index: index + 1,
        },
      })
      return
    }

    seen.set(key, {
      sheetName: testCase.sheetName,
      rowNumber: testCase.rowNumber,
      scenarioCode: testCase.scenarioCode,
      caseCode: testCase.caseCode,
      name: testCase.name,
      index: index + 1,
    })
  })

  return duplicates
}

function buildSql(scenarios, cases) {
  const lines = [
    'START TRANSACTION;',
    '',
    "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;",
    "SET collation_connection = 'utf8mb4_unicode_ci';",
    '',
    `SET @test_run_name = ${sqlString(workbookName)};`,
    '',
    'INSERT INTO test_runs (name)',
    'VALUES (@test_run_name)',
    'ON DUPLICATE KEY UPDATE',
    '    updated_at = CURRENT_TIMESTAMP;',
    '',
    'SELECT id INTO @test_run_id FROM test_runs WHERE name = @test_run_name;',
    '',
    'CREATE TEMPORARY TABLE IF NOT EXISTS tmp_import_test_cases (',
    '    scenario_code VARCHAR(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,',
    '    case_code VARCHAR(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,',
    '    PRIMARY KEY (scenario_code, case_code)',
    ') ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;',
    '',
    'TRUNCATE TABLE tmp_import_test_cases;',
    '',
  ]

  scenarios.forEach((scenario, index) => {
    lines.push(
      `SET @scenario_code = ${sqlString(scenario.scenarioCode)};`,
      `SET @scenario_name = ${sqlString(scenario.name)};`,
      'INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)',
      `VALUES (@test_run_id, @scenario_code, @scenario_name, ${index + 1})`,
      'ON DUPLICATE KEY UPDATE',
      '    name = VALUES(name),',
      '    sort_order = VALUES(sort_order),',
      '    updated_at = CURRENT_TIMESTAMP;',
      '',
    )
  })

  cases.forEach((testCase, index) => {
    const hash = contentHash(testCase)

    lines.push(
      `SET @scenario_code = ${sqlString(testCase.scenarioCode)};`,
      `SET @case_code = ${sqlString(testCase.caseCode)};`,
      `SET @content_hash = ${sqlString(hash)};`,
      'INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)',
      'VALUES (@scenario_code, @case_code);',
      '',
      'SELECT id INTO @test_scenario_id',
      'FROM test_scenarios',
      'WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;',
      '',
      'SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no',
      'FROM test_cases',
      'WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;',
      '',
      'SELECT COUNT(*) INTO @same_current_count',
      'FROM test_cases',
      'WHERE test_scenario_id = @test_scenario_id',
      '  AND case_code = @case_code',
      '  AND is_current = 1',
      '  AND is_deleted = 0',
      '  AND content_hash = @content_hash;',
      '',
      'UPDATE test_cases',
      'SET is_current = IF(@same_current_count = 0, 0, is_current),',
      '    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)',
      'WHERE test_scenario_id = @test_scenario_id',
      '  AND case_code = @case_code',
      '  AND is_current = 1',
      '  AND @prev_version_no > 0;',
      '',
      'INSERT INTO test_cases (',
      '    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,',
      '    name, location, precondition, test_steps, expected_result, content_hash,',
      '    is_current, is_deleted, sort_order',
      ')',
      'SELECT',
      '    @test_scenario_id,',
      `    ${sqlString(testCase.scenarioMenu)},`,
      '    @scenario_code,',
      '    @case_code,',
      '    @prev_version_no + 1,',
      `    ${sqlString(testCase.name)},`,
      `    ${sqlString(testCase.location)},`,
      `    ${sqlString(testCase.precondition)},`,
      `    ${sqlString(testCase.testSteps)},`,
      `    ${sqlString(testCase.expectedResult)},`,
      '    @content_hash,',
      '    1,',
      '    0,',
      `    ${index + 1}`,
      'WHERE @same_current_count = 0;',
      '',
    )
  })

  lines.push(
    'UPDATE test_cases tc',
    'INNER JOIN test_scenarios ts ON ts.id = tc.test_scenario_id',
    'LEFT JOIN tmp_import_test_cases imported',
    '    ON imported.scenario_code = tc.scenario_code',
    '   AND imported.case_code = tc.case_code',
    'SET tc.is_current = 0,',
    '    tc.is_deleted = 1,',
    '    tc.deleted_at = COALESCE(tc.deleted_at, CURRENT_TIMESTAMP),',
    '    tc.updated_at = CURRENT_TIMESTAMP',
    'WHERE ts.test_run_id = @test_run_id',
    '  AND tc.is_current = 1',
    '  AND tc.is_deleted = 0',
    '  AND imported.case_code IS NULL;',
    '',
    'DROP TEMPORARY TABLE IF EXISTS tmp_import_test_cases;',
    '',
    'COMMIT;',
    '',
  )

  return lines.join('\n')
}

unzipWorkbook()

const sharedStrings = parseSharedStrings()
const sheets = parseWorkbookSheets()
const scenarioIndex = sheets.findIndex((sheet) => sheet.name === '시나리오-케이스')
const referenceImageIndex = sheets.findIndex((sheet) => sheet.name.replace(/\s/g, '') === '참고이미지')

if (scenarioIndex < 0 || referenceImageIndex < 0 || scenarioIndex >= referenceImageIndex) {
  throw new Error('Expected sheets were not found.')
}

const scenarioRows = parseSheetRows(sheets[scenarioIndex], sharedStrings).slice(1)
const scenariosByCode = new Map()

for (const row of scenarioRows) {
  const scenarioCode = row.B
  const name = row.C

  if (scenarioCode && name && !scenariosByCode.has(scenarioCode)) {
    scenariosByCode.set(scenarioCode, {
      scenarioCode,
      name,
    })
  }
}

const caseSheets = sheets.slice(scenarioIndex + 1, referenceImageIndex)
const cases = []

for (const sheet of caseSheets) {
  const rows = parseSheetRows(sheet, sharedStrings).slice(2)

  for (const row of rows) {
    if (!row.B || !row.D) {
      continue
    }

    cases.push({
      sheetName: sheet.name,
      rowNumber: row.__rowNumber,
      scenarioMenu: row.A,
      scenarioCode: row.B,
      scenarioName: row.C,
      caseCode: row.D,
      name: row.E,
      location: row.F,
      precondition: row.G,
      testSteps: row.H,
      expectedResult: row.I,
    })
  }
}

const duplicates = findDuplicateKeys(cases)

if (duplicates.length > 0) {
  console.error(`Duplicate scenario/case keys found: ${duplicates.length}`)

  duplicates.slice(0, 50).forEach((duplicate, index) => {
    console.error(
      [
        `${index + 1}. ${duplicate.current.scenarioCode} / ${duplicate.current.caseCode}`,
        `first=${duplicate.first.sheetName}!row${duplicate.first.rowNumber}`,
        `duplicate=${duplicate.current.sheetName}!row${duplicate.current.rowNumber}`,
      ].join(' | '),
    )
  })

  if (duplicates.length > 50) {
    console.error(`...and ${duplicates.length - 50} more`)
  }

  process.exit(1)
}

fs.mkdirSync(outputDir, { recursive: true })
fs.writeFileSync(outputPath, buildSql([...scenariosByCode.values()], cases), 'utf8')

console.log(`Workbook: ${workbookName}`)
console.log(`Scenario count: ${scenariosByCode.size}`)
console.log(`Case sheet count: ${caseSheets.length}`)
console.log(`Case count: ${cases.length}`)
console.log(`Output: ${outputPath}`)
