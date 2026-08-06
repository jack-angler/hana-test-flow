import { useEffect, useRef, useState } from 'react'
import './App.css'
import CommonDialog from './components/CommonDialog'
import { apiRequest, apiUrl } from './lib/api'

function App() {
  const [currentUser, setCurrentUser] = useState(null)
  const [activeMenu, setActiveMenu] = useState('')
  const [isCheckingSession, setIsCheckingSession] = useState(true)
  const [loginForm, setLoginForm] = useState({
    loginId: '',
    password: '',
    rememberMe: false,
  })
  const [loginMessage, setLoginMessage] = useState('')
  const [isLoggingIn, setIsLoggingIn] = useState(false)
  const [isSignupOpen, setIsSignupOpen] = useState(false)
  const [organizations, setOrganizations] = useState([])
  const [isLoadingOrganizations, setIsLoadingOrganizations] = useState(false)
  const [signupForm, setSignupForm] = useState({
    organizationId: '',
    name: '',
    loginId: '',
    password: '',
    passwordConfirm: '',
  })
  const [signupMessage, setSignupMessage] = useState('')
  const [loginIdCheck, setLoginIdCheck] = useState({
    checkedValue: '',
    available: null,
    message: '',
    isChecking: false,
  })
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [dialog, setDialog] = useState({
    isOpen: false,
    title: '',
    message: '',
  })
  const [testRuns, setTestRuns] = useState([])
  const [scenarios, setScenarios] = useState([])
  const [testCases, setTestCases] = useState([])
  const [selectedTestRunId, setSelectedTestRunId] = useState('')
  const [selectedScenarioId, setSelectedScenarioId] = useState('')
  const [testingMessage, setTestingMessage] = useState('')
  const [isLoadingTesting, setIsLoadingTesting] = useState(false)
  const [isSavingEvidence, setIsSavingEvidence] = useState(false)
  const [evidenceDialog, setEvidenceDialog] = useState({
    isOpen: false,
    testCase: null,
    resultStatus: '',
    description: '',
    estimateNumber: '',
    targetLoginId: '',
    files: [],
    message: '',
    isDragging: false,
    isLoading: false,
  })
  const caseRefs = useRef(new Map())
  const pendingScrollCaseIdRef = useRef(null)
  const evidenceFileInputRef = useRef(null)

  const resultOptions = [
    { value: 'passed', label: '성공' },
    { value: 'failed', label: '실패' },
    { value: 'improvement', label: '개선' },
    { value: 'not_available', label: '테스트불가' },
  ]

  const evidenceStatuses = ['failed', 'improvement', 'not_available']

  const dashboardMenus =
    currentUser?.role === 'admin'
      ? [
          { id: 'status', label: '테스트 현황' },
          { id: 'defects', label: '결함 관리' },
        ]
      : [
          { id: 'testing', label: '통합테스트' },
          { id: 'defects', label: '결함관리' },
        ]

  useEffect(() => {
    const checkSession = async () => {
      try {
        const result = await apiRequest('/me.php')
        setCurrentUser(result.user)
        setActiveMenu(result.user.role === 'admin' ? 'status' : 'testing')
      } catch {
        setCurrentUser(null)
      } finally {
        setIsCheckingSession(false)
      }
    }

    checkSession()
  }, [])

  useEffect(() => {
    if (!currentUser || activeMenu !== 'testing') {
      return
    }

    const loadTestRuns = async () => {
      setTestingMessage('')
      setIsLoadingTesting(true)

      try {
        const result = await apiRequest('/test-runs.php')
        const runs = result.test_runs ?? []

        setTestRuns(runs)
        setSelectedTestRunId((current) => current || String(runs[0]?.id ?? ''))
      } catch (error) {
        setTestingMessage(error.message)
      } finally {
        setIsLoadingTesting(false)
      }
    }

    loadTestRuns()
  }, [activeMenu, currentUser])

  useEffect(() => {
    if (!selectedTestRunId) {
      setScenarios([])
      setSelectedScenarioId('')
      return
    }

    const loadScenarios = async () => {
      setTestingMessage('')
      setIsLoadingTesting(true)

      try {
        const result = await apiRequest(
          `/test-scenarios.php?test_run_id=${encodeURIComponent(
            selectedTestRunId,
          )}`,
        )
        const nextScenarios = result.scenarios ?? []

        setScenarios(nextScenarios)
        setSelectedScenarioId(String(nextScenarios[0]?.id ?? ''))
      } catch (error) {
        setTestingMessage(error.message)
      } finally {
        setIsLoadingTesting(false)
      }
    }

    loadScenarios()
  }, [selectedTestRunId])

  useEffect(() => {
    if (!selectedScenarioId) {
      setTestCases([])
      pendingScrollCaseIdRef.current = null
      return
    }

    const loadTestCases = async () => {
      setTestingMessage('')
      setIsLoadingTesting(true)

      try {
        const result = await apiRequest(
          `/test-cases.php?scenario_id=${encodeURIComponent(
            selectedScenarioId,
          )}`,
        )

        const nextTestCases = result.test_cases ?? []
        const firstNotTestedCase =
          nextTestCases.find((testCase) => testCase.result_status === 'not_tested') ??
          nextTestCases[0]

        pendingScrollCaseIdRef.current = firstNotTestedCase?.id ?? null
        setTestCases(nextTestCases)
      } catch (error) {
        setTestingMessage(error.message)
      } finally {
        setIsLoadingTesting(false)
      }
    }

    loadTestCases()
  }, [selectedScenarioId])

  useEffect(() => {
    const scrollCaseId = pendingScrollCaseIdRef.current

    if (testCases.length === 0 || scrollCaseId === null) {
      return
    }

    const timer = window.setTimeout(() => {
      const target = caseRefs.current.get(scrollCaseId)

      target?.scrollIntoView({
        behavior: 'smooth',
        block: 'start',
      })
      target?.focus({ preventScroll: true })
      pendingScrollCaseIdRef.current = null
    }, 120)

    return () => window.clearTimeout(timer)
  }, [testCases])

  const updateLoginForm = (event) => {
    const { checked, name, type, value } = event.target

    setLoginForm((current) => ({
      ...current,
      [name]: type === 'checkbox' ? checked : value,
    }))
  }

  const updateSignupForm = (event) => {
    const { name, value } = event.target

    setSignupForm((current) => ({
      ...current,
      [name]: value,
    }))

    if (name === 'loginId') {
      setLoginIdCheck({
        checkedValue: '',
        available: null,
        message: '',
        isChecking: false,
      })
    }
  }

  const openSignup = async () => {
    setSignupMessage('')
    setIsSignupOpen(true)
    setIsLoadingOrganizations(true)

    try {
      const result = await apiRequest('/organizations.php')
      setOrganizations(result.organizations ?? [])
    } catch (error) {
      setSignupMessage(error.message)
    } finally {
      setIsLoadingOrganizations(false)
    }
  }

  const closeSignup = () => {
    setIsSignupOpen(false)
    setSignupMessage('')
    setLoginIdCheck({
      checkedValue: '',
      available: null,
      message: '',
      isChecking: false,
    })
  }

  const checkSignupLoginId = async (value) => {
    const loginId = value.trim()

    if (loginId === '') {
      setLoginIdCheck({
        checkedValue: '',
        available: null,
        message: '',
        isChecking: false,
      })
      return
    }

    setLoginIdCheck({
      checkedValue: loginId,
      available: null,
      message: '아이디 중복검사 중입니다.',
      isChecking: true,
    })

    try {
      const result = await apiRequest(
        `/check-login-id.php?login_id=${encodeURIComponent(loginId)}`,
      )

      setLoginIdCheck({
        checkedValue: loginId,
        available: result.available,
        message: result.message,
        isChecking: false,
      })
    } catch (error) {
      setLoginIdCheck({
        checkedValue: loginId,
        available: false,
        message: error.message,
        isChecking: false,
      })
    }
  }

  const submitLogin = async (event) => {
    event.preventDefault()
    setLoginMessage('')
    setIsLoggingIn(true)

    try {
      const result = await apiRequest('/login.php', {
        method: 'POST',
        body: JSON.stringify({
          login_id: loginForm.loginId,
          password: loginForm.password,
          remember_me: loginForm.rememberMe,
        }),
      })

      setCurrentUser(result.user)
      setActiveMenu(result.user.role === 'admin' ? 'status' : 'testing')
      setLoginForm({
        loginId: '',
        password: '',
        rememberMe: false,
      })
    } catch (error) {
      setLoginMessage(error.message)
    } finally {
      setIsLoggingIn(false)
    }
  }

  const logout = async () => {
    try {
      await apiRequest('/logout.php', {
        method: 'POST',
      })
    } finally {
      setCurrentUser(null)
      setActiveMenu('')
    }
  }

  const submitSignup = async (event) => {
    event.preventDefault()
    setSignupMessage('')

    if (signupForm.password !== signupForm.passwordConfirm) {
      setSignupMessage('비밀번호가 일치하지 않습니다.')
      return
    }

    if (
      loginIdCheck.checkedValue !== signupForm.loginId.trim() ||
      loginIdCheck.available !== true
    ) {
      setSignupMessage('아이디 중복검사를 완료해주세요.')
      return
    }

    setIsSubmitting(true)

    try {
      await apiRequest('/register.php', {
        method: 'POST',
        body: JSON.stringify({
          organization_id: Number(signupForm.organizationId),
          name: signupForm.name,
          login_id: signupForm.loginId,
          password: signupForm.password,
          password_confirm: signupForm.passwordConfirm,
        }),
      })

      setSignupForm({
        organizationId: '',
        name: '',
        loginId: '',
        password: '',
        passwordConfirm: '',
      })
      setLoginIdCheck({
        checkedValue: '',
        available: null,
        message: '',
        isChecking: false,
      })
      setIsSignupOpen(false)
      setDialog({
        isOpen: true,
        title: '회원가입 완료',
        message: '회원가입이 완료되었습니다.',
      })
    } catch (error) {
      setSignupMessage(error.message)
    } finally {
      setIsSubmitting(false)
    }
  }

  const scheduleNextCaseScroll = (testCaseId) => {
    const currentIndex = testCases.findIndex(
      (testCase) => String(testCase.id) === String(testCaseId),
    )
    const nextCase = currentIndex >= 0 ? testCases[currentIndex + 1] : null

    pendingScrollCaseIdRef.current = nextCase?.id ?? testCaseId
  }

  const saveTestResult = async (testCaseId, resultStatus) => {
    setTestingMessage('')

    try {
      await apiRequest('/save-test-result.php', {
        method: 'POST',
        body: JSON.stringify({
          test_case_id: testCaseId,
          result_status: resultStatus,
        }),
      })

      setTestCases((current) =>
        current.map((testCase) =>
          testCase.id === testCaseId
            ? {
                ...testCase,
                result_status: resultStatus,
              }
          : testCase,
        ),
      )
      scheduleNextCaseScroll(testCaseId)
    } catch (error) {
      setTestingMessage(error.message)
    }
  }

  const releaseEvidenceFiles = (files) => {
    files.forEach((file) => {
      if (!file.isExisting) {
        URL.revokeObjectURL(file.previewUrl)
      }
    })
  }

  const openEvidenceDialog = async (testCase, resultStatus) => {
    setTestingMessage('')
    setEvidenceDialog((current) => {
      releaseEvidenceFiles(current.files)

      return {
        isOpen: true,
        testCase,
        resultStatus,
        description: testCase.actual_result ?? '',
        estimateNumber: '',
        targetLoginId: '',
        files: [],
        message: '',
        isDragging: false,
        isLoading: true,
      }
    })

    try {
      const result = await apiRequest(
        `/test-result-evidences.php?test_case_id=${encodeURIComponent(
          testCase.id,
        )}`,
      )
      const evidence = result.evidence ?? {}
      const existingFiles = (result.images ?? []).map((image) => ({
        id: `existing-${image.id}`,
        evidenceId: image.id,
        isExisting: true,
        name: image.name || 'attached-image',
        size: image.size ?? 0,
        sourceType: image.source_type ?? 'file',
        previewUrl: apiUrl(`/${image.file_path}`),
      }))

      setEvidenceDialog((current) => {
        if (!current.isOpen || current.testCase?.id !== testCase.id) {
          return current
        }

        return {
          ...current,
          description: evidence.memo ?? testCase.actual_result ?? '',
          estimateNumber: evidence.estimate_number ?? '',
          targetLoginId: evidence.target_login_id ?? '',
          files: existingFiles,
          message: '',
          isLoading: false,
        }
      })
    } catch (error) {
      setEvidenceDialog((current) => ({
        ...current,
        message: error.message,
        isLoading: false,
      }))
    }
  }

  const closeEvidenceDialog = (force = false) => {
    if (isSavingEvidence && !force) {
      return
    }

    setEvidenceDialog((current) => {
      releaseEvidenceFiles(current.files)

      return {
        isOpen: false,
        testCase: null,
        resultStatus: '',
        description: '',
        estimateNumber: '',
        targetLoginId: '',
        files: [],
        message: '',
        isDragging: false,
        isLoading: false,
      }
    })
  }

  const updateEvidenceDialog = (event) => {
    const { name, value } = event.target

    setEvidenceDialog((current) => ({
      ...current,
      [name]: value,
    }))
  }

  const addEvidenceFiles = (files, sourceType = 'file') => {
    const imageFiles = Array.from(files).filter((file) =>
      file.type.startsWith('image/'),
    )

    if (imageFiles.length === 0) {
      setEvidenceDialog((current) => ({
        ...current,
        message: '이미지 파일만 첨부할 수 있습니다.',
      }))
      return
    }

    const nextFiles = imageFiles.map((file) => ({
      id: `${Date.now()}-${crypto.randomUUID()}`,
      file,
      isExisting: false,
      name: file.name || 'clipboard-image.png',
      size: file.size,
      sourceType,
      previewUrl: URL.createObjectURL(file),
    }))

    setEvidenceDialog((current) => ({
      ...current,
      files: [...current.files, ...nextFiles],
      message: '',
    }))
  }

  const removeEvidenceFile = (fileId) => {
    setEvidenceDialog((current) => {
      const fileToRemove = current.files.find((file) => file.id === fileId)

      if (fileToRemove && !fileToRemove.isExisting) {
        URL.revokeObjectURL(fileToRemove.previewUrl)
      }

      return {
        ...current,
        files: current.files.filter((file) => file.id !== fileId),
      }
    })
  }

  const handleEvidencePaste = (event) => {
    const files = Array.from(event.clipboardData?.items ?? [])
      .filter((item) => item.type.startsWith('image/'))
      .map((item) => item.getAsFile())
      .filter(Boolean)

    if (files.length > 0) {
      event.preventDefault()
      addEvidenceFiles(files, 'clipboard')
    }
  }

  const submitEvidenceResult = async (event) => {
    event.preventDefault()

    if (!evidenceDialog.testCase) {
      return
    }

    const selectedResultStatus = evidenceDialog.resultStatus

    if (!evidenceStatuses.includes(selectedResultStatus)) {
      setEvidenceDialog((current) => ({
        ...current,
        message: '테스트 결과를 다시 선택해 주세요.',
      }))
      return
    }

    setIsSavingEvidence(true)
    setEvidenceDialog((current) => ({
      ...current,
      message: '',
    }))

    const formData = new FormData()
    formData.append('test_case_id', String(evidenceDialog.testCase.id))
    formData.append('result_status', selectedResultStatus)
    formData.append('actual_result', evidenceDialog.description)
    formData.append('evidence_memo', evidenceDialog.description)
    formData.append('estimate_number', evidenceDialog.estimateNumber)
    formData.append('target_login_id', evidenceDialog.targetLoginId)
    formData.append(
      'source_type',
      evidenceDialog.files.some((file) => file.sourceType === 'clipboard')
        ? 'clipboard'
        : 'file',
    )
    formData.append(
      'retained_evidence_ids',
      JSON.stringify(
        evidenceDialog.files
          .filter((file) => file.isExisting)
          .map((file) => file.evidenceId),
      ),
    )

    evidenceDialog.files.filter((file) => !file.isExisting).forEach((file) => {
      formData.append('evidence_images[]', file.file, file.name)
    })

    try {
      await apiRequest('/save-test-result.php', {
        method: 'POST',
        body: formData,
      })

      scheduleNextCaseScroll(evidenceDialog.testCase.id)
      setTestCases((current) =>
        current.map((testCase) =>
          testCase.id === evidenceDialog.testCase.id
            ? {
                ...testCase,
                result_status: selectedResultStatus,
                actual_result: evidenceDialog.description,
              }
            : testCase,
        ),
      )
      closeEvidenceDialog(true)
    } catch (error) {
      setEvidenceDialog((current) => ({
        ...current,
        message: error.message,
      }))
    } finally {
      setIsSavingEvidence(false)
    }
  }

  const renderDashboardContent = () => {
    if (activeMenu === 'testing') {
      return (
        <section className="test-workspace">
          <div className="test-column is-runs">
            <div className="column-header">
              <h2>통합테스트 진행명</h2>
            </div>
            <div className="select-list">
              {testRuns.map((testRun) => (
                <button
                  key={testRun.id}
                  type="button"
                  className={
                    String(testRun.id) === selectedTestRunId ? 'is-selected' : ''
                  }
                  onClick={() => setSelectedTestRunId(String(testRun.id))}
                >
                  {testRun.name}
                </button>
              ))}
              {testRuns.length === 0 && (
                <p className="empty-message">등록된 진행명이 없습니다.</p>
              )}
            </div>
          </div>

          <div className="test-column is-scenarios">
            <div className="column-header">
              <h2>시나리오</h2>
            </div>
            <div className="select-list">
              {scenarios.map((scenario) => (
                <button
                  key={scenario.id}
                  type="button"
                  className={
                    String(scenario.id) === selectedScenarioId
                      ? 'is-selected'
                      : ''
                  }
                  onClick={() => setSelectedScenarioId(String(scenario.id))}
                >
                  <strong>{scenario.scenario_code}</strong>
                  <span>{scenario.name}</span>
                  <em>{scenario.case_count}건</em>
                </button>
              ))}
              {selectedTestRunId && scenarios.length === 0 && (
                <p className="empty-message">등록된 시나리오가 없습니다.</p>
              )}
            </div>
          </div>

          <div className="test-column is-cases">
            <div className="column-header">
              <h2>케이스</h2>
              {isLoadingTesting && <span>불러오는 중</span>}
            </div>
            <div className="case-list">
              {testCases.map((testCase) => {
                const isNotTested = testCase.result_status === 'not_tested'

                return (
                <article
                  key={testCase.id}
                  ref={(element) => {
                    if (element) {
                      caseRefs.current.set(testCase.id, element)
                    } else {
                      caseRefs.current.delete(testCase.id)
                    }
                  }}
                  tabIndex={-1}
                  className={`case-item result-${testCase.result_status}`}
                >
                  <div className="case-title">
                    <strong>{testCase.case_code}</strong>
                    <span>{isNotTested ? '미수행' : '수행완료'}</span>
                  </div>
                  <h3>{testCase.name}</h3>
                  <div className="result-buttons" aria-label="테스트 결과 선택">
                    {resultOptions.map((option) => (
                      <button
                        key={option.value}
                        type="button"
                        className={
                          testCase.result_status === option.value
                            ? 'is-selected'
                            : ''
                        }
                        onClick={() =>
                          evidenceStatuses.includes(option.value)
                            ? openEvidenceDialog(testCase, option.value)
                            : saveTestResult(testCase.id, option.value)
                        }
                      >
                        {option.label}
                      </button>
                    ))}
                  </div>
                  <dl>
                    <div>
                      <dt>메뉴</dt>
                      <dd>{testCase.scenario_menu || '-'}</dd>
                    </div>
                    <div>
                      <dt>위치</dt>
                      <dd>{testCase.location || '-'}</dd>
                    </div>
                    <div>
                      <dt>사전조건</dt>
                      <dd>{testCase.precondition || '-'}</dd>
                    </div>
                    <div>
                      <dt>테스트 스텝</dt>
                      <dd>{testCase.test_steps || '-'}</dd>
                    </div>
                    <div>
                      <dt>예상결과</dt>
                      <dd>{testCase.expected_result || '-'}</dd>
                    </div>
                  </dl>
                </article>
                )
              })}
              {selectedScenarioId && testCases.length === 0 && (
                <p className="empty-message">등록된 케이스가 없습니다.</p>
              )}
            </div>
            {testingMessage && <p className="form-message is-error">{testingMessage}</p>}
          </div>
        </section>
      )
    }

    return (
      <div className="welcome-panel">
        <p className="user-role">
          {currentUser.role === 'admin' ? '관리자' : '테스터'}
        </p>
        <h1>{dashboardMenus.find((menu) => menu.id === activeMenu)?.label}</h1>
        <p>{currentUser.organization} 소속으로 로그인되었습니다.</p>
      </div>
    )
  }

  if (isCheckingSession) {
    return (
      <main className="app-shell">
        <div className="loading-box">확인 중</div>
      </main>
    )
  }

  if (currentUser) {
    return (
      <main className="dashboard-shell">
        <header className="dashboard-header">
          <div className="dashboard-brand">
            <img src="/hana-ci.svg" alt="" className="dashboard-ci" />
            <div>
              <p className="dashboard-title">하나원큐오토 웹기반 플랫폼 구축</p>
              <p className="dashboard-subtitle">통합테스트</p>
            </div>
          </div>

          <nav className="dashboard-nav" aria-label="상단 메뉴">
            {dashboardMenus.map((menu) => (
              <button
                key={menu.id}
                type="button"
                className={activeMenu === menu.id ? 'is-active' : ''}
                onClick={() => setActiveMenu(menu.id)}
              >
                {menu.label}
              </button>
            ))}
          </nav>

          <div className="dashboard-user">
            <div>
              <strong>{currentUser.name}</strong>
              <span>{currentUser.role === 'admin' ? '관리자' : '테스터'}</span>
            </div>
            <button type="button" className="logout-button" onClick={logout}>
              로그아웃
            </button>
          </div>
        </header>

        <section className="dashboard-main">
          {renderDashboardContent()}
        </section>

        {evidenceDialog.isOpen && (
          <div className="modal-backdrop" role="presentation">
            <form
              className="evidence-modal"
              onSubmit={submitEvidenceResult}
              onPaste={handleEvidencePaste}
            >
              <div className="modal-header">
                <div>
                  <h2>결과 증빙 등록</h2>
                  <p>
                    {evidenceDialog.testCase?.case_code} ·{' '}
                    {
                      resultOptions.find(
                        (option) => option.value === evidenceDialog.resultStatus,
                      )?.label
                    }
                  </p>
                </div>
                <button
                  type="button"
                  className="close-button"
                  aria-label="닫기"
                  onClick={() => closeEvidenceDialog()}
                >
                  x
                </button>
              </div>

              {evidenceDialog.isLoading && (
                <p className="form-message">기존 증빙을 불러오는 중입니다.</p>
              )}

              <label>
                <span>설명</span>
                <textarea
                  name="description"
                  value={evidenceDialog.description}
                  onChange={updateEvidenceDialog}
                  placeholder="확인한 현상, 재현 조건, 기대와 다른 부분을 적어주세요."
                  rows={5}
                />
              </label>

              <div className="evidence-field-grid">
                <label>
                  <span>견적번호(선택)</span>
                  <input
                    type="text"
                    name="estimateNumber"
                    value={evidenceDialog.estimateNumber}
                    onChange={updateEvidenceDialog}
                    placeholder="선택 입력"
                  />
                </label>
                <label>
                  <span>로그인ID(선택)</span>
                  <input
                    type="text"
                    name="targetLoginId"
                    value={evidenceDialog.targetLoginId}
                    onChange={updateEvidenceDialog}
                    placeholder="선택 입력"
                  />
                </label>
              </div>

              <div
                className={`evidence-dropzone ${
                  evidenceDialog.isDragging ? 'is-dragging' : ''
                }`}
                onDragOver={(event) => {
                  event.preventDefault()
                  setEvidenceDialog((current) => ({
                    ...current,
                    isDragging: true,
                  }))
                }}
                onDragLeave={() =>
                  setEvidenceDialog((current) => ({
                    ...current,
                    isDragging: false,
                  }))
                }
                onDrop={(event) => {
                  event.preventDefault()
                  setEvidenceDialog((current) => ({
                    ...current,
                    isDragging: false,
                  }))
                  addEvidenceFiles(event.dataTransfer.files)
                }}
              >
                <strong>이미지 첨부</strong>
                <span>파일을 끌어오거나, 이 창에서 캡처 이미지를 붙여넣으세요(Ctrl + V)</span>
                <button
                  type="button"
                  className="secondary-button"
                  onClick={() => evidenceFileInputRef.current?.click()}
                >
                  파일 선택
                </button>
                <input
                  ref={evidenceFileInputRef}
                  type="file"
                  accept="image/*"
                  multiple
                  onChange={(event) => {
                    addEvidenceFiles(event.target.files)
                    event.target.value = ''
                  }}
                />
              </div>

              {evidenceDialog.files.length > 0 && (
                <div className="evidence-preview-list">
                  {evidenceDialog.files.map((file) => (
                    <div key={file.id} className="evidence-preview">
                      <img src={file.previewUrl} alt="" />
                      <div>
                        <strong>{file.name}</strong>
                        <span>
                          {file.isExisting ? '기존 첨부' : '새 첨부'} ·{' '}
                          {Math.ceil(file.size / 1024).toLocaleString()} KB
                        </span>
                      </div>
                      <button
                        type="button"
                        aria-label="첨부 제거"
                        onClick={() => removeEvidenceFile(file.id)}
                      >
                        x
                      </button>
                    </div>
                  ))}
                </div>
              )}

              {evidenceDialog.message && (
                <p className="form-message is-error">{evidenceDialog.message}</p>
              )}

              <button
                type="submit"
                className="primary-button"
                disabled={isSavingEvidence || evidenceDialog.isLoading}
              >
                {isSavingEvidence ? '저장 중' : '결과 저장'}
              </button>
            </form>
          </div>
        )}
      </main>
    )
  }

  return (
    <main className="app-shell">
      <form className="login-box" onSubmit={submitLogin}>
        <div className="brand">
          <p className="brand-name">
            하나원큐오토 웹기반 플랫폼 구축
            <span>통합테스트</span>
          </p>
        </div>

        <label>
          <span>아이디</span>
          <input
            type="text"
            name="loginId"
            autoComplete="username"
            value={loginForm.loginId}
            onChange={updateLoginForm}
          />
        </label>

        <label>
          <span>비밀번호</span>
          <input
            type="password"
            name="password"
            autoComplete="current-password"
            value={loginForm.password}
            onChange={updateLoginForm}
          />
        </label>

        <label className="checkbox-label">
          <input
            type="checkbox"
            name="rememberMe"
            checked={loginForm.rememberMe}
            onChange={updateLoginForm}
          />
          <span>자동로그인</span>
        </label>

        {loginMessage && <p className="form-message">{loginMessage}</p>}

        <button type="submit" className="primary-button" disabled={isLoggingIn}>
          {isLoggingIn ? '확인 중' : '로그인'}
        </button>

        <button type="button" className="secondary-button" onClick={openSignup}>
          회원가입
        </button>
      </form>

      {isSignupOpen && (
        <div className="modal-backdrop" role="presentation">
          <form className="signup-modal" onSubmit={submitSignup}>
            <div className="modal-header">
              <h2>회원가입</h2>
              <button
                type="button"
                className="close-button"
                aria-label="닫기"
                onClick={closeSignup}
              >
                ×
              </button>
            </div>

            <label>
              <span>소속</span>
              <select
                name="organizationId"
                value={signupForm.organizationId}
                onChange={updateSignupForm}
                disabled={isLoadingOrganizations}
              >
                <option value="">
                  {isLoadingOrganizations ? '불러오는 중' : '소속 선택'}
                </option>
                {organizations.map((organization) => (
                  <option key={organization.id} value={organization.id}>
                    {organization.name}
                  </option>
                ))}
              </select>
            </label>

            <label>
              <span>이름</span>
              <input
                type="text"
                name="name"
                value={signupForm.name}
                onChange={updateSignupForm}
              />
            </label>

            <label>
              <span>아이디</span>
              <input
                type="text"
                name="loginId"
                autoComplete="username"
                value={signupForm.loginId}
                onChange={updateSignupForm}
                onBlur={(event) => checkSignupLoginId(event.currentTarget.value)}
              />
            </label>

            {loginIdCheck.message && (
              <p
                className={
                  loginIdCheck.available
                    ? 'form-message is-success'
                    : loginIdCheck.isChecking
                      ? 'form-message'
                      : 'form-message is-error'
                }
              >
                {loginIdCheck.message}
              </p>
            )}

            <label>
              <span>비밀번호</span>
              <input
                type="password"
                name="password"
                autoComplete="new-password"
                value={signupForm.password}
                onChange={updateSignupForm}
              />
            </label>

            <label>
              <span>비밀번호 확인</span>
              <input
                type="password"
                name="passwordConfirm"
                autoComplete="new-password"
                value={signupForm.passwordConfirm}
                onChange={updateSignupForm}
              />
            </label>

            {signupMessage && <p className="form-message">{signupMessage}</p>}

            <button
              type="submit"
              className="primary-button"
              disabled={isSubmitting}
            >
              {isSubmitting ? '처리 중' : '가입하기'}
            </button>
          </form>
        </div>
      )}

      <CommonDialog
        isOpen={dialog.isOpen}
        title={dialog.title}
        message={dialog.message}
        onConfirm={() =>
          setDialog({
            isOpen: false,
            title: '',
            message: '',
          })
        }
      />
    </main>
  )
}

export default App
