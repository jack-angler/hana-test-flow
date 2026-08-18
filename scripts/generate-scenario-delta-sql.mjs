import crypto from 'node:crypto'
import fs from 'node:fs'
import path from 'node:path'
import { execFileSync } from 'node:child_process'

const updatePath = process.argv[2]
const explicitBasePath = process.argv[3]

if (!updatePath) {
  console.error('Usage: node scripts/generate-scenario-delta-sql.mjs <update-xlsx-path> [base-xlsx-path]')
  process.exit(1)
}

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

function unzipWorkbook(workbookPath) {
  const tempDir = path.join(
    process.env.TEMP ?? process.env.TMP ?? '.',
    `hana-xlsx-${crypto.randomUUID()}`,
  )

  fs.mkdirSync(tempDir, { recursive: true })
  execFileSync('powershell.exe', [
    '-NoProfile',
    '-Command',
    `Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory(${JSON.stringify(workbookPath)}, ${JSON.stringify(tempDir)})`,
  ])

  return tempDir
}

function parseSharedStrings(tempDir) {
  const sharedStringsPath = path.join(tempDir, 'xl/sharedStrings.xml')

  if (!fs.existsSync(sharedStringsPath)) {
    return []
  }

  const xml = readXml(sharedStringsPath)

  return extractTags(xml, 'si').map((si) => extractTagText(si, 't'))
}

function parseWorkbookSheets(tempDir) {
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

function parseWorkbook(workbookPath) {
  const tempDir = unzipWorkbook(workbookPath)
  const sharedStrings = parseSharedStrings(tempDir)
  const sheets = parseWorkbookSheets(tempDir)
  const scenarioIndex = sheets.findIndex((sheet) => sheet.name === '시나리오-케이스')
  const referenceImageIndex = sheets.findIndex((sheet) => sheet.name.replace(/\s/g, '') === '참고이미지')

  if (scenarioIndex < 0 || referenceImageIndex < 0 || scenarioIndex >= referenceImageIndex) {
    throw new Error(`Expected sheets were not found: ${workbookPath}`)
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

  return {
    scenariosByCode,
    cases,
    casesByKey: new Map(cases.map((testCase) => [caseKey(testCase), testCase])),
  }
}

function sqlString(value) {
  if (value === null || value === undefined || value === '') {
    return 'NULL'
  }

  return `'${String(value).replace(/\\/g, '\\\\').replace(/'/g, "''")}'`
}

function caseKey(testCase) {
  return `${testCase.scenarioCode}::${testCase.caseCode}`
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

  cases.forEach((testCase) => {
    const key = caseKey(testCase)
    const previous = seen.get(key)

    if (previous) {
      duplicates.push({
        key,
        first: previous,
        current: testCase,
      })
      return
    }

    seen.set(key, testCase)
  })

  return duplicates
}

function inferBaseName(updateWorkbookName) {
  const match = updateWorkbookName.match(/^PC_.+?_\d+_v[\d.]+_(.+)$/u)

  return match?.[1] ?? updateWorkbookName
}

function updateVersionFor(updateWorkbookPath) {
  const normalized = path.normalize(updateWorkbookPath)
  const segments = normalized.split(path.sep)
  const updateIndex = segments.lastIndexOf('update')

  return updateIndex >= 0 ? segments[updateIndex + 1] : null
}

function previousUpdateWorkbookPath(updateWorkbookPath, baseName) {
  const version = updateVersionFor(updateWorkbookPath)
  const match = version?.match(/^v([0-9]+)$/u)

  if (!match) {
    return null
  }

  const previousVersionNumber = Number(match[1]) - 1

  if (previousVersionNumber < 1) {
    return null
  }

  const normalized = path.normalize(updateWorkbookPath)
  const segments = normalized.split(path.sep)
  const updateIndex = segments.lastIndexOf('update')
  const prefix = segments.slice(0, updateIndex + 1).join(path.sep)
  const previousVersion = `v${previousVersionNumber}`
  const previousDirCandidates = [
    path.join(prefix, previousVersion),
    path.resolve('guide/scenario/update', previousVersion),
    path.resolve('guide/scenario/generated/update', previousVersion),
  ]
  for (const previousDir of previousDirCandidates) {
    if (!fs.existsSync(previousDir)) {
      continue
    }

    const candidates = fs
      .readdirSync(previousDir)
      .filter((filename) => filename.toLowerCase().endsWith('.xlsx'))
      .map((filename) => path.join(previousDir, filename))
    const match = candidates.find((candidate) => inferBaseName(path.basename(candidate, path.extname(candidate))) === baseName)

    if (match) {
      return match
    }
  }

  return null
}

function buildDeltaSql({ testRunName, scenarios, changedCases }) {
  const lines = [
    'START TRANSACTION;',
    '',
    "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;",
    "SET collation_connection = 'utf8mb4_unicode_ci';",
    '',
    `SET @test_run_name = ${sqlString(testRunName)};`,
    '',
    'SELECT id INTO @test_run_id FROM test_runs WHERE name = @test_run_name;',
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
      '    updated_at = CURRENT_TIMESTAMP;',
      '',
    )
  })

  changedCases.forEach((testCase, index) => {
    const hash = contentHash(testCase)

    lines.push(
      `SET @scenario_code = ${sqlString(testCase.scenarioCode)};`,
      `SET @case_code = ${sqlString(testCase.caseCode)};`,
      `SET @content_hash = ${sqlString(hash)};`,
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

  lines.push('COMMIT;', '')

  return lines.join('\n')
}

function outputDirFor(updateWorkbookPath) {
  const normalized = path.normalize(updateWorkbookPath)
  const segments = normalized.split(path.sep)
  const updateIndex = segments.lastIndexOf('update')
  const version = updateIndex >= 0 ? segments[updateIndex + 1] : null

  return version
    ? path.resolve('guide/scenario/generated/update', version)
    : path.resolve('guide/scenario/generated/update')
}

function processUpdateWorkbook(updateWorkbookPath) {
  const resolvedUpdatePath = path.resolve(updateWorkbookPath)
  const updateWorkbookName = path.basename(resolvedUpdatePath, path.extname(resolvedUpdatePath))
  const baseName = inferBaseName(updateWorkbookName)
  const previousUpdatePath = explicitBasePath ? null : previousUpdateWorkbookPath(resolvedUpdatePath, baseName)
  const resolvedBasePath = explicitBasePath
    ? path.resolve(explicitBasePath)
    : previousUpdatePath
      ? previousUpdatePath
    : path.resolve('guide/scenario', `${baseName}.xlsx`)

  if (!fs.existsSync(resolvedBasePath)) {
    throw new Error(`Base workbook was not found: ${resolvedBasePath}`)
  }

  const baseWorkbook = parseWorkbook(resolvedBasePath)
  const updateWorkbook = parseWorkbook(resolvedUpdatePath)
  const duplicateKeys = [
    ...findDuplicateKeys(baseWorkbook.cases),
    ...findDuplicateKeys(updateWorkbook.cases),
  ]

  if (duplicateKeys.length > 0) {
    console.error(`Duplicate scenario/case keys found: ${duplicateKeys.length}`)
    duplicateKeys.slice(0, 50).forEach((duplicate, index) => {
      console.error(
        `${index + 1}. ${duplicate.key} | first=${duplicate.first.sheetName}!row${duplicate.first.rowNumber} | duplicate=${duplicate.current.sheetName}!row${duplicate.current.rowNumber}`,
      )
    })
    process.exit(1)
  }

  const changedCases = updateWorkbook.cases.filter((testCase) => {
    const baseCase = baseWorkbook.casesByKey.get(caseKey(testCase))

    return !baseCase || contentHash(baseCase) !== contentHash(testCase)
  })
  const removedCases = baseWorkbook.cases.filter((testCase) => !updateWorkbook.casesByKey.has(caseKey(testCase)))
  const impactedScenarioCodes = new Set(changedCases.map((testCase) => testCase.scenarioCode))
  const impactedScenarios = [...updateWorkbook.scenariosByCode.values()].filter((scenario) =>
    impactedScenarioCodes.has(scenario.scenarioCode),
  )
  const outputDir = outputDirFor(resolvedUpdatePath)
  const outputPath = path.join(outputDir, `${updateWorkbookName}.delta.sql`)

  fs.mkdirSync(outputDir, { recursive: true })
  fs.writeFileSync(
    outputPath,
    buildDeltaSql({
      testRunName: baseName,
      scenarios: impactedScenarios,
      changedCases,
    }),
    'utf8',
  )

  return {
    baseName,
    basePath: resolvedBasePath,
    baseSource: previousUpdatePath ? 'previous-update' : 'base',
    updatePath: resolvedUpdatePath,
    outputPath,
    baseCaseCount: baseWorkbook.cases.length,
    updateCaseCount: updateWorkbook.cases.length,
    changedCases,
    removedCases,
  }
}

const resolvedInputPath = path.resolve(updatePath)
const updateWorkbookPaths = fs.statSync(resolvedInputPath).isDirectory()
  ? fs
      .readdirSync(resolvedInputPath)
      .filter((filename) => filename.toLowerCase().endsWith('.xlsx'))
      .map((filename) => path.join(resolvedInputPath, filename))
      .sort((left, right) => left.localeCompare(right, 'ko'))
  : [resolvedInputPath]

const results = updateWorkbookPaths.map(processUpdateWorkbook)

for (const result of results) {
  console.log(`Base workbook: ${path.basename(result.basePath)}`)
  console.log(`Base source: ${result.baseSource}`)
  console.log(`Update workbook: ${path.basename(result.updatePath)}`)
  console.log(`Target test run: ${result.baseName}`)
  console.log(`Base case count: ${result.baseCaseCount}`)
  console.log(`Update case count: ${result.updateCaseCount}`)
  console.log(`Changed/new case count: ${result.changedCases.length}`)
  console.log(`Removed case count ignored: ${result.removedCases.length}`)
  console.log(`Changed/new cases: ${result.changedCases.map((testCase) => `${testCase.scenarioCode}/${testCase.caseCode}`).join(', ') || '-'}`)
  console.log(`Output: ${result.outputPath}`)
  console.log('')
}
