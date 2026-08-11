import { useEffect, useState } from "react";
import manualLoginImage from "../assets/manual/1-1_main.png";
import manualSignupImage from "../assets/manual/1-2_join.png";
import manualLoginFilledImage from "../assets/manual/1-3_login.png";
import manualTestingMenuImage from "../assets/manual/2-1_test.png";
import manualTestingCaseSelectImage from "../assets/manual/2-2_test.png";
import manualTestingPassedImage from "../assets/manual/2-3_test.png";
import manualTestingFailedImage from "../assets/manual/2-4_test.png";
import manualTestingDefectReceivedImage from "../assets/manual/2-5_test.png";
import manualVerificationDashboardImage from "../assets/manual/3-1.png";
import manualVerificationPendingImage from "../assets/manual/3-2.png";
import manualVerificationDecisionImage from "../assets/manual/3-3.png";
import manualVerificationReDefectImage from "../assets/manual/3-4.png";

const helpNavItems = [
  { id: "help-signup-login", label: "1. 회원가입 및 로그인" },
  { id: "help-testing", label: "2. 테스트 수행" },
  { id: "help-verification", label: "3. 결함확인 단계" },
];

function HelpContent({ onBack }) {
  const [activeHelpSectionId, setActiveHelpSectionId] = useState(
    "help-signup-login",
  );

  useEffect(() => {
    const updateActiveHelpSection = () => {
      const sections = helpNavItems
        .map((item) => document.getElementById(item.id))
        .filter(Boolean);

      if (sections.length === 0) {
        return;
      }

      const currentSection =
        sections.findLast(
          (section) => section.getBoundingClientRect().top <= 180,
        ) ?? sections[0];

      setActiveHelpSectionId(currentSection.id);
    };

    requestAnimationFrame(updateActiveHelpSection);
    window.addEventListener("scroll", updateActiveHelpSection, {
      passive: true,
    });
    window.addEventListener("resize", updateActiveHelpSection);

    return () => {
      window.removeEventListener("scroll", updateActiveHelpSection);
      window.removeEventListener("resize", updateActiveHelpSection);
    };
  }, []);

  return (
    <section className="help-page">
      <div className="help-header">
        <div>
          <p className="user-role">테스터 매뉴얼</p>
          <h1>도움말</h1>
          <p>
            통합테스트 시스템을 처음 사용하는 테스터를 위한 단계별 안내입니다.
          </p>
        </div>
        {onBack && (
          <button type="button" className="secondary-button" onClick={onBack}>
            로그인으로 돌아가기
          </button>
        )}
      </div>

      <nav className="help-toc" aria-label="도움말 목차">
        {helpNavItems.map((item) => (
          <a
            key={item.id}
            href={`#${item.id}`}
            className={activeHelpSectionId === item.id ? "is-active" : ""}
            onClick={() => setActiveHelpSectionId(item.id)}
          >
            {item.label}
          </a>
        ))}
      </nav>

      <section id="help-signup-login" className="help-section">
        <h2>1. 회원가입 및 로그인</h2>

        <article className="help-step">
          <div>
            <span>1.1</span>
            <h3>메인화면</h3>
            <p>
              시스템에 접속하면 로그인 화면이 표시됩니다. 기존 계정이 있는 경우
              아이디와 비밀번호를 입력해 로그인합니다.
            </p>
            <p>
              계정이 없는 경우 하단의 <strong>회원가입</strong> 버튼을
              클릭합니다.
            </p>
          </div>
          <img src={manualLoginImage} alt="로그인 메인화면" />
        </article>

        <article className="help-step">
          <div>
            <span>1.2</span>
            <h3>회원가입</h3>
            <p>
              회원가입 화면에서 소속, 이름, 아이디, 비밀번호, 비밀번호 확인을
              입력합니다.
            </p>
            <p>
              입력한 정보를 확인한 뒤 <strong>가입하기</strong> 버튼을
              클릭합니다. 비밀번호와 비밀번호 확인 값이 서로 다르면 가입할 수
              없습니다.
            </p>
          </div>
          <img src={manualSignupImage} alt="회원가입 입력 화면" />
        </article>

        <article className="help-step">
          <div>
            <span>1.3</span>
            <h3>로그인</h3>
            <p>
              가입한 아이디와 비밀번호를 입력한 뒤 <strong>로그인</strong>{" "}
              버튼을 클릭합니다.
            </p>
            <p>
              자주 사용하는 PC에서는 필요에 따라 <strong>자동로그인</strong>을
              선택할 수 있습니다. 공용 PC에서는 자동로그인을 사용하지 않는 것을
              권장합니다.
            </p>
          </div>
          <img src={manualLoginFilledImage} alt="아이디와 비밀번호 입력 후 로그인 화면" />
        </article>
      </section>

      <section id="help-testing" className="help-section">
        <h2>2. 테스트 수행</h2>

        <article className="help-step">
          <div>
            <span>2.1</span>
            <h3>테스트 메뉴 진입</h3>
            <p>
              상단 메뉴에서 <strong>통합테스트</strong>를 클릭합니다. 테스트
              수행 화면에서는 테스트 차수, 시나리오, 테스트 케이스를 순서대로
              선택해 결과를 등록합니다.
            </p>
          </div>
          <img src={manualTestingMenuImage} alt="통합테스트 메뉴 진입 화면" />
        </article>

        <article className="help-step">
          <div>
            <span>2.2</span>
            <h3>테스트 케이스 선택</h3>
            <p>
              왼쪽 영역에서 테스트 차수와 시나리오를 선택합니다. 선택한
              시나리오에 포함된 테스트 케이스가 오른쪽에 표시됩니다.
            </p>
            <p>
              각 테스트 케이스의 메뉴, 위치, 사전조건, 테스트 스텝, 예상결과를
              확인한 뒤 실제 수행 결과를 등록합니다.
            </p>
          </div>
          <img src={manualTestingCaseSelectImage} alt="테스트 케이스 선택 화면" />
        </article>

        <article className="help-step">
          <div>
            <span>2.3</span>
            <h3>성공 결과 등록</h3>
            <p>
              테스트 결과가 예상결과와 일치하면 해당 케이스의{" "}
              <strong>성공</strong> 버튼을 클릭합니다.
            </p>
            <p>
              성공으로 등록된 케이스는 진행률에 반영되며, 별도 결함 등록은
              생성되지 않습니다.
            </p>
          </div>
          <img src={manualTestingPassedImage} alt="테스트 성공 버튼 클릭 화면" />
        </article>

        <article className="help-step">
          <div>
            <span>2.4</span>
            <h3>실패 결과 및 결함 내용 등록</h3>
            <p>
              테스트 결과가 예상결과와 다르면 <strong>실패</strong> 버튼을
              클릭합니다. 개선 요청이 필요한 경우에는 <strong>개선</strong>을,
              테스트를 수행할 수 없는 경우에는 <strong>테스트불가</strong>를
              선택합니다.
            </p>
            <p>
              결과 증빙 등록 창에서 현상 설명, 견적번호, 대상 로그인 ID를
              입력하고 필요한 이미지를 첨부한 뒤 결과를 저장합니다.
            </p>
          </div>
          <img src={manualTestingFailedImage} alt="결함 내용 등록 화면" />
        </article>

        <article className="help-step">
          <div>
            <span>2.5</span>
            <h3>접수된 실패 건 확인</h3>
            <p>
              실패, 개선, 테스트불가로 저장한 결과는 결함으로 접수됩니다. 상단
              메뉴의 <strong>결함관리</strong>에서 접수된 결함을 확인할 수
              있습니다.
            </p>
            <p>
              결함 목록에서 항목을 선택하면 테스트 케이스 정보, 등록한 설명,
              증빙 이미지를 확인할 수 있습니다.
            </p>
          </div>
          <img src={manualTestingDefectReceivedImage} alt="결함관리에서 접수된 실패 건 확인 화면" />
        </article>
      </section>

      <section id="help-verification" className="help-section">
        <h2>3. 결함확인 단계</h2>

        <article className="help-step">
          <div>
            <span>3.1</span>
            <h3>대시보드에서 확인 대상 찾기</h3>
            <p>
              대시보드에서 등록 결함 현황과 TODO 목록을 확인합니다. 확인이
              필요한 결함은 TODO 목록에서 바로 선택할 수 있습니다.
            </p>
            <p>
              또는 상단 메뉴의 <strong>결함관리</strong>로 이동해 등록한 결함의
              진행상태를 확인합니다.
            </p>
          </div>
          <img src={manualVerificationDashboardImage} alt="대시보드에서 결함 현황과 TODO 확인 화면" />
        </article>

        <article className="help-step">
          <div>
            <span>3.2</span>
            <h3>테스터 확인대기 결함 확인</h3>
            <p>
              상태가 <strong>테스터 확인대기</strong>인 결함을 선택합니다. 상세
              화면에서 처리 담당자가 입력한 조치 내용과 조치결과 이미지를
              확인합니다.
            </p>
          </div>
          <img src={manualVerificationPendingImage} alt="테스터 확인대기 결함의 조치 내용 확인 화면" />
        </article>

        <article className="help-step">
          <div>
            <span>3.3</span>
            <h3>확인완료 또는 재결함 등록 선택</h3>
            <p>
              조치 내용 확인 후 문제가 해결되었으면 <strong>확인완료</strong>를
              클릭합니다.
            </p>
            <p>
              문제가 해결되지 않았거나 추가 확인이 필요하면{" "}
              <strong>재결함등록</strong>을 클릭합니다.
            </p>
          </div>
          <img src={manualVerificationDecisionImage} alt="확인완료와 재결함등록 버튼 화면" />
        </article>

        <article className="help-step">
          <div>
            <span>3.4</span>
            <h3>재결함 내용 등록</h3>
            <p>
              재결함 등록 화면에서 다시 확인된 현상과 필요한 설명을 입력합니다.
              필요하면 캡처 이미지도 함께 첨부합니다.
            </p>
            <p>등록을 완료하면 결함 티켓이 다시 처리 담당자에게 전달됩니다.</p>
          </div>
          <img src={manualVerificationReDefectImage} alt="재결함 내용과 이미지 첨부 등록 화면" />
        </article>
      </section>
    </section>
  );
}

export default HelpContent;
