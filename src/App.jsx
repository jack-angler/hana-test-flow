import { useEffect, useRef, useState } from 'react'
import './App.css'
import CommonDialog from './components/CommonDialog'
import { apiRequest } from './lib/api'

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
  const firstNotTestedCaseRef = useRef(null)

  const resultOptions = [
    { value: 'passed', label: '성공' },
    { value: 'failed', label: '실패' },
    { value: 'improvement', label: '개선' },
    { value: 'not_available', label: '테스트불가' },
  ]

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

        setTestCases(result.test_cases ?? [])
      } catch (error) {
        setTestingMessage(error.message)
      } finally {
        setIsLoadingTesting(false)
      }
    }

    loadTestCases()
  }, [selectedScenarioId])

  useEffect(() => {
    if (testCases.length === 0) {
      return
    }

    const timer = window.setTimeout(() => {
      firstNotTestedCaseRef.current?.scrollIntoView({
        behavior: 'smooth',
        block: 'start',
      })
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
    } catch (error) {
      setTestingMessage(error.message)
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
                const isFirstNotTested =
                  isNotTested &&
                  testCases.find((item) => item.result_status === 'not_tested')
                    ?.id === testCase.id

                return (
                <article
                  key={testCase.id}
                  ref={isFirstNotTested ? firstNotTestedCaseRef : null}
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
                        onClick={() => saveTestResult(testCase.id, option.value)}
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
