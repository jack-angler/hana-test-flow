import { useEffect, useRef, useState } from "react";
import "./App.css";
import CommonDialog from "./components/CommonDialog";
import HelpContent from "./components/HelpContent";
import { apiRequest, apiUrl } from "./lib/api";

const testLoginAccounts = [
  { loginId: "P260511", password: "capital1!", label: "P260511" },
  { loginId: "admin", password: "capital1!", label: "admin" },
  { loginId: "nicecast", password: "0000", label: "nicecast" },
];

function App() {
  const [currentUser, setCurrentUser] = useState(null);
  const [activeMenu, setActiveMenu] = useState("");
  const [isCheckingSession, setIsCheckingSession] = useState(true);
  const [testLoginMessage, setTestLoginMessage] = useState("");
  const [testLoginLoadingId, setTestLoginLoadingId] = useState("");
  const [loginForm, setLoginForm] = useState({
    loginId: "",
    password: "",
    rememberMe: false,
  });
  const [loginMessage, setLoginMessage] = useState("");
  const [isLoggingIn, setIsLoggingIn] = useState(false);
  const [isPublicHelpOpen, setIsPublicHelpOpen] = useState(false);
  const [isSignupOpen, setIsSignupOpen] = useState(false);
  const [organizations, setOrganizations] = useState([]);
  const [isLoadingOrganizations, setIsLoadingOrganizations] = useState(false);
  const [signupForm, setSignupForm] = useState({
    organizationId: "",
    name: "",
    loginId: "",
    password: "",
    passwordConfirm: "",
  });
  const [signupMessage, setSignupMessage] = useState("");
  const [loginIdCheck, setLoginIdCheck] = useState({
    checkedValue: "",
    available: null,
    message: "",
    isChecking: false,
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [dialog, setDialog] = useState({
    isOpen: false,
    title: "",
    message: "",
    confirmText: "확인",
    cancelText: "",
    onConfirm: null,
    onCancel: null,
  });
  const [testRuns, setTestRuns] = useState([]);
  const [scenarios, setScenarios] = useState([]);
  const [testCases, setTestCases] = useState([]);
  const [selectedTestRunId, setSelectedTestRunId] = useState("");
  const [selectedScenarioId, setSelectedScenarioId] = useState("");
  const [testingMessage, setTestingMessage] = useState("");
  const [isLoadingTesting, setIsLoadingTesting] = useState(false);
  const [isSavingEvidence, setIsSavingEvidence] = useState(false);
  const [evidenceDialog, setEvidenceDialog] = useState({
    isOpen: false,
    testCase: null,
    resultStatus: "",
    description: "",
    estimateNumber: "",
    targetLoginId: "",
    files: [],
    message: "",
    isDragging: false,
    isLoading: false,
    mode: "test",
  });
  const [manualDefectDialog, setManualDefectDialog] = useState({
    isOpen: false,
    mode: "create",
    defectId: null,
    resultStatus: "failed",
    title: "",
    manualLocation: "",
    description: "",
    files: [],
    message: "",
    isDragging: false,
  });
  const [defects, setDefects] = useState([]);
  const [dashboardDefects, setDashboardDefects] = useState([]);
  const [defectCounts, setDefectCounts] = useState({});
  const [defectPagination, setDefectPagination] = useState({
    page: 1,
    pageSize: 30,
    total: 0,
    hasMore: false,
    nextPage: null,
  });
  const [assignees, setAssignees] = useState([]);
  const [selectedDefectId, setSelectedDefectId] = useState("");
  const [defectStatusFilter, setDefectStatusFilter] = useState("open");
  const [selectedAssigneeId, setSelectedAssigneeId] = useState("");
  const [defectActionMemo, setDefectActionMemo] = useState("");
  const [defectMessage, setDefectMessage] = useState("");
  const [isLoadingDefects, setIsLoadingDefects] = useState(false);
  const [isSavingDefect, setIsSavingDefect] = useState(false);
  const [dashboardSummary, setDashboardSummary] = useState(null);
  const [dashboardMessage, setDashboardMessage] = useState("");
  const [isLoadingDashboard, setIsLoadingDashboard] = useState(false);
  const [actionFiles, setActionFiles] = useState([]);
  const [isDraggingActionFiles, setIsDraggingActionFiles] = useState(false);
  const [expandedEvidenceImage, setExpandedEvidenceImage] = useState(null);
  const defectListRef = useRef(null);
  const defectDetailRef = useRef(null);
  const pendingDefectScrollResetRef = useRef(false);
  const caseRefs = useRef(new Map());
  const pendingScrollRef = useRef(null);
  const evidenceFileInputRef = useRef(null);
  const manualDefectFileInputRef = useRef(null);
  const manualDefectTitleRef = useRef(null);
  const manualDefectLocationRef = useRef(null);
  const manualDefectDescriptionRef = useRef(null);
  const actionFileInputRef = useRef(null);
  const evidenceDescriptionRef = useRef(null);
  const isTestLoginPath = /\/test-login\/?$/.test(window.location.pathname);
  const appRootPath = isTestLoginPath
    ? window.location.pathname.replace(/\/test-login\/?$/, "/")
    : "/";
  const evidenceEstimateNumberRef = useRef(null);
  const evidenceTargetLoginIdRef = useRef(null);

  const resultOptions = [
    { value: "passed", label: "성공" },
    { value: "failed", label: "실패" },
    { value: "improvement", label: "개선" },
    { value: "not_available", label: "테스트불가" },
  ];

  const evidenceStatuses = ["failed", "improvement", "not_available"];

  const defectStatusLabels = {
    received: "접수",
    assigned: "조치 필요",
    tester_confirmation_pending: "조치완료",
    verification_completed: "확인완료",
  };
  const defectDisplayStatuses = Object.keys(defectStatusLabels);

  const roleLabels = {
    admin: "관리자",
    project: "프로젝트 팀",
    tester: "테스터",
  };

  const currentRoleLabel = roleLabels[currentUser?.role] ?? "테스터";
  const canSubmitTestResult =
    currentUser?.role === "tester" || currentUser?.login_id === "P260513";
  const isReadOnlyTesting = !canSubmitTestResult;
  const testerConfirmationPendingStatuses = [
    "action_completed",
    "tester_confirmation_pending",
  ];

  const normalizeDefectStatus = (status) =>
    status === "action_completed" ? "tester_confirmation_pending" : status;

  const getDefectStatusLabel = (status, role = currentUser?.role) => {
    const normalizedStatus = normalizeDefectStatus(status);

    if (
      normalizedStatus === "tester_confirmation_pending" &&
      role === "tester"
    ) {
      return "확인 필요";
    }

    return defectStatusLabels[normalizedStatus] ?? status;
  };

  const getIntegrationTestDday = () => {
    const today = new Date();
    const targetDate = new Date(2026, 7, 28);
    const todayStart = new Date(
      today.getFullYear(),
      today.getMonth(),
      today.getDate(),
    );
    const targetStart = new Date(
      targetDate.getFullYear(),
      targetDate.getMonth(),
      targetDate.getDate(),
    );
    const diffDays = Math.ceil(
      (targetStart.getTime() - todayStart.getTime()) / 86_400_000,
    );

    if (diffDays > 0) {
      return `D-${diffDays}`;
    }

    if (diffDays === 0) {
      return "D-Day";
    }

    return `D+${Math.abs(diffDays)}`;
  };

  const formatDateTime = (value) => {
    if (!value) {
      return "-";
    }

    const normalizedValue = String(value).replace(" ", "T");
    const date = new Date(normalizedValue);

    if (Number.isNaN(date.getTime())) {
      return String(value).slice(0, 16).replaceAll("-", ".");
    }

    const pad = (number) => String(number).padStart(2, "0");

    return `${date.getFullYear()}.${pad(date.getMonth() + 1)}.${pad(
      date.getDate(),
    )} ${pad(date.getHours())}:${pad(date.getMinutes())}`;
  };

  const createClientId = () => {
    if (typeof crypto !== "undefined" && crypto.randomUUID) {
      return crypto.randomUUID();
    }

    return `${Date.now()}-${Math.random().toString(36).slice(2, 11)}`;
  };

  const closeDialog = () => {
    setDialog({
      isOpen: false,
      title: "",
      message: "",
      confirmText: "확인",
      cancelText: "",
      onConfirm: null,
      onCancel: null,
    });
  };

  const dashboardMenus =
    currentUser?.role === "admin"
      ? [
          { id: "dashboard", label: "대시보드" },
          { id: "testing", label: "통합테스트" },
          { id: "defects", label: "결함 관리" },
          { id: "help", label: "도움말" },
        ]
      : currentUser?.role === "project"
        ? [
            { id: "dashboard", label: "대시보드" },
            { id: "testing", label: "통합테스트" },
            { id: "defects", label: "결함 처리" },
            { id: "help", label: "도움말" },
          ]
        : [
            { id: "dashboard", label: "대시보드" },
            { id: "testing", label: "통합테스트" },
            { id: "defects", label: "결함관리" },
            { id: "help", label: "도움말" },
          ];
  useEffect(() => {
    const checkSession = async () => {
      try {
        const result = await apiRequest("/me.php");
        setCurrentUser(result.user);
        setActiveMenu("dashboard");
      } catch {
        setCurrentUser(null);
      } finally {
        setIsCheckingSession(false);
      }
    };

    checkSession();
  }, []);

  useEffect(() => {
    if (!currentUser || activeMenu !== "testing") {
      return;
    }

    const loadTestRuns = async () => {
      setTestingMessage("");
      setIsLoadingTesting(true);

      try {
        const result = await apiRequest("/test-runs.php");
        const runs = result.test_runs ?? [];

        setTestRuns(runs);
        setSelectedTestRunId((current) => current || String(runs[0]?.id ?? ""));
      } catch (error) {
        setTestingMessage(error.message);
      } finally {
        setIsLoadingTesting(false);
      }
    };

    loadTestRuns();
  }, [activeMenu, currentUser]);

  useEffect(() => {
    if (!selectedTestRunId) {
      setScenarios([]);
      setSelectedScenarioId("");
      return;
    }

    const loadScenarios = async () => {
      setTestingMessage("");
      setIsLoadingTesting(true);

      try {
        const result = await apiRequest(
          `/test-scenarios.php?test_run_id=${encodeURIComponent(
            selectedTestRunId,
          )}`,
        );
        const nextScenarios = result.scenarios ?? [];

        setScenarios(nextScenarios);
        setSelectedScenarioId(String(nextScenarios[0]?.id ?? ""));
      } catch (error) {
        setTestingMessage(error.message);
      } finally {
        setIsLoadingTesting(false);
      }
    };

    loadScenarios();
  }, [selectedTestRunId]);

  useEffect(() => {
    if (!selectedScenarioId) {
      setTestCases([]);
      pendingScrollRef.current = null;
      return;
    }

    const loadTestCases = async () => {
      setTestingMessage("");
      setIsLoadingTesting(true);

      try {
        const result = await apiRequest(
          `/test-cases.php?scenario_id=${encodeURIComponent(
            selectedScenarioId,
          )}`,
        );

        const nextTestCases = result.test_cases ?? [];
        const firstNotTestedCase =
          nextTestCases.find(
            (testCase) => testCase.result_status === "not_tested",
          ) ?? nextTestCases[0];

        pendingScrollRef.current = firstNotTestedCase
          ? { caseId: firstNotTestedCase.id, block: "start" }
          : null;
        setTestCases(nextTestCases);
      } catch (error) {
        setTestingMessage(error.message);
      } finally {
        setIsLoadingTesting(false);
      }
    };

    loadTestCases();
  }, [selectedScenarioId]);

  useEffect(() => {
    if (
      !currentUser ||
      (activeMenu !== "defects" &&
        !(activeMenu === "dashboard" && currentUser.role !== "admin"))
    ) {
      return;
    }

    if (activeMenu === "defects") {
      loadDefects({ page: 1, append: false, status: defectStatusFilter });
    } else {
      loadDashboardDefects();
    }

    if (currentUser.role === "admin") {
      loadAssignees();
    }
  }, [activeMenu, currentUser, defectStatusFilter]);

  useEffect(() => {
    if (!currentUser) {
      return;
    }

    setDefectStatusFilter(
      currentUser.role === "admin"
        ? "received"
        : currentUser.role === "tester"
          ? "tester_confirmation_pending"
          : "assigned",
    );
  }, [currentUser]);

  useEffect(() => {
    if (
      !currentUser ||
      currentUser.role !== "admin" ||
      !["dashboard", "status"].includes(activeMenu)
    ) {
      return;
    }

    loadDashboardSummary();
  }, [activeMenu, currentUser]);

  useEffect(() => {
    const selectedDefect = defects.find(
      (defect) => String(defect.id) === selectedDefectId,
    );

    setSelectedAssigneeId(String(selectedDefect?.assignee_user_id ?? ""));
    setDefectActionMemo(selectedDefect?.action_memo ?? "");
    setIsDraggingActionFiles(false);
    setActionFiles((current) => {
      releaseEvidenceFiles(current);
      return [];
    });

    if (pendingDefectScrollResetRef.current) {
      const timer = window.setTimeout(() => {
        resetDefectScroll();
        pendingDefectScrollResetRef.current = false;
      }, 0);

      return () => window.clearTimeout(timer);
    }
  }, [defects, selectedDefectId]);

  useEffect(() => {
    const pendingScroll = pendingScrollRef.current;

    if (testCases.length === 0 || pendingScroll === null) {
      return;
    }

    const timer = window.setTimeout(() => {
      const target = caseRefs.current.get(pendingScroll.caseId);

      target?.scrollIntoView({
        behavior: "smooth",
        block: pendingScroll.block,
      });
      target?.focus({ preventScroll: true });
      pendingScrollRef.current = null;
    }, 120);

    return () => window.clearTimeout(timer);
  }, [testCases]);

  const updateLoginForm = (event) => {
    const { checked, name, type, value } = event.target;

    setLoginForm((current) => ({
      ...current,
      [name]: type === "checkbox" ? checked : value,
    }));
  };

  const updateSignupForm = (event) => {
    const { name, value } = event.target;

    setSignupForm((current) => ({
      ...current,
      [name]: value,
    }));

    if (name === "loginId") {
      setLoginIdCheck({
        checkedValue: "",
        available: null,
        message: "",
        isChecking: false,
      });
    }
  };

  const openSignup = async () => {
    setSignupMessage("");
    setIsSignupOpen(true);
    setIsLoadingOrganizations(true);

    try {
      const result = await apiRequest("/organizations.php");
      setOrganizations(result.organizations ?? []);
    } catch (error) {
      setSignupMessage(error.message);
    } finally {
      setIsLoadingOrganizations(false);
    }
  };

  const closeSignup = () => {
    setIsSignupOpen(false);
    setSignupMessage("");
    setLoginIdCheck({
      checkedValue: "",
      available: null,
      message: "",
      isChecking: false,
    });
  };

  const checkSignupLoginId = async (value) => {
    const loginId = value.trim();

    if (loginId === "") {
      setLoginIdCheck({
        checkedValue: "",
        available: null,
        message: "",
        isChecking: false,
      });
      return;
    }

    setLoginIdCheck({
      checkedValue: loginId,
      available: null,
      message: "아이디 중복검사 중입니다.",
      isChecking: true,
    });

    try {
      const result = await apiRequest(
        `/check-login-id.php?login_id=${encodeURIComponent(loginId)}`,
      );

      setLoginIdCheck({
        checkedValue: loginId,
        available: result.available,
        message: result.message,
        isChecking: false,
      });
    } catch (error) {
      setLoginIdCheck({
        checkedValue: loginId,
        available: false,
        message: error.message,
        isChecking: false,
      });
    }
  };

  const submitLogin = async (event) => {
    event.preventDefault();
    setLoginMessage("");
    setIsLoggingIn(true);

    try {
      const result = await apiRequest("/login.php", {
        method: "POST",
        body: JSON.stringify({
          login_id: loginForm.loginId,
          password: loginForm.password,
          remember_me: loginForm.rememberMe,
        }),
      });

      setCurrentUser(result.user);
      setActiveMenu("dashboard");
      setLoginForm({
        loginId: "",
        password: "",
        rememberMe: false,
      });
    } catch (error) {
      setLoginMessage(error.message);
    } finally {
      setIsLoggingIn(false);
    }
  };

  const loginWithTestAccount = async (account) => {
    setTestLoginMessage("");
    setTestLoginLoadingId(account.loginId);

    try {
      const result = await apiRequest("/login.php", {
        method: "POST",
        body: JSON.stringify({
          login_id: account.loginId,
          password: account.password,
          remember_me: false,
        }),
      });

      setCurrentUser(result.user);
      setActiveMenu("dashboard");
      window.history.replaceState(null, "", appRootPath);
    } catch (error) {
      setTestLoginMessage(error.message);
    } finally {
      setTestLoginLoadingId("");
    }
  };

  const logout = async () => {
    try {
      await apiRequest("/logout.php", {
        method: "POST",
      });
    } finally {
      setCurrentUser(null);
      setActiveMenu("");
    }
  };

  const submitSignup = async (event) => {
    event.preventDefault();
    setSignupMessage("");

    if (signupForm.password !== signupForm.passwordConfirm) {
      setSignupMessage("비밀번호가 일치하지 않습니다.");
      return;
    }

    if (
      loginIdCheck.checkedValue !== signupForm.loginId.trim() ||
      loginIdCheck.available !== true
    ) {
      setSignupMessage("아이디 중복검사를 완료해주세요.");
      return;
    }

    setIsSubmitting(true);

    try {
      await apiRequest("/register.php", {
        method: "POST",
        body: JSON.stringify({
          organization_id: Number(signupForm.organizationId),
          name: signupForm.name,
          login_id: signupForm.loginId,
          password: signupForm.password,
          password_confirm: signupForm.passwordConfirm,
        }),
      });

      setSignupForm({
        organizationId: "",
        name: "",
        loginId: "",
        password: "",
        passwordConfirm: "",
      });
      setLoginIdCheck({
        checkedValue: "",
        available: null,
        message: "",
        isChecking: false,
      });
      setIsSignupOpen(false);
      setDialog({
        isOpen: true,
        title: "회원가입 완료",
        message: "회원가입이 완료되었습니다.",
        confirmText: "확인",
        cancelText: "",
        onConfirm: closeDialog,
        onCancel: null,
      });
    } catch (error) {
      setSignupMessage(error.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const scheduleNextCaseScroll = (testCaseId) => {
    const currentIndex = testCases.findIndex(
      (testCase) => String(testCase.id) === String(testCaseId),
    );
    const nextCase = currentIndex >= 0 ? testCases[currentIndex + 1] : null;

    pendingScrollRef.current = {
      caseId: nextCase?.id ?? testCaseId,
      block: "start",
    };
  };

  const refreshProgressSummary = async () => {
    if (!selectedTestRunId) {
      return;
    }

    const [runsResult, scenariosResult] = await Promise.all([
      apiRequest("/test-runs.php"),
      apiRequest(
        `/test-scenarios.php?test_run_id=${encodeURIComponent(
          selectedTestRunId,
        )}`,
      ),
    ]);

    setTestRuns(runsResult.test_runs ?? []);
    setScenarios(scenariosResult.scenarios ?? []);
  };

  const clampProgressPercent = (completedCount, caseCount) => {
    if (caseCount < 1) {
      return 0;
    }

    return Math.min(
      100,
      Math.max(0, Math.round((completedCount / caseCount) * 100)),
    );
  };

  const saveTestResult = async (testCaseId, resultStatus) => {
    setTestingMessage("");

    try {
      await apiRequest("/save-test-result.php", {
        method: "POST",
        body: JSON.stringify({
          test_case_id: testCaseId,
          result_status: resultStatus,
        }),
      });

      scheduleNextCaseScroll(testCaseId);
      setTestCases((current) =>
        current.map((testCase) =>
          testCase.id === testCaseId
            ? {
                ...testCase,
                result_status: resultStatus,
              }
            : testCase,
        ),
      );
      await refreshProgressSummary();
    } catch (error) {
      setTestingMessage(error.message);
    }
  };

  const releaseEvidenceFiles = (files) => {
    files.forEach((file) => {
      if (!file.isExisting) {
        URL.revokeObjectURL(file.previewUrl);
      }
    });
  };

  const openEvidenceDialog = async (testCase, resultStatus, mode = "test") => {
    setTestingMessage("");
    setDefectMessage("");
    setEvidenceDialog((current) => {
      releaseEvidenceFiles(current.files);

      return {
        isOpen: true,
        testCase,
        resultStatus,
        description: testCase.actual_result ?? "",
        estimateNumber: "",
        targetLoginId: "",
        files: [],
        message: "",
        isDragging: false,
        isLoading: true,
        mode,
      };
    });

    try {
      const result = await apiRequest(
        `/test-result-evidences.php?test_case_id=${encodeURIComponent(
          testCase.id,
        )}`,
      );
      const evidence = result.evidence ?? {};
      const existingFiles = (result.images ?? []).map((image) => ({
        id: `existing-${image.id}`,
        evidenceId: image.id,
        isExisting: true,
        name: image.name || "attached-image",
        size: image.size ?? 0,
        sourceType: image.source_type ?? "file",
        previewUrl: apiUrl(`/${image.file_path}`),
      }));

      setEvidenceDialog((current) => {
        if (!current.isOpen || current.testCase?.id !== testCase.id) {
          return current;
        }

        return {
          ...current,
          description: evidence.memo ?? testCase.actual_result ?? "",
          estimateNumber: evidence.estimate_number ?? "",
          targetLoginId: evidence.target_login_id ?? "",
          files: existingFiles,
          message: "",
          isLoading: false,
        };
      });
    } catch (error) {
      setEvidenceDialog((current) => ({
        ...current,
        message: error.message,
        isLoading: false,
      }));
    }
  };

  const closeEvidenceDialog = (force = false) => {
    if (isSavingEvidence && !force) {
      return;
    }

    setEvidenceDialog((current) => {
      releaseEvidenceFiles(current.files);

      return {
        isOpen: false,
        testCase: null,
        resultStatus: "",
        description: "",
        estimateNumber: "",
        targetLoginId: "",
        files: [],
        message: "",
        isDragging: false,
        isLoading: false,
        mode: "test",
      };
    });
  };

  const openReDefectDialog = (defect) => {
    if (!defect?.test_case_id) {
      setDefectMessage(
        "재결함을 등록할 테스트 케이스 정보를 찾을 수 없습니다.",
      );
      return;
    }

    openEvidenceDialog(
      {
        id: defect.test_case_id,
        case_code: defect.case_code,
        actual_result: defect.evidence?.memo ?? defect.description ?? "",
      },
      defect.result_status,
      "redefect",
    );
  };

  const addEvidenceFiles = (files, sourceType = "file") => {
    const imageFiles = Array.from(files).filter((file) =>
      file.type.startsWith("image/"),
    );

    if (imageFiles.length === 0) {
      setEvidenceDialog((current) => ({
        ...current,
        message: "이미지 파일만 첨부할 수 있습니다.",
      }));
      return;
    }

    const nextFiles = imageFiles.map((file) => ({
      id: createClientId(),
      file,
      isExisting: false,
      name: file.name || "clipboard-image.png",
      size: file.size,
      sourceType,
      previewUrl: URL.createObjectURL(file),
    }));

    setEvidenceDialog((current) => ({
      ...current,
      files: [...current.files, ...nextFiles],
      message: "",
    }));
  };

  const removeEvidenceFile = (fileId) => {
    setEvidenceDialog((current) => {
      const fileToRemove = current.files.find((file) => file.id === fileId);

      if (fileToRemove && !fileToRemove.isExisting) {
        URL.revokeObjectURL(fileToRemove.previewUrl);
      }

      return {
        ...current,
        files: current.files.filter((file) => file.id !== fileId),
      };
    });
  };

  const handleEvidencePaste = (event) => {
    const files = Array.from(event.clipboardData?.items ?? [])
      .filter((item) => item.type.startsWith("image/"))
      .map((item) => item.getAsFile())
      .filter(Boolean);

    if (files.length > 0) {
      event.preventDefault();
      addEvidenceFiles(files, "clipboard");
    }
  };

  const openManualDefectDialog = () => {
    setTestingMessage("");
    setManualDefectDialog((current) => {
      releaseEvidenceFiles(current.files);

      return {
        isOpen: true,
        mode: "create",
        defectId: null,
        resultStatus: "failed",
        title: "",
        manualLocation: "",
        description: "",
        files: [],
        message: "",
        isDragging: false,
      };
    });
  };

  const openManualReDefectDialog = (defect) => {
    setDefectMessage("");
    setManualDefectDialog((current) => {
      releaseEvidenceFiles(current.files);

      return {
        isOpen: true,
        mode: "redefect",
        defectId: defect.id,
        resultStatus: defect.result_status || "failed",
        title: defect.title || "",
        manualLocation: defect.manual_location || "",
        description: defect.description || "",
        files: [],
        message: "",
        isDragging: false,
      };
    });
  };

  const closeManualDefectDialog = (force = false) => {
    if (isSavingDefect && !force) {
      return;
    }

    setManualDefectDialog((current) => {
      releaseEvidenceFiles(current.files);

      return {
        isOpen: false,
        mode: "create",
        defectId: null,
        resultStatus: "failed",
        title: "",
        manualLocation: "",
        description: "",
        files: [],
        message: "",
        isDragging: false,
      };
    });
  };

  const addManualDefectFiles = (files, sourceType = "file") => {
    const imageFiles = Array.from(files).filter((file) =>
      file.type.startsWith("image/"),
    );

    if (imageFiles.length === 0) {
      setManualDefectDialog((current) => ({
        ...current,
        message: "?대?吏 ?뚯씪留?泥⑤??????덉뒿?덈떎.",
      }));
      return;
    }

    const nextFiles = imageFiles.map((file) => ({
      id: createClientId(),
      file,
      isExisting: false,
      name: file.name || "clipboard-image.png",
      size: file.size,
      sourceType,
      previewUrl: URL.createObjectURL(file),
    }));

    setManualDefectDialog((current) => ({
      ...current,
      files: [...current.files, ...nextFiles],
      message: "",
    }));
  };

  const removeManualDefectFile = (fileId) => {
    setManualDefectDialog((current) => {
      const fileToRemove = current.files.find((file) => file.id === fileId);

      if (fileToRemove) {
        URL.revokeObjectURL(fileToRemove.previewUrl);
      }

      return {
        ...current,
        files: current.files.filter((file) => file.id !== fileId),
      };
    });
  };

  const handleManualDefectPaste = (event) => {
    const files = Array.from(event.clipboardData?.items ?? [])
      .filter((item) => item.type.startsWith("image/"))
      .map((item) => item.getAsFile())
      .filter(Boolean);

    if (files.length > 0) {
      event.preventDefault();
      addManualDefectFiles(files, "clipboard");
    }
  };

  const submitManualDefect = async (event) => {
    event.preventDefault();

    const title = manualDefectTitleRef.current?.value.trim() ?? "";
    const manualLocation = manualDefectLocationRef.current?.value.trim() ?? "";
    const description = manualDefectDescriptionRef.current?.value.trim() ?? "";

    if (title === "" || description === "") {
      setManualDefectDialog((current) => ({
        ...current,
        message: "결함명과 설명을 입력해주세요.",
      }));
      return;
    }

    setIsSavingDefect(true);
    setManualDefectDialog((current) => ({
      ...current,
      message: "",
    }));

    const formData = new FormData();
    formData.append(
      "action",
      manualDefectDialog.mode === "redefect"
        ? "reopen_manual"
        : "create_manual",
    );
    if (manualDefectDialog.defectId) {
      formData.append("defect_id", String(manualDefectDialog.defectId));
    }
    formData.append("result_status", manualDefectDialog.resultStatus);
    formData.append("title", title);
    formData.append("manual_location", manualLocation);
    formData.append("description", description);
    formData.append(
      "source_type",
      manualDefectDialog.files.some((file) => file.sourceType === "clipboard")
        ? "clipboard"
        : "file",
    );
    manualDefectDialog.files.forEach((file) => {
      formData.append("action_images[]", file.file, file.name);
    });

    try {
      await apiRequest("/defects.php", {
        method: "POST",
        body: formData,
      });
      closeManualDefectDialog(true);
      if (manualDefectDialog.mode === "redefect") {
        setDialog({
          isOpen: true,
          title: "재결함 등록 완료",
          message: "재결함으로 등록되었습니다.",
          confirmText: "확인",
          cancelText: "",
          onConfirm: async () => {
            closeDialog();
            await refreshCurrentDefectTab();
          },
          onCancel: null,
        });
      } else {
        setTestingMessage("");
        setDialog({
          isOpen: true,
          title: "결함 티켓 발행",
          message:
            "결함 티켓이 발행되었습니다. 관리자가 담당자를 지정하면 결함 처리 프로세스가 진행됩니다.",
          confirmText: "확인",
          cancelText: "",
          onConfirm: closeDialog,
          onCancel: null,
        });
      }
    } catch (error) {
      setManualDefectDialog((current) => ({
        ...current,
        message: error.message,
      }));
    } finally {
      setIsSavingDefect(false);
    }
  };

  const addActionFiles = (files, sourceType = "file") => {
    const imageFiles = Array.from(files).filter((file) =>
      file.type.startsWith("image/"),
    );

    if (imageFiles.length === 0) {
      setDefectMessage("이미지 파일만 첨부할 수 있습니다.");
      return;
    }

    const nextFiles = imageFiles.map((file) => ({
      id: createClientId(),
      file,
      isExisting: false,
      name: file.name || "clipboard-image.png",
      size: file.size,
      sourceType,
      previewUrl: URL.createObjectURL(file),
    }));

    setActionFiles((current) => [...current, ...nextFiles]);
    setDefectMessage("");
  };

  const removeActionFile = (fileId) => {
    setActionFiles((current) => {
      const fileToRemove = current.find((file) => file.id === fileId);

      if (fileToRemove) {
        URL.revokeObjectURL(fileToRemove.previewUrl);
      }

      return current.filter((file) => file.id !== fileId);
    });
  };

  const handleActionPaste = (event) => {
    const files = Array.from(event.clipboardData?.items ?? [])
      .filter((item) => item.type.startsWith("image/"))
      .map((item) => item.getAsFile())
      .filter(Boolean);

    if (files.length > 0) {
      event.preventDefault();
      addActionFiles(files, "clipboard");
    }
  };

  const submitEvidenceResult = async (event) => {
    event.preventDefault();

    if (!evidenceDialog.testCase) {
      return;
    }

    const selectedResultStatus = evidenceDialog.resultStatus;
    const isReDefectSubmission = evidenceDialog.mode === "redefect";
    const description =
      evidenceDescriptionRef.current?.value ?? evidenceDialog.description;
    const estimateNumber =
      evidenceEstimateNumberRef.current?.value ?? evidenceDialog.estimateNumber;
    const targetLoginId =
      evidenceTargetLoginIdRef.current?.value ?? evidenceDialog.targetLoginId;

    if (!evidenceStatuses.includes(selectedResultStatus)) {
      setEvidenceDialog((current) => ({
        ...current,
        message: "테스트 결과를 다시 선택해 주세요.",
      }));
      return;
    }

    setIsSavingEvidence(true);
    setEvidenceDialog((current) => ({
      ...current,
      message: "",
    }));

    const formData = new FormData();
    formData.append("test_case_id", String(evidenceDialog.testCase.id));
    formData.append("result_status", selectedResultStatus);
    formData.append("submission_mode", evidenceDialog.mode);
    formData.append("actual_result", description);
    formData.append("evidence_memo", description);
    formData.append("estimate_number", estimateNumber);
    formData.append("target_login_id", targetLoginId);
    formData.append(
      "source_type",
      evidenceDialog.files.some((file) => file.sourceType === "clipboard")
        ? "clipboard"
        : "file",
    );
    formData.append(
      "retained_evidence_ids",
      JSON.stringify(
        evidenceDialog.files
          .filter((file) => file.isExisting)
          .map((file) => file.evidenceId),
      ),
    );

    evidenceDialog.files
      .filter((file) => !file.isExisting)
      .forEach((file) => {
        formData.append("evidence_images[]", file.file, file.name);
      });

    try {
      await apiRequest("/save-test-result.php", {
        method: "POST",
        body: formData,
      });

      if (isReDefectSubmission) {
        closeEvidenceDialog(true);
        setDialog({
          isOpen: true,
          title: "재결함 등록 완료",
          message: "재결함으로 등록되었습니다.",
          confirmText: "확인",
          cancelText: "",
          onConfirm: async () => {
            closeDialog();
            await refreshCurrentDefectTab();
          },
          onCancel: null,
        });
        return;
      }

      scheduleNextCaseScroll(evidenceDialog.testCase.id);
      await refreshProgressSummary();
      setTestCases((current) =>
        current.map((testCase) =>
          testCase.id === evidenceDialog.testCase.id
            ? {
                ...testCase,
                result_status: selectedResultStatus,
                actual_result: description,
              }
            : testCase,
        ),
      );
      closeEvidenceDialog(true);
    } catch (error) {
      setEvidenceDialog((current) => ({
        ...current,
        message: error.message,
      }));
    } finally {
      setIsSavingEvidence(false);
    }
  };

  const loadDefects = async ({
    page = 1,
    append = false,
    status = defectStatusFilter,
    pageSize = 30,
    selectFirst = false,
  } = {}) => {
    setDefectMessage("");
    setIsLoadingDefects(true);

    try {
      const query = new URLSearchParams({
        page: String(page),
        page_size: String(pageSize),
        status,
      });
      const result = await apiRequest(`/defects.php?${query.toString()}`);
      const nextDefects = result.defects ?? [];
      const mergedDefects = append ? [...defects, ...nextDefects] : nextDefects;

      setDefects(mergedDefects);
      setDefectCounts(result.counts ?? {});
      setDefectPagination({
        page: Number(result.pagination?.page ?? page),
        pageSize: Number(result.pagination?.page_size ?? pageSize),
        total: Number(result.pagination?.total ?? nextDefects.length),
        hasMore: Boolean(result.pagination?.has_more),
        nextPage: result.pagination?.next_page ?? null,
      });
      setSelectedDefectId((current) => {
        if (selectFirst) {
          return String(mergedDefects[0]?.id ?? "");
        }

        return mergedDefects.some((defect) => String(defect.id) === current)
          ? current
          : String(mergedDefects[0]?.id ?? "");
      });
    } catch (error) {
      setDefectMessage(error.message);
    } finally {
      setIsLoadingDefects(false);
    }
  };

  const loadDashboardDefects = async () => {
    setDefectMessage("");
    setIsLoadingDefects(true);

    try {
      const collectedDefects = [];
      let page = 1;
      let hasMore = true;

      while (hasMore) {
        const query = new URLSearchParams({
          page: String(page),
          page_size: "100",
          status: "all",
        });
        const result = await apiRequest(`/defects.php?${query.toString()}`);

        collectedDefects.push(...(result.defects ?? []));
        hasMore = Boolean(result.pagination?.has_more);
        page = Number(result.pagination?.next_page ?? page + 1);
      }

      setDashboardDefects(collectedDefects);
    } catch (error) {
      setDefectMessage(error.message);
    } finally {
      setIsLoadingDefects(false);
    }
  };

  const loadAssignees = async () => {
    try {
      const result = await apiRequest("/defect-assignees.php");
      setAssignees(result.assignees ?? []);
    } catch (error) {
      setDefectMessage(error.message);
    }
  };

  const loadDashboardSummary = async () => {
    setDashboardMessage("");
    setIsLoadingDashboard(true);

    try {
      const result = await apiRequest("/dashboard-summary.php");
      setDashboardSummary(result.summary ?? null);
    } catch (error) {
      setDashboardMessage(error.message);
    } finally {
      setIsLoadingDashboard(false);
    }
  };

  const updateDefect = async (payload) => {
    setDefectMessage("");
    setIsSavingDefect(true);

    try {
      await apiRequest("/defects.php", {
        method: "PATCH",
        body: JSON.stringify(payload),
      });
      await loadDefects();
    } catch (error) {
      setDefectMessage(error.message);
    } finally {
      setIsSavingDefect(false);
    }
  };

  const resetDefectScroll = () => {
    defectListRef.current?.scrollTo({ top: 0, left: 0 });
    defectDetailRef.current?.scrollTo({ top: 0, left: 0 });
    window.requestAnimationFrame(() => {
      defectListRef.current?.scrollTo({ top: 0, left: 0 });
      defectDetailRef.current?.scrollTo({ top: 0, left: 0 });
      document.querySelector(".dashboard-main")?.scrollTo?.({
        top: 0,
        left: 0,
      });
      window.scrollTo({ top: 0, left: 0 });
    });
  };

  const refreshCurrentDefectTab = async () => {
    pendingDefectScrollResetRef.current = true;
    await loadDefects({
      page: 1,
      append: false,
      status: defectStatusFilter,
      selectFirst: true,
    });
  };

  const assignDefect = async () => {
    if (!selectedDefectId) {
      return;
    }

    setDefectMessage("");
    setIsSavingDefect(true);

    try {
      await apiRequest("/defects.php", {
        method: "PATCH",
        body: JSON.stringify({
          defect_id: Number(selectedDefectId),
          action: "assign",
          assignee_user_id: Number(selectedAssigneeId),
        }),
      });
      setDialog({
        isOpen: true,
        title: "담당자 지정 완료",
        message: "결함 처리 담당자가 지정되었습니다.",
        confirmText: "확인",
        cancelText: "",
        onConfirm: async () => {
          closeDialog();
          await refreshCurrentDefectTab();
        },
        onCancel: null,
      });
    } catch (error) {
      setDefectMessage(error.message);
    } finally {
      setIsSavingDefect(false);
    }
  };

  const submitCompleteDefectAction = async () => {
    if (!selectedDefectId) {
      return;
    }

    closeDialog();
    setDefectMessage("");
    setIsSavingDefect(true);

    const formData = new FormData();
    formData.append("defect_id", String(selectedDefectId));
    formData.append("action", "complete_action");
    formData.append("action_memo", defectActionMemo);
    formData.append(
      "source_type",
      actionFiles.some((file) => file.sourceType === "clipboard")
        ? "clipboard"
        : "file",
    );
    actionFiles.forEach((file) => {
      formData.append("action_images[]", file.file, file.name);
    });

    try {
      await apiRequest("/defects.php", {
        method: "POST",
        body: formData,
      });
      setActionFiles((current) => {
        releaseEvidenceFiles(current);
        return [];
      });
      setDialog({
        isOpen: true,
        title: "조치 완료",
        message:
          "조치 완료로 등록되었습니다. 테스터 확인대기 상태로 변경되어 테스터가 확인할 수 있습니다.",
        confirmText: "확인",
        cancelText: "",
        onConfirm: async () => {
          closeDialog();
          await refreshCurrentDefectTab();
        },
        onCancel: null,
      });
    } catch (error) {
      setDefectMessage(error.message);
    } finally {
      setIsSavingDefect(false);
    }
  };

  const completeDefectAction = () => {
    if (!selectedDefectId || defectActionMemo.trim() === "") {
      return;
    }

    setDialog({
      isOpen: true,
      title: "조치 완료 등록",
      message:
        "입력한 조치 내용과 첨부 이미지를 등록하고 테스터 확인대기 상태로 변경할까요?",
      confirmText: "등록",
      cancelText: "취소",
      onConfirm: submitCompleteDefectAction,
      onCancel: closeDialog,
    });
  };

  const verifyDefect = async () => {
    if (!selectedDefectId) {
      return;
    }

    setDefectMessage("");
    setIsSavingDefect(true);

    try {
      await apiRequest("/defects.php", {
        method: "PATCH",
        body: JSON.stringify({
          defect_id: Number(selectedDefectId),
          action: "verify",
        }),
      });
      setDialog({
        isOpen: true,
        title: "확인완료",
        message: "결함 확인이 완료되었습니다.",
        confirmText: "확인",
        cancelText: "",
        onConfirm: async () => {
          closeDialog();
          await refreshCurrentDefectTab();
        },
        onCancel: null,
      });
    } catch (error) {
      setDefectMessage(error.message);
    } finally {
      setIsSavingDefect(false);
    }
  };

  const openDefectDetail = (defectId) => {
    setSelectedDefectId(String(defectId));
    setActiveMenu("defects");
  };

  const openDefectStatus = (status) => {
    setSelectedDefectId("");
    setDefectStatusFilter(status);
    setActiveMenu("defects");
  };

  const countByKey = (counts, key) => Number(counts?.[key] ?? 0);

  const renderDashboardContent = () => {
    if (activeMenu === "help") {
      return <HelpContent />;
    }

    if (
      activeMenu === "dashboard" ||
      (currentUser.role === "admin" && activeMenu === "status")
    ) {
      if (currentUser.role !== "admin") {
        const isProjectTeam = currentUser.role === "project";
        const myRegisteredDefects = dashboardDefects.filter((defect) =>
          isProjectTeam
            ? Number(defect.assignee_user_id) === Number(currentUser.id)
            : Number(defect.reporter_user_id) === Number(currentUser.id),
        );
        const myVerificationTodos = myRegisteredDefects.filter((defect) =>
          isProjectTeam
            ? defect.status === "assigned"
            : testerConfirmationPendingStatuses.includes(defect.status),
        );
        const statusCounts = Object.fromEntries(
          defectDisplayStatuses.map((status) => [
            status,
            myRegisteredDefects.filter(
              (defect) => normalizeDefectStatus(defect.status) === status,
            ).length,
          ]),
        );

        return (
          <section className="tester-dashboard">
            <div className="dashboard-panel">
              <div className="dashboard-panel-header">
                <div>
                  <p className="user-role">{currentRoleLabel}</p>
                  <h1>대시보드</h1>
                </div>
                <div className="dashboard-header-actions">
                  <span className="dday-badge">
                    <small>통합테스트 종료 2026.08.28</small>
                    <strong>{getIntegrationTestDday()}</strong>
                  </span>
                  {isLoadingDefects && <span>불러오는 중</span>}
                </div>
              </div>

              <div className="dashboard-stat-grid">
                {isProjectTeam ? (
                  <>
                    <button
                      type="button"
                      className="dashboard-stat"
                      onClick={() => openDefectStatus("all")}
                    >
                      <span>배정결함</span>
                      <strong>{myRegisteredDefects.length}</strong>
                    </button>
                    <button
                      type="button"
                      className="dashboard-stat"
                      onClick={() => openDefectStatus("assigned")}
                    >
                      <span>조치필요</span>
                      <strong>{statusCounts.assigned}</strong>
                    </button>
                    <button
                      type="button"
                      className="dashboard-stat"
                      onClick={() =>
                        openDefectStatus("tester_confirmation_pending")
                      }
                    >
                      <span>조치완료</span>
                      <strong>
                        {statusCounts.tester_confirmation_pending}
                      </strong>
                    </button>
                    <button
                      type="button"
                      className="dashboard-stat"
                      onClick={() => openDefectStatus("verification_completed")}
                    >
                      <span>확인완료</span>
                      <strong>{statusCounts.verification_completed}</strong>
                    </button>
                  </>
                ) : (
                  <>
                    <button
                      type="button"
                      className="dashboard-stat"
                      onClick={() => openDefectStatus("all")}
                    >
                      <span>등록 결함</span>
                      <strong>{myRegisteredDefects.length}</strong>
                    </button>
                    <button
                      type="button"
                      className="dashboard-stat"
                      onClick={() =>
                        openDefectStatus("tester_confirmation_pending")
                      }
                    >
                      <span>확인 필요</span>
                      <strong>{myVerificationTodos.length}</strong>
                    </button>
                    <button
                      type="button"
                      className="dashboard-stat"
                      onClick={() => openDefectStatus("all")}
                    >
                      <span>진행 중</span>
                      <strong>
                        {statusCounts.received + statusCounts.assigned}
                      </strong>
                    </button>
                    <button
                      type="button"
                      className="dashboard-stat"
                      onClick={() => openDefectStatus("verification_completed")}
                    >
                      <span>확인완료</span>
                      <strong>{statusCounts.verification_completed}</strong>
                    </button>
                  </>
                )}
              </div>

              <div className="dashboard-status-row">
                {defectDisplayStatuses.map((status) => (
                  <div key={status}>
                    <span className={`defect-status status-${status}`}>
                      {getDefectStatusLabel(status)}
                    </span>
                    <strong>{statusCounts[status]}</strong>
                  </div>
                ))}
              </div>
            </div>

            <div className="dashboard-panel">
              <div className="dashboard-panel-header">
                <div>
                  <p className="user-role">TODO</p>
                  <h2>
                    {isProjectTeam
                      ? "조치가 필요한 결함"
                      : "확인이 필요한 결함"}
                  </h2>
                </div>
              </div>

              <div className="dashboard-todo-list">
                {myVerificationTodos.map((defect) => (
                  <button
                    key={defect.id}
                    type="button"
                    onClick={() => openDefectDetail(defect.id)}
                  >
                    <span className="todo-check" aria-hidden="true" />
                    <div>
                      <strong>{defect.title}</strong>
                      <em>
                        {(defect.defect_source ?? "test_case") === "manual"
                          ? defect.manual_location || "테스트 케이스 외"
                          : `${defect.test_run_name} · ${defect.case_code}`}{" "}
                        · {defect.assignee_name || "담당자 미지정"}
                      </em>
                    </div>
                    <span className="todo-action">
                      {isProjectTeam ? "조치" : "확인"}
                    </span>
                  </button>
                ))}
                {myVerificationTodos.length === 0 && (
                  <p className="empty-message">
                    {isProjectTeam
                      ? "조치가 필요한 결함이 없습니다."
                      : "확인이 필요한 결함이 없습니다."}
                  </p>
                )}
              </div>

              {defectMessage && (
                <p className="form-message is-error">{defectMessage}</p>
              )}
            </div>
          </section>
        );
      }

      const overview = dashboardSummary?.overview ?? {};
      const defectCounts = dashboardSummary?.defect_counts ?? {};
      const scenarioQuality = dashboardSummary?.scenario_quality ?? [];
      const scenarioQualityGroups = Object.entries(
        scenarioQuality.reduce((groups, scenario) => {
          const runName = scenario.test_run_name || "진행명 미지정";
          return {
            ...groups,
            [runName]: [...(groups[runName] ?? []), scenario],
          };
        }, {}),
      );
      const runProgress = dashboardSummary?.run_progress ?? {
        runs: [],
        total: {},
      };
      const defectActionProgress = dashboardSummary?.defect_action_progress ?? {
        runs: [],
        total: {},
      };

      return (
        <section className="admin-dashboard">
          <div className="dashboard-panel">
            <div className="dashboard-panel-header">
              <div>
                <p className="user-role">{currentRoleLabel}</p>
                <h1>{activeMenu === "status" ? "테스트 현황" : "대시보드"}</h1>
              </div>
              <div className="dashboard-header-actions">
                <span className="dday-badge">
                  <small>통합테스트 종료 2026.08.28</small>
                  <strong>{getIntegrationTestDday()}</strong>
                </span>
                {isLoadingDashboard && <span>불러오는 중</span>}
              </div>
            </div>

            <div className="dashboard-stat-grid">
              <div className="dashboard-stat">
                <span>테스트 케이스</span>
                <strong>
                  {Number(overview.case_count ?? 0).toLocaleString()}
                </strong>
              </div>
              <div className="dashboard-stat">
                <span>수행 케이스</span>
                <strong>{Number(overview.case_progress_percent ?? 0)}%</strong>
              </div>
              <div className="dashboard-stat">
                <span>성공률</span>
                <strong>{Number(overview.success_percent ?? 0)}%</strong>
              </div>
              <div className="dashboard-stat">
                <span>결함 처리율</span>
                <strong>{Number(overview.defect_process_percent ?? 0)}%</strong>
              </div>
            </div>

            <div className="dashboard-status-row">
              {defectDisplayStatuses.map((status) => (
                <div key={status}>
                  <span className={`defect-status status-${status}`}>
                    {getDefectStatusLabel(status)}
                  </span>
                  <strong>{countByKey(defectCounts, status)}</strong>
                </div>
              ))}
            </div>

            {dashboardMessage && (
              <p className="form-message is-error">{dashboardMessage}</p>
            )}
          </div>

          <div className="dashboard-panel">
            <div className="dashboard-panel-header">
              <div>
                <h2>통합테스트 진행현황</h2>
              </div>
            </div>
            <div className="run-progress-board">
              <div className="run-progress-section">
                <div className="dashboard-progress-table-wrap">
                  <table className="dashboard-progress-table is-overall">
                    <caption>종합 실적 - 전체</caption>
                    <thead>
                      <tr>
                        <th rowSpan={2}>구분</th>
                        <th className="scenario-header" colSpan={4}>
                          시나리오
                        </th>
                        <th className="case-header" colSpan={3}>
                          케이스
                        </th>
                      </tr>
                      <tr>
                        <th className="scenario-header">대상건수</th>
                        <th className="scenario-header">수행완료</th>
                        <th className="scenario-header">미완료</th>
                        <th className="scenario-header">수행률</th>
                        <th className="case-header">대상건수</th>
                        <th className="case-header">수행완료</th>
                        <th className="case-header">수행률</th>
                      </tr>
                    </thead>
                    <tbody>
                      {runProgress.runs.map((run) => (
                        <tr key={`overall-${run.id}`}>
                          <th>{run.name}</th>
                          <td>
                            {Number(run.total.scenario_count).toLocaleString()}
                          </td>
                          <td>
                            {Number(
                              run.total.completed_scenario_count,
                            ).toLocaleString()}
                          </td>
                          <td>
                            {Number(
                              run.total.incomplete_scenario_count,
                            ).toLocaleString()}
                          </td>
                          <td>{Number(run.total.scenario_percent)}%</td>
                          <td>
                            {Number(run.total.case_count).toLocaleString()}
                          </td>
                          <td>
                            {Number(
                              run.total.all_completed_case_count,
                            ).toLocaleString()}
                          </td>
                          <td>{Number(run.total.all_case_percent)}%</td>
                        </tr>
                      ))}
                    </tbody>
                    <tfoot>
                      <tr>
                        <th>계</th>
                        <td>
                          {Number(
                            runProgress.total?.scenario_count ?? 0,
                          ).toLocaleString()}
                        </td>
                        <td>
                          {Number(
                            runProgress.total?.completed_scenario_count ?? 0,
                          ).toLocaleString()}
                        </td>
                        <td>
                          {Number(
                            runProgress.total?.incomplete_scenario_count ?? 0,
                          ).toLocaleString()}
                        </td>
                        <td>
                          {Number(runProgress.total?.scenario_percent ?? 0)}%
                        </td>
                        <td>
                          {Number(
                            runProgress.total?.case_count ?? 0,
                          ).toLocaleString()}
                        </td>
                        <td>
                          {Number(
                            runProgress.total?.all_completed_case_count ?? 0,
                          ).toLocaleString()}
                        </td>
                        <td>
                          {Number(runProgress.total?.all_case_percent ?? 0)}%
                        </td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>

              <div className="run-progress-section">
                <div className="dashboard-progress-table-wrap">
                  <table className="dashboard-progress-table is-team-compare">
                    <caption>지점별 케이스 수행 실적</caption>
                    <thead>
                      <tr>
                        <th rowSpan={2}>구분</th>
                        <th rowSpan={2}>대상건수</th>
                        <th className="new-car-header" colSpan={2}>
                          신차사업팀
                        </th>
                        <th className="branch-header" colSpan={2}>
                          지점
                        </th>
                      </tr>
                      <tr>
                        <th className="new-car-header">수행완료</th>
                        <th className="new-car-header">수행률</th>
                        <th className="branch-header">수행완료</th>
                        <th className="branch-header">수행률</th>
                      </tr>
                    </thead>
                    <tbody>
                      {runProgress.runs.map((run) => (
                        <tr key={`team-${run.id}`}>
                          <th>{run.name}</th>
                          <td>
                            {Number(run.total.case_count).toLocaleString()}
                          </td>
                          <td>
                            {Number(
                              run.total.new_car_completed_case_count,
                            ).toLocaleString()}
                          </td>
                          <td>{Number(run.total.new_car_case_percent)}%</td>
                          <td>
                            {Number(
                              run.total.branch_completed_case_count,
                            ).toLocaleString()}
                          </td>
                          <td>{Number(run.total.branch_case_percent)}%</td>
                        </tr>
                      ))}
                    </tbody>
                    <tfoot>
                      <tr>
                        <th>계</th>
                        <td>
                          {Number(
                            runProgress.total?.case_count ?? 0,
                          ).toLocaleString()}
                        </td>
                        <td>
                          {Number(
                            runProgress.total?.new_car_completed_case_count ??
                              0,
                          ).toLocaleString()}
                        </td>
                        <td>
                          {Number(runProgress.total?.new_car_case_percent ?? 0)}
                          %
                        </td>
                        <td>
                          {Number(
                            runProgress.total?.branch_completed_case_count ?? 0,
                          ).toLocaleString()}
                        </td>
                        <td>
                          {Number(runProgress.total?.branch_case_percent ?? 0)}%
                        </td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>
              {runProgress.runs.length === 0 && (
                <p className="empty-message">표시할 진행 현황이 없습니다.</p>
              )}
            </div>
          </div>

          <div className="dashboard-panel">
            <div className="dashboard-panel-header">
              <div>
                <h2>결함조치 현황</h2>
              </div>
            </div>
            <div className="dashboard-progress-table-wrap">
              <table className="dashboard-progress-table is-defect-action">
                <thead>
                  <tr>
                    <th rowSpan={2}>구분</th>
                    <th className="defect-total-header" colSpan={4}>
                      총 건수
                    </th>
                    <th className="defect-action-header" colSpan={4}>
                      조치현황
                    </th>
                    <th className="defect-verify-header" colSpan={3}>
                      확인현황
                    </th>
                  </tr>
                  <tr>
                    <th className="defect-total-header">결함</th>
                    <th className="defect-total-header">개선사항</th>
                    <th className="defect-total-header">결함아님</th>
                    <th className="defect-total-header">합계</th>
                    <th className="defect-action-header">미조치</th>
                    <th className="defect-action-header">조치중</th>
                    <th className="defect-action-header">조치완료</th>
                    <th className="defect-action-header">조치율</th>
                    <th className="defect-verify-header">확인대상</th>
                    <th className="defect-verify-header">등록자확인</th>
                    <th className="defect-verify-header">확인율</th>
                  </tr>
                </thead>
                <tbody>
                  {defectActionProgress.runs.map((run) => (
                    <tr key={`defect-action-${run.id}`}>
                      <th>{run.name}</th>
                      <td>{Number(run.failed_count).toLocaleString()}</td>
                      <td>{Number(run.improvement_count).toLocaleString()}</td>
                      <td>{Number(run.non_defect_count).toLocaleString()}</td>
                      <td>{Number(run.total_count).toLocaleString()}</td>
                      <td>{Number(run.not_started_count).toLocaleString()}</td>
                      <td>{Number(run.in_progress_count).toLocaleString()}</td>
                      <td>
                        {Number(run.action_completed_count).toLocaleString()}
                      </td>
                      <td>{Number(run.action_percent)}%</td>
                      <td>
                        {Number(
                          run.verification_target_count ??
                            run.action_completed_count ??
                            0,
                        ).toLocaleString()}
                      </td>
                      <td>{Number(run.verified_count).toLocaleString()}</td>
                      <td>{Number(run.verification_percent)}%</td>
                    </tr>
                  ))}
                </tbody>
                <tfoot>
                  <tr>
                    <th>계</th>
                    <td>
                      {Number(
                        defectActionProgress.total?.failed_count ?? 0,
                      ).toLocaleString()}
                    </td>
                    <td>
                      {Number(
                        defectActionProgress.total?.improvement_count ?? 0,
                      ).toLocaleString()}
                    </td>
                    <td>
                      {Number(
                        defectActionProgress.total?.non_defect_count ?? 0,
                      ).toLocaleString()}
                    </td>
                    <td>
                      {Number(
                        defectActionProgress.total?.total_count ?? 0,
                      ).toLocaleString()}
                    </td>
                    <td>
                      {Number(
                        defectActionProgress.total?.not_started_count ?? 0,
                      ).toLocaleString()}
                    </td>
                    <td>
                      {Number(
                        defectActionProgress.total?.in_progress_count ?? 0,
                      ).toLocaleString()}
                    </td>
                    <td>
                      {Number(
                        defectActionProgress.total?.action_completed_count ?? 0,
                      ).toLocaleString()}
                    </td>
                    <td>
                      {Number(defectActionProgress.total?.action_percent ?? 0)}%
                    </td>
                    <td>
                      {Number(
                        defectActionProgress.total?.verification_target_count ??
                          defectActionProgress.total?.action_completed_count ??
                          0,
                      ).toLocaleString()}
                    </td>
                    <td>
                      {Number(
                        defectActionProgress.total?.verified_count ?? 0,
                      ).toLocaleString()}
                    </td>
                    <td>
                      {Number(
                        defectActionProgress.total?.verification_percent ?? 0,
                      )}
                      %
                    </td>
                  </tr>
                </tfoot>
              </table>
              {defectActionProgress.runs.length === 0 && (
                <p className="empty-message">
                  표시할 결함조치 현황이 없습니다.
                </p>
              )}
            </div>
          </div>

          <div className="dashboard-panel">
            <div className="dashboard-panel-header">
              <div>
                <p className="user-role">SCENARIO</p>
                <h2>시나리오 품질 현황</h2>
              </div>
            </div>
            <div className="scenario-quality-groups">
              {scenarioQualityGroups.map(([runName, scenarios]) => (
                <section key={runName} className="scenario-quality-group">
                  <h3>{runName}</h3>
                  <div className="dashboard-table is-scenario">
                    {scenarios.map((scenario) => (
                      <div key={scenario.id}>
                        <strong>{scenario.name}</strong>
                        <span>
                          {scenario.result_count.toLocaleString()}건 수행
                        </span>
                        <span>{scenario.success_percent}% 성공</span>
                        <span>
                          {scenario.defect_count.toLocaleString()}건 결함
                        </span>
                      </div>
                    ))}
                  </div>
                </section>
              ))}
              {scenarioQualityGroups.length === 0 && (
                <p className="empty-message">
                  표시할 시나리오 결과가 없습니다.
                </p>
              )}
            </div>
          </div>
        </section>
      );
    }

    if (activeMenu === "testing") {
      return (
        <section className="test-workspace">
          <div className="test-column is-runs">
            <div className="column-header">
              <h2>통합테스트 진행 목록</h2>
            </div>
            <div className="select-list">
              {testRuns.map((testRun) =>
                (() => {
                  const caseCount = Number(testRun.case_count ?? 0);
                  const completedCount = Number(testRun.completed_count ?? 0);
                  const progressPercent = clampProgressPercent(
                    completedCount,
                    caseCount,
                  );

                  return (
                    <button
                      key={testRun.id}
                      type="button"
                      className={
                        String(testRun.id) === selectedTestRunId
                          ? "is-selected"
                          : ""
                      }
                      onClick={() => setSelectedTestRunId(String(testRun.id))}
                    >
                      <span>{testRun.name}</span>
                      {!isReadOnlyTesting && (
                        <div className="run-progress">
                          <div className="run-progress-meter">
                            <i style={{ width: `${progressPercent}%` }} />
                          </div>
                          <strong>{progressPercent}%</strong>
                        </div>
                      )}
                    </button>
                  );
                })(),
              )}
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
              {scenarios.map((scenario) =>
                (() => {
                  const caseCount = Number(scenario.case_count ?? 0);
                  const completedCount = Number(scenario.completed_count ?? 0);
                  const progressPercent = clampProgressPercent(
                    completedCount,
                    caseCount,
                  );

                  return (
                    <button
                      key={scenario.id}
                      type="button"
                      className={
                        String(scenario.id) === selectedScenarioId
                          ? "is-selected"
                          : ""
                      }
                      onClick={() => setSelectedScenarioId(String(scenario.id))}
                    >
                      <span>{scenario.name}</span>
                      {!isReadOnlyTesting && (
                        <div className="scenario-progress">
                          <em>
                            {completedCount} / {caseCount}건
                          </em>
                          <div className="scenario-progress-meter">
                            <i style={{ width: `${progressPercent}%` }} />
                          </div>
                          <strong>{progressPercent}%</strong>
                        </div>
                      )}
                    </button>
                  );
                })(),
              )}
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
                const isNotTested = testCase.result_status === "not_tested";

                return (
                  <article
                    key={testCase.id}
                    ref={(element) => {
                      if (element) {
                        caseRefs.current.set(testCase.id, element);
                      } else {
                        caseRefs.current.delete(testCase.id);
                      }
                    }}
                    tabIndex={-1}
                    className={`case-item result-${testCase.result_status}`}
                  >
                    <div className="case-title">
                      <strong>{testCase.case_code}</strong>
                      {!isReadOnlyTesting && (
                        <span>{isNotTested ? "미수행" : "수행완료"}</span>
                      )}
                    </div>
                    <h3>{testCase.name}</h3>
                    {!isReadOnlyTesting && (
                      <div
                        className="result-buttons"
                        aria-label="테스트 결과 선택"
                      >
                        {resultOptions.map((option) => (
                          <button
                            key={option.value}
                            type="button"
                            className={
                              testCase.result_status === option.value
                                ? "is-selected"
                                : ""
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
                    )}
                    <dl>
                      <div>
                        <dt>메뉴</dt>
                        <dd>{testCase.scenario_menu || "-"}</dd>
                      </div>
                      <div>
                        <dt>위치</dt>
                        <dd>{testCase.location || "-"}</dd>
                      </div>
                      <div>
                        <dt>사전조건</dt>
                        <dd>{testCase.precondition || "-"}</dd>
                      </div>
                      <div>
                        <dt>테스트 스텝</dt>
                        <dd>{testCase.test_steps || "-"}</dd>
                      </div>
                      <div>
                        <dt>예상결과</dt>
                        <dd>{testCase.expected_result || "-"}</dd>
                      </div>
                    </dl>
                  </article>
                );
              })}
              {selectedScenarioId && testCases.length === 0 && (
                <p className="empty-message">등록된 케이스가 없습니다.</p>
              )}
            </div>
            {testingMessage && (
              <p className="form-message is-error">{testingMessage}</p>
            )}
          </div>
          {!isReadOnlyTesting && (
            <button
              type="button"
              className="floating-defect-button"
              onClick={openManualDefectDialog}
            >
              결함 직접 등록
            </button>
          )}
        </section>
      );
    }

    if (activeMenu === "defects") {
      const getNormalizedStatus = (defect) =>
        normalizeDefectStatus(defect.status);
      const isRoleOpenDefect = (defect) => {
        const status = getNormalizedStatus(defect);

        if (currentUser.role === "tester") {
          return (
            Number(defect.reporter_user_id) === Number(currentUser.id) &&
            status === "tester_confirmation_pending"
          );
        }

        if (currentUser.role === "project") {
          return (
            Number(defect.assignee_user_id) === Number(currentUser.id) &&
            status === "assigned"
          );
        }

        return status === "received";
      };
      const defectFilterOptions = [
        { value: "all", label: "전체", count: Number(defectCounts.all ?? 0) },
        ...defectDisplayStatuses.map((status) => ({
          value: status,
          label: getDefectStatusLabel(status),
          count: Number(defectCounts[status] ?? 0),
        })),
      ];
      const filteredDefects = defects.filter((defect) => {
        const status = getNormalizedStatus(defect);

        if (defectStatusFilter === "all") {
          return true;
        }

        if (defectStatusFilter === "open") {
          return isRoleOpenDefect(defect);
        }

        return status === defectStatusFilter;
      });
      const selectedDefect = defects.find(
        (defect) => String(defect.id) === selectedDefectId,
      );
      const isManualSelectedDefect =
        (selectedDefect?.defect_source ?? "test_case") === "manual";
      const selectedEvidenceImages = isManualSelectedDefect
        ? (selectedDefect?.action_images ?? []).filter(
            (image) => image.action_type === "received",
          )
        : (selectedDefect?.evidence?.images ?? []);
      const selectedActionImages = (selectedDefect?.action_images ?? []).filter(
        (image) => image.action_type !== "received",
      );
      const canAssign = currentUser.role === "admin" && selectedDefect;
      const canCompleteAction =
        selectedDefect &&
        ["assigned", ...testerConfirmationPendingStatuses].includes(
          selectedDefect.status,
        ) &&
        Number(selectedDefect.assignee_user_id) === Number(currentUser.id);
      const canVerify =
        selectedDefect &&
        testerConfirmationPendingStatuses.includes(selectedDefect.status) &&
        Number(selectedDefect.reporter_user_id) === Number(currentUser.id);

      return (
        <section className="defect-workspace">
          <div className="defect-list-panel">
            <div className="column-header">
              <h2>결함 목록</h2>
              {isLoadingDefects && <span>불러오는 중</span>}
            </div>
            <div className="defect-filter-bar" aria-label="결함 상태 필터">
              {defectFilterOptions.map((option) => (
                <button
                  key={option.value}
                  type="button"
                  className={
                    defectStatusFilter === option.value ? "is-active" : ""
                  }
                  onClick={() => setDefectStatusFilter(option.value)}
                >
                  <span>{option.label}</span>
                  <strong>{option.count}</strong>
                </button>
              ))}
            </div>
            <div className="defect-list" ref={defectListRef}>
              {filteredDefects.map((defect) => (
                <button
                  key={defect.id}
                  type="button"
                  className={
                    String(defect.id) === selectedDefectId ? "is-selected" : ""
                  }
                  onClick={() => setSelectedDefectId(String(defect.id))}
                >
                  <span
                    className={`defect-status status-${normalizeDefectStatus(
                      defect.status,
                    )}`}
                  >
                    {getDefectStatusLabel(defect.status)}
                  </span>
                  <strong>{defect.title}</strong>
                  <em>
                    {(defect.defect_source ?? "test_case") === "manual"
                      ? defect.manual_location || "테스트 케이스 외"
                      : `${defect.test_run_name} · ${defect.case_code}`}
                  </em>
                </button>
              ))}
              {defects.length === 0 && (
                <p className="empty-message">등록된 결함이 없습니다.</p>
              )}
              {defects.length > 0 && filteredDefects.length === 0 && (
                <p className="empty-message">선택한 상태의 결함이 없습니다.</p>
              )}
              {filteredDefects.length > 0 && (
                <div className="defect-list-footer">
                  <span>
                    {filteredDefects.length.toLocaleString()} /{" "}
                    {Number(defectPagination.total).toLocaleString()}건 표시
                  </span>
                  {defectPagination.hasMore && (
                    <button
                      type="button"
                      className="secondary-button"
                      disabled={isLoadingDefects}
                      onClick={() =>
                        loadDefects({
                          page: Number(defectPagination.nextPage ?? 1),
                          append: true,
                          status: defectStatusFilter,
                          pageSize: defectPagination.pageSize,
                        })
                      }
                    >
                      더 보기
                    </button>
                  )}
                </div>
              )}
            </div>
          </div>

          <div className="defect-detail-panel" ref={defectDetailRef}>
            {selectedDefect ? (
              <>
                <div className="defect-detail-header">
                  <span
                    className={`defect-status status-${normalizeDefectStatus(
                      selectedDefect.status,
                    )}`}
                  >
                    {getDefectStatusLabel(selectedDefect.status)}
                  </span>
                  <h2>{selectedDefect.title}</h2>
                  <p>
                    <strong>결함등록자</strong>
                    <span>
                      {selectedDefect.reporter_organization} ·{" "}
                      {selectedDefect.reporter_name}
                    </span>
                  </p>
                </div>

                <dl className="defect-summary-grid">
                  <div>
                    <dt>결과</dt>
                    <dd>
                      {
                        resultOptions.find(
                          (option) =>
                            option.value === selectedDefect.result_status,
                        )?.label
                      }
                    </dd>
                  </div>
                  <div>
                    <dt>담당자</dt>
                    <dd>{selectedDefect.assignee_name || "-"}</dd>
                  </div>
                  <div>
                    <dt>진행명</dt>
                    <dd>
                      {isManualSelectedDefect
                        ? "테스트 케이스 외"
                        : selectedDefect.test_run_name || "-"}
                    </dd>
                  </div>
                  <div>
                    <dt>시나리오</dt>
                    <dd>
                      {isManualSelectedDefect
                        ? "-"
                        : selectedDefect.scenario_name || "-"}
                    </dd>
                  </div>
                  <div>
                    <dt>케이스</dt>
                    <dd>
                      {isManualSelectedDefect
                        ? "직접 등록"
                        : `${selectedDefect.case_code} · ${selectedDefect.case_name}`}
                    </dd>
                  </div>
                  <div>
                    <dt>위치</dt>
                    <dd>
                      {isManualSelectedDefect
                        ? selectedDefect.manual_location || "-"
                        : selectedDefect.location || "-"}
                    </dd>
                  </div>
                  <div>
                    <dt>최초등록일</dt>
                    <dd>{formatDateTime(selectedDefect.created_at)}</dd>
                  </div>
                  <div>
                    <dt>마지막 수정일</dt>
                    <dd>{formatDateTime(selectedDefect.updated_at)}</dd>
                  </div>
                </dl>

                <div className="defect-description">
                  <h3>접수 내용</h3>
                  <p>{selectedDefect.description || "-"}</p>
                </div>

                <div className="defect-description">
                  <h3>테스트 기준</h3>
                  <dl className="defect-case-detail-list">
                    <div>
                      <dt>사전조건</dt>
                      <dd>{selectedDefect.precondition || "-"}</dd>
                    </div>
                    <div>
                      <dt>테스트 스텝</dt>
                      <dd>{selectedDefect.test_steps || "-"}</dd>
                    </div>
                    <div>
                      <dt>예상결과</dt>
                      <dd>{selectedDefect.expected_result || "-"}</dd>
                    </div>
                  </dl>
                </div>

                <div className="defect-evidence-box">
                  <h3>증빙 정보</h3>
                  <dl className="defect-evidence-fields">
                    <div>
                      <dt>견적번호</dt>
                      <dd>{selectedDefect.evidence?.estimate_number || "-"}</dd>
                    </div>
                    <div>
                      <dt>로그인ID</dt>
                      <dd>{selectedDefect.evidence?.target_login_id || "-"}</dd>
                    </div>
                  </dl>
                  <div className="defect-image-list">
                    {selectedEvidenceImages.map((image) => (
                      <button
                        key={image.id}
                        type="button"
                        onClick={() => setExpandedEvidenceImage(image)}
                      >
                        <img src={apiUrl(`/${image.file_path}`)} alt="" />
                        <span>{image.name}</span>
                        <small>{formatDateTime(image.created_at)}</small>
                      </button>
                    ))}
                    {selectedEvidenceImages.length === 0 && (
                      <span className="defect-no-images">
                        첨부 이미지가 없습니다.
                      </span>
                    )}
                  </div>
                </div>

                <div className="defect-evidence-box">
                  <h3>조치결과 이미지</h3>
                  <div className="defect-image-list">
                    {selectedActionImages.map((image) => (
                      <button
                        key={`action-${image.id}`}
                        type="button"
                        onClick={() => setExpandedEvidenceImage(image)}
                      >
                        <img src={apiUrl(`/${image.file_path}`)} alt="" />
                        <span>{image.name}</span>
                        <small>{formatDateTime(image.created_at)}</small>
                      </button>
                    ))}
                    {selectedActionImages.length === 0 && (
                      <span className="defect-no-images">
                        첨부 이미지가 없습니다.
                      </span>
                    )}
                  </div>
                </div>

                {canAssign && (
                  <div className="defect-action-box">
                    <label>
                      <span>처리 담당자</span>
                      <select
                        value={selectedAssigneeId}
                        onChange={(event) =>
                          setSelectedAssigneeId(event.target.value)
                        }
                      >
                        <option value="">담당자 선택</option>
                        {assignees.map((assignee) => (
                          <option key={assignee.id} value={assignee.id}>
                            {assignee.name} ({assignee.login_id})
                          </option>
                        ))}
                      </select>
                    </label>
                    <button
                      type="button"
                      className="primary-button"
                      disabled={isSavingDefect || selectedAssigneeId === ""}
                      onClick={assignDefect}
                    >
                      담당자 지정
                    </button>
                  </div>
                )}

                <div className="defect-action-box">
                  <label>
                    <span>조치 내용</span>
                    <textarea
                      value={defectActionMemo}
                      onChange={(event) =>
                        setDefectActionMemo(event.target.value)
                      }
                      rows={5}
                      disabled={!canCompleteAction}
                    />
                  </label>
                  {canCompleteAction && (
                    <>
                      <div
                        className={`evidence-dropzone compact ${
                          isDraggingActionFiles ? "is-dragging" : ""
                        }`}
                        tabIndex={0}
                        onPaste={handleActionPaste}
                        onDragOver={(event) => {
                          event.preventDefault();
                          setIsDraggingActionFiles(true);
                        }}
                        onDragLeave={() => setIsDraggingActionFiles(false)}
                        onDrop={(event) => {
                          event.preventDefault();
                          setIsDraggingActionFiles(false);
                          addActionFiles(event.dataTransfer.files);
                        }}
                      >
                        <strong>조치결과 이미지 첨부</strong>
                        <span>
                          파일을 끌어오거나 캡처 이미지를 붙여넣으세요(Ctrl + V)
                        </span>
                        <button
                          type="button"
                          className="secondary-button"
                          onClick={() => actionFileInputRef.current?.click()}
                        >
                          파일 선택
                        </button>
                        <input
                          ref={actionFileInputRef}
                          type="file"
                          accept="image/*"
                          multiple
                          onChange={(event) => {
                            addActionFiles(event.target.files);
                            event.target.value = "";
                          }}
                        />
                      </div>

                      {actionFiles.length > 0 && (
                        <div className="evidence-preview-list">
                          {actionFiles.map((file) => (
                            <div key={file.id} className="evidence-preview">
                              <img src={file.previewUrl} alt="" />
                              <div>
                                <strong>{file.name}</strong>
                                <span>
                                  새 첨부 ·{" "}
                                  {Math.ceil(file.size / 1024).toLocaleString()}{" "}
                                  KB
                                </span>
                              </div>
                              <button
                                type="button"
                                aria-label="첨부 제거"
                                onClick={() => removeActionFile(file.id)}
                              >
                                x
                              </button>
                            </div>
                          ))}
                        </div>
                      )}
                    </>
                  )}
                  {canCompleteAction && (
                    <button
                      type="button"
                      className="primary-button"
                      disabled={
                        isSavingDefect || defectActionMemo.trim() === ""
                      }
                      onClick={completeDefectAction}
                    >
                      조치완료
                    </button>
                  )}
                </div>

                {canVerify && (
                  <div className="defect-verification-actions">
                    <button
                      type="button"
                      className="primary-button defect-verify-button"
                      disabled={isSavingDefect}
                      onClick={verifyDefect}
                    >
                      확인완료
                    </button>
                    <button
                      type="button"
                      className="secondary-button defect-verify-button"
                      disabled={isSavingDefect}
                      onClick={() =>
                        isManualSelectedDefect
                          ? openManualReDefectDialog(selectedDefect)
                          : openReDefectDialog(selectedDefect)
                      }
                    >
                      재결함등록
                    </button>
                  </div>
                )}

                {defectMessage && (
                  <p className="form-message is-error">{defectMessage}</p>
                )}
              </>
            ) : (
              <>
                <p className="empty-message">결함을 선택해주세요.</p>
                {defectMessage && (
                  <p className="form-message is-error">{defectMessage}</p>
                )}
              </>
            )}
          </div>
        </section>
      );
    }

    return (
      <div className="welcome-panel">
        <p className="user-role">{currentRoleLabel}</p>
        <h1>{dashboardMenus.find((menu) => menu.id === activeMenu)?.label}</h1>
        <p>{currentUser.organization} 소속으로 로그인되었습니다.</p>
      </div>
    );
  };

  if (isCheckingSession) {
    return (
      <main className="app-shell">
        <div className="loading-box">확인 중</div>
      </main>
    );
  }

  if (isTestLoginPath) {
    return (
      <main className="app-shell">
        <section className="test-login-box" aria-label="테스트 로그인">
          <div className="brand">
            <img
              style={{ width: "50px" }}
              src={`${import.meta.env.BASE_URL}hana-ci.svg`}
              alt=""
            />
            <p className="brand-name">
              테스트 로그인<span>계정 선택</span>
            </p>
          </div>

          <div className="test-login-list">
            {testLoginAccounts.map((account) => (
              <button
                key={account.loginId}
                type="button"
                className="test-login-account"
                disabled={testLoginLoadingId !== ""}
                onClick={() => loginWithTestAccount(account)}
              >
                <strong>{account.label}</strong>
                <span>
                  {testLoginLoadingId === account.loginId
                    ? "로그인 중"
                    : "클릭해서 로그인"}
                </span>
              </button>
            ))}
          </div>

          {testLoginMessage && (
            <p className="form-message is-error">{testLoginMessage}</p>
          )}

          <button
            type="button"
            className="text-button"
            onClick={() => {
              window.location.href = appRootPath;
            }}
          >
            일반 로그인으로 이동
          </button>
        </section>
      </main>
    );
  }

  if (currentUser) {
    return (
      <main className="dashboard-shell">
        <header className="dashboard-header">
          <div className="dashboard-brand">
            <img
              src={`${import.meta.env.BASE_URL}hana-ci.svg`}
              alt=""
              className="dashboard-ci"
            />
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
                className={activeMenu === menu.id ? "is-active" : ""}
                onClick={() => setActiveMenu(menu.id)}
              >
                {menu.label}
              </button>
            ))}
          </nav>

          <div className="dashboard-user">
            <div>
              <strong>{currentUser.name}</strong>
              <span>
                {currentUser.organization} · {currentRoleLabel}
              </span>
            </div>
            <button type="button" className="logout-button" onClick={logout}>
              로그아웃
            </button>
          </div>
        </header>

        <section className="dashboard-main">{renderDashboardContent()}</section>

        {evidenceDialog.isOpen && (
          <div className="modal-backdrop" role="presentation">
            <form
              className="evidence-modal"
              onSubmit={submitEvidenceResult}
              onPaste={handleEvidencePaste}
            >
              <div className="modal-header">
                <div>
                  <h2>
                    {evidenceDialog.mode === "redefect"
                      ? "재결함 등록"
                      : "결과 증빙 등록"}
                  </h2>
                  <p>
                    {evidenceDialog.testCase?.case_code} ·{" "}
                    {
                      resultOptions.find(
                        (option) =>
                          option.value === evidenceDialog.resultStatus,
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
                  ref={evidenceDescriptionRef}
                  name="description"
                  key={`description-${evidenceDialog.testCase?.id ?? "new"}-${evidenceDialog.mode}-${evidenceDialog.isLoading ? "loading" : "ready"}`}
                  defaultValue={evidenceDialog.description}
                  placeholder="확인한 현상, 재현 조건, 기대와 다른 부분을 적어주세요."
                  rows={5}
                />
              </label>

              <div className="evidence-field-grid">
                <label>
                  <span>견적번호(선택)</span>
                  <input
                    ref={evidenceEstimateNumberRef}
                    type="text"
                    name="estimateNumber"
                    key={`estimate-${evidenceDialog.testCase?.id ?? "new"}-${evidenceDialog.mode}-${evidenceDialog.isLoading ? "loading" : "ready"}`}
                    defaultValue={evidenceDialog.estimateNumber}
                    placeholder="선택 입력"
                  />
                </label>
                <label>
                  <span>로그인ID(선택)</span>
                  <input
                    ref={evidenceTargetLoginIdRef}
                    type="text"
                    name="targetLoginId"
                    key={`target-login-${evidenceDialog.testCase?.id ?? "new"}-${evidenceDialog.mode}-${evidenceDialog.isLoading ? "loading" : "ready"}`}
                    defaultValue={evidenceDialog.targetLoginId}
                    placeholder="선택 입력"
                  />
                </label>
              </div>

              <div
                className={`evidence-dropzone ${
                  evidenceDialog.isDragging ? "is-dragging" : ""
                }`}
                onDragOver={(event) => {
                  event.preventDefault();
                  setEvidenceDialog((current) => ({
                    ...current,
                    isDragging: true,
                  }));
                }}
                onDragLeave={() =>
                  setEvidenceDialog((current) => ({
                    ...current,
                    isDragging: false,
                  }))
                }
                onDrop={(event) => {
                  event.preventDefault();
                  setEvidenceDialog((current) => ({
                    ...current,
                    isDragging: false,
                  }));
                  addEvidenceFiles(event.dataTransfer.files);
                }}
              >
                <strong>이미지 첨부</strong>
                <span>
                  파일을 끌어오거나, 이 창에서 캡처 이미지를 붙여넣으세요(Ctrl +
                  V)
                </span>
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
                    addEvidenceFiles(event.target.files);
                    event.target.value = "";
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
                          {file.isExisting ? "기존 첨부" : "새 첨부"} ·{" "}
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
                <p className="form-message is-error">
                  {evidenceDialog.message}
                </p>
              )}

              <button
                type="submit"
                className="primary-button"
                disabled={isSavingEvidence || evidenceDialog.isLoading}
              >
                {isSavingEvidence ? "저장 중" : "결과 저장"}
              </button>
            </form>
          </div>
        )}

        {manualDefectDialog.isOpen && (
          <div className="modal-backdrop" role="presentation">
            <form
              className="evidence-modal manual-defect-modal"
              onSubmit={submitManualDefect}
              onPaste={handleManualDefectPaste}
            >
              <div className="modal-header">
                <div>
                  <h2>
                    {manualDefectDialog.mode === "redefect"
                      ? "재결함 등록"
                      : "결함 직접 등록"}
                  </h2>
                  <p>테스트 케이스 외 결함 티켓을 발행합니다.</p>
                </div>
                <button
                  type="button"
                  className="close-button"
                  aria-label="닫기"
                  onClick={() => closeManualDefectDialog()}
                >
                  x
                </button>
              </div>

              <label>
                <span>결함 구분</span>
                <select
                  value={manualDefectDialog.resultStatus}
                  onChange={(event) =>
                    setManualDefectDialog((current) => ({
                      ...current,
                      resultStatus: event.target.value,
                    }))
                  }
                >
                  {resultOptions
                    .filter((option) => evidenceStatuses.includes(option.value))
                    .map((option) => (
                      <option key={option.value} value={option.value}>
                        {option.label}
                      </option>
                    ))}
                </select>
              </label>

              <label>
                <span>결함명</span>
                <input
                  ref={manualDefectTitleRef}
                  type="text"
                  name="manualDefectTitle"
                  key={`manual-title-${manualDefectDialog.defectId ?? "new"}-${manualDefectDialog.mode}`}
                  defaultValue={manualDefectDialog.title}
                  placeholder="예: 계약 상세 화면 금액 합계 오류"
                />
              </label>

              <label>
                <span>발생 위치/화면</span>
                <input
                  ref={manualDefectLocationRef}
                  type="text"
                  name="manualDefectLocation"
                  key={`manual-location-${manualDefectDialog.defectId ?? "new"}-${manualDefectDialog.mode}`}
                  defaultValue={manualDefectDialog.manualLocation}
                  placeholder="예: 렌터카 > 계약관리 > 계약 상세"
                />
              </label>

              <label>
                <span>설명</span>
                <textarea
                  ref={manualDefectDescriptionRef}
                  name="manualDefectDescription"
                  key={`manual-description-${manualDefectDialog.defectId ?? "new"}-${manualDefectDialog.mode}`}
                  defaultValue={manualDefectDialog.description}
                  placeholder="발생 현상, 재현 순서, 기대 결과와 다른 점을 적어주세요."
                  rows={6}
                />
              </label>

              <div
                className={`evidence-dropzone ${
                  manualDefectDialog.isDragging ? "is-dragging" : ""
                }`}
                onDragOver={(event) => {
                  event.preventDefault();
                  setManualDefectDialog((current) => ({
                    ...current,
                    isDragging: true,
                  }));
                }}
                onDragLeave={() =>
                  setManualDefectDialog((current) => ({
                    ...current,
                    isDragging: false,
                  }))
                }
                onDrop={(event) => {
                  event.preventDefault();
                  setManualDefectDialog((current) => ({
                    ...current,
                    isDragging: false,
                  }));
                  addManualDefectFiles(event.dataTransfer.files);
                }}
              >
                <strong>증빙 이미지 첨부</strong>
                <span>
                  파일을 끌어오거나 캡처 이미지를 붙여넣으세요(Ctrl + V)
                </span>
                <button
                  type="button"
                  className="secondary-button"
                  onClick={() => manualDefectFileInputRef.current?.click()}
                >
                  파일 선택
                </button>
                <input
                  ref={manualDefectFileInputRef}
                  type="file"
                  accept="image/*"
                  multiple
                  onChange={(event) => {
                    addManualDefectFiles(event.target.files);
                    event.target.value = "";
                  }}
                />
              </div>

              {manualDefectDialog.files.length > 0 && (
                <div className="evidence-preview-list">
                  {manualDefectDialog.files.map((file) => (
                    <div key={file.id} className="evidence-preview">
                      <img src={file.previewUrl} alt="" />
                      <div>
                        <strong>{file.name}</strong>
                        <span>
                          새 첨부 ·{" "}
                          {Math.ceil(file.size / 1024).toLocaleString()} KB
                        </span>
                      </div>
                      <button
                        type="button"
                        aria-label="첨부 제거"
                        onClick={() => removeManualDefectFile(file.id)}
                      >
                        x
                      </button>
                    </div>
                  ))}
                </div>
              )}

              {manualDefectDialog.message && (
                <p className="form-message is-error">
                  {manualDefectDialog.message}
                </p>
              )}

              <button
                type="submit"
                className="primary-button"
                disabled={isSavingDefect}
              >
                {isSavingDefect
                  ? "등록 중"
                  : manualDefectDialog.mode === "redefect"
                    ? "재결함 등록"
                    : "결함 티켓 발행"}
              </button>
            </form>
          </div>
        )}

        {expandedEvidenceImage && (
          <div
            className="image-viewer-backdrop"
            role="presentation"
            onClick={() => setExpandedEvidenceImage(null)}
          >
            <div
              className="image-viewer"
              role="dialog"
              aria-modal="true"
              aria-label="첨부 이미지 확대"
              onClick={(event) => event.stopPropagation()}
            >
              <div className="image-viewer-header">
                <strong>{expandedEvidenceImage.name}</strong>
                <button
                  type="button"
                  className="close-button"
                  aria-label="닫기"
                  onClick={() => setExpandedEvidenceImage(null)}
                >
                  x
                </button>
              </div>
              <img src={apiUrl(`/${expandedEvidenceImage.file_path}`)} alt="" />
            </div>
          </div>
        )}

        <CommonDialog
          isOpen={dialog.isOpen}
          title={dialog.title}
          message={dialog.message}
          confirmText={dialog.confirmText}
          cancelText={dialog.cancelText}
          onConfirm={dialog.onConfirm ?? closeDialog}
          onCancel={dialog.onCancel}
        />
      </main>
    );
  }

  if (isPublicHelpOpen) {
    return (
      <main className="app-shell public-help-shell">
        <HelpContent onBack={() => setIsPublicHelpOpen(false)} />
      </main>
    );
  }

  return (
    <main className="app-shell">
      <form className="login-box" onSubmit={submitLogin}>
        <div className="brand">
          {" "}
          <img
            style={{ width: "50px" }}
            src={`${import.meta.env.BASE_URL}hana-ci.svg`}
            alt=""
          />
          <p className="brand-name">
            하나원큐오토<span>웹기반 플랫폼 구축</span>
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
          {isLoggingIn ? "확인 중" : "로그인"}
        </button>

        <button type="button" className="secondary-button" onClick={openSignup}>
          회원가입
        </button>

        <button
          type="button"
          className="text-button"
          onClick={() => setIsPublicHelpOpen(true)}
        >
          도움말 보기
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
                  {isLoadingOrganizations ? "불러오는 중" : "소속 선택"}
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
                onBlur={(event) =>
                  checkSignupLoginId(event.currentTarget.value)
                }
              />
            </label>

            {loginIdCheck.message && (
              <p
                className={
                  loginIdCheck.available
                    ? "form-message is-success"
                    : loginIdCheck.isChecking
                      ? "form-message"
                      : "form-message is-error"
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
              {isSubmitting ? "처리 중" : "가입하기"}
            </button>
          </form>
        </div>
      )}

      <CommonDialog
        isOpen={dialog.isOpen}
        title={dialog.title}
        message={dialog.message}
        confirmText={dialog.confirmText}
        cancelText={dialog.cancelText}
        onConfirm={dialog.onConfirm ?? closeDialog}
        onCancel={dialog.onCancel}
      />
    </main>
  );
}

export default App;
