<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<script type="text/javascript" src="/resources/js/header.js"></script>
<script type="text/javascript" src="/resources/js/popularRest.js"></script>

<header class="com-border-bottom">
    <div class="title-wrapper">

        <div class="header-left">
            <div id="popular-container" class="popular-restaurant-wrapper">
                <h5 class="popular-restaurant-title">#요즘_핫한_맛집</h5>
                <div class="popular-restaurant-list com-border">
                    <a href="#" id="restaurant-rotation"></a>
                </div>
                <div class="popular-restaurant-popup com-border com-shadow com-bg">
                    <ul id="restaurant-full-list"></ul>
                </div>
            </div>
        </div>

        <div class="header-center">
            <a href="/" class="logo">
                <img src="/resources/img/logo-temp.png" alt="로고">
            </a>
        </div>

        <div class="header-right">
            <div class="header-btn-wrapper">
                <a href="javascript:void(0)" id="change-mode" class="com-btn-circle com-btn-secondary com-border com-shadow"><i class="mode-icon"></i></a>
                <a href="/map" id="goto-map" class="com-btn-circle com-btn-secondary com-border com-shadow"><i class="fas fa-map"></i></a>
                
                <c:choose>
                    <c:when test="${empty member}">
                        <a href="javascript:void(0)" id="do-login" class="com-btn-circle com-btn-secondary com-border com-shadow"><i class="fas fa-user"></i></a>
                    </c:when>
                    <c:otherwise>
                        <a href="javascript:void(0)" id="open-profile" class="com-btn-circle com-btn-secondary com-border com-shadow"><i class="fas fa-user"></i></a>
                    </c:otherwise>
                </c:choose>
    
                <div id="profile-modal" class="profile-modal com-border com-shadow com-round hidden">
                    <div id="modal-content">
                        <p><strong>사용자 프로필</strong></p>
                        <a href="/myzip" id="view-profile" class="no-style-button com-border com-round">프로필 보기</a>
                        <a href="/member/logout.do" class="no-style-button com-border com-round">로그아웃</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 모달 등장시 주변 어두워지게 하는 오버레이 -->
    <div id="modal-overlay" class="modal-overlay hidden"></div>

    <!-- 로그인/회원가입 모달 -->
    <div id="login-register" class="com-border com-shadow com-round com-bg hidden">

        <button type="button" id="modal-close-btn" class="modal-close-btn com-color-primary com-round com-btn-secondary com-border com-shadow">
            <i class="far fa-times"></i>
        </button>
    
        <!-- 비밀번호 실시간 유효성 검사 툴팁 -->
        <div class="password-tooltip hidden" id="password-tooltip">
            <ul>
                <li id="length-check" class="invalid">8자 이상 입력</li>
                <li id="uppercase-check" class="invalid">대문자 포함</li>
                <li id="lowercase-check" class="invalid">소문자 포함</li>
                <li id="number-check" class="invalid">숫자 포함</li>
                <li id="special-check" class="invalid">특수문자 포함</li>
            </ul>
        </div>

        <!-- 트랜지션을 위한 overflow hidden 속성 div -->
        <div class="login-register-wrapper">
            <div class="login-register-screen screen-expand">

                <!-- 로그인 컨테이너 -->
                <div class="login-container">
                    <div class="login-register-header">
                        <div class="form-logo">
                            <img src="/resources/img/logo-temp.png" alt="로고">
                        </div>
                    </div>
                    <div class="login-register-contents">
                        <form action="/loginProcess.do" method="post">
                            
                            <div class="login-input">
                                <input type="email" name="memberId" placeholder="이메일" class="input-text com-bg com-color com-border com-round">
                                <input type="password" name="memberPw" placeholder="비밀번호" class="input-text com-bg com-color com-border com-round">
                                <p id="error-message" class="error-message"></p>
                                <div class="login-input-footer">
                                    <div class="remember-login-wrapper">
                                        <input type="checkbox" name="remember_login" id="remember_login">
                                        <label for="remember_login">아이디 기억하기</label>
                                    </div>
                                    <a href="javascript:void(0)" class="forgot-password login-desc">내 계정 찾기</a>
                                </div>
                            </div>
                            <div class="login-register-button-wrapper">
                                <input type="submit" id="btn-login" class="com-border com-round com-btn-primary" value="로그인">
                                <div class="login-register-footer">
                                    <span class="register-title login-desc">아직 회원이 아니신가요?</span>
                                    <a href="javascript:void(0)" class="button-register login-desc">회원가입</a>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="sns-login-wrapper">
                        <span class="sns-login-title login-desc">간편 로그인</span>
                        <div class="sns-login-btn-bundle">
                            <a href="/social/kakao/login" class="com-border com-shadow kakao"><img src="/resources/img/ico/ico-kakao.svg" alt="카카오 로고"></a>
                            <a href="/social/naver/login" class="com-border com-shadow naver"><img src="/resources/img/ico/ico-naver.svg" alt="네이버 로고"></a>
                            <a href="/social/google/login" class="com-border com-shadow google"><img src="/resources/img/ico/ico-google.svg" alt="구글 로고"></a>
                        </div>
                    </div>
                </div>
                <!-- 로그인 컨테이너 끝 -->
        
                <!-- 회원가입 컨테이너 -->
                <div class="register-container hidden">
                    <div class="login-register-header">
                        <div class="step-indicator">
                            <div class="com-color-primary step-1 active">약관 동의</div>
                            <div class="com-color-primary step-2">계정 생성</div>
                            <div class="com-color-primary step-3">정보 입력</div>
                        </div>
                    </div>
                    <div class="login-register-contents">
                        <form action="/member/joinProcess.do" method="post">
                            <div id="register-page-1" class="register-step login-input">
                                <div class="welcome-wrapper">
                                    <h1>안녕하세요!</p>
                                    <h3>맛.zip 사이트 가입을 환영합니다.</h3>
                                    <p class="welcome-desc">원활한 사이트 이용을 위해<br>아래 약관에 동의해주세요.</p>
                                    <div class="register-agreement-wrapper">
                                        <input type="checkbox" name="register_agreement" id="register_agreement">
                                        <label for="register_agreement" id="register_agreement_label">이용 약관 동의</label>
                                    </div>
                                    <div class="login-register-button-wrapper">
                                    <button type="button" id="btn-next-step-1" class="btn-next-step com-border com-round com-btn-primary" disabled>다음</button>
                                        <div class="login-register-footer">
                                            <span class="register-title login-desc">이미 회원이라면</span>
                                            <a href="javascript:void(0)" class="button-login login-desc">로그인</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- 약관 동의 팝업 -->
                            <div id="terms-modal">
                                <div id="terms-content" class="terms-content com-bg com-border com-round">
                                    <div class="terms-item">
                                        <div class="terms-checkbox-wrapper">
                                            <input type="checkbox" id="all-agree" class="terms-checkbox">
                                            <label for="all-agree" class="terms-checkbox-label">
                                                <strong>전체 동의하기</strong>
                                            </label>
                                        </div>
                                        <div class="terms-item-content com-border com-round">
                                            <p>실명 인증된 아이디로 가입, 위치기반 서비스 이용약관(선택), 이벤트 및 혜택 정보 수신(선택) 동의를 포함합니다.</p>
                                        </div>
                                    </div>
        
                                    <div class="terms-item">
                                        <div class="terms-checkbox-wrapper">
                                            <input type="checkbox" id="agree-service" class="terms-checkbox">
                                            <label for="agree-service" class="terms-checkbox-label">
                                                <strong>맛.zip 이용 약관 (필수)</strong>
                                                <a href="javascript:void(0);" class="view-full-terms" data-terms="service">전체보기</a>
                                            </label>
                                        </div>
                                        <div class="terms-item-content com-border com-round">
                                            <p>맛집의 서비스를 이용해주셔서 감사합니다. 본 약관은 맛.zip 이용과 관련하여 맛집 서비스를 제공하는 Team TasteZip 와 이를 이용하는 Lorem, ipsum dolor sit amet consectetur adipisicing elit. Provident minima suscipit sunt rem temporibus alias hic autem rerum nihil voluptatem ipsa nulla, possimus culpa atque harum debitis omnis ex vel.</p>
                                        </div>
                                    </div>
        
                                    <div class="terms-item">
                                        <div class="terms-checkbox-wrapper">
                                            <input type="checkbox" id="agree-privacy" class="terms-checkbox">
                                            <label for="agree-privacy" class="terms-checkbox-label">
                                                <strong>개인정보 수집 및 이용 (필수)</strong>
                                                <a href="javascript:void(0);" class="view-full-terms" data-terms="privacy">전체보기</a>
                                            </label>
                                        </div>
                                        <div class="terms-item-content com-border com-round">
                                            <p>개인정보보호법에 따라 맛.zip 에 회원가입 신청하시는 분께 수집하는 개인정보의 항목, 개인 정보의 수집 및 이용목적, 개인정보의 보유 및 이용기간 Lorem ipsum dolor sit amet consectetur adipisicing elit. Officia voluptate sint sed ut obcaecati illum vero explicabo iusto debitis consequatur? Ad, aspernatur illum nulla molestias assumenda ipsa? Officiis, a suscipit!</p>
                                        </div>
                                    </div>
        
                                    <div class="terms-item">
                                        <div class="terms-checkbox-wrapper">
                                            <input type="checkbox" id="agree-location" class="terms-checkbox">
                                            <label for="agree-location" class="terms-checkbox-label">
                                                <strong>위치기반 서비스 이용약관 (선택)</strong>
                                                <a href="javascript:void(0);" class="view-full-terms" data-terms="location">전체보기</a>
                                            </label>
                                        </div>
                                        <div class="terms-item-content com-border com-round">
                                            <p>위치기반 서비스 이용약관에 동의하시면, 위치를 활용한 광고 정보 수신 등을 포함하는 맛.zip 위치기반 서비스를 이용할 수 있습니다 Lorem ipsum dolor sit, amet consectetur adipisicing elit. Id voluptas, aliquam asperiores delectus amet totam dignissimos perspiciatis doloremque repellat deleniti, ipsam voluptates. Sequi tenetur numquam aliquid quos delectus dolorem dicta.</p>
                                        </div>
                                    </div>
                                    <button type="button" id="agree-button" class="com-border com-btn-primary com-round" disabled>동의하기</button>
                                </div>
                            </div>
                            <!-- 스텝 2, 계정 정보 입력 -->
                            <div id="register-page-2" class="register-step login-input hidden">
                                <div class="email-input-wrapper">
                                    <input type="text" name="memberId" id="reg_member_id" placeholder="아이디(이메일)" class="input-text com-bg com-color com-border com-round">
                                    <button type="button" id="checkId" class="get-confirm com-btn-secondary com-round com-border">중복확인</button>
                                </div>
                                <p id="resultMsg" class="error-message"></p>
                            
                                <div id="auth_num_section" class="email-input-wrapper" style="display: none;">
                                    <input type="text" id="auth_num_input" class="input-text com-bg com-color com-border com-round" placeholder="인증번호 6자리 입력" maxlength="6">
                                    <button type="button" id="confirm_email_btn" class="get-confirm com-btn-secondary com-round com-border">확인</button>
                                </div>
        
                                <input type="hidden" name="result_confirm" id="result_confirm">
                                <p id="resultEmail" class="error-message"></p>
        
                                <input type="password" name="memberPw" id="reg_member_pw" class="input-text com-bg com-color com-border com-round" placeholder="비밀번호">
                                <p id="password-error" class="error-message"></p>
                            
                                <input type="password" name="auth_num_pw" id="confirm_password" class="input-text com-bg com-color com-border com-round" placeholder="비밀번호 확인">
                                <p id="confirmPassword-error" class="error-message"></p>
        
                                <div class="login-register-button-wrapper">
                                    <button type="button" id="btn-next-step-2" class="btn-next-step com-border com-round com-btn-primary" disabled>다음</button>
                                </div>
                            </div>
                            <!-- 스텝 3, 사용자 정보 입력 -->
                            <div id="register-page-3" class="register-step login-input hidden">

                                <div class="welcome-wrapper com-color-primary">
                                    <h2>거의 다 왔습니다!</h2>
                                    <h3 class="welcome-desc">아래 추가 정보들을 입력하고<br>가입을 완료해주세요</h3>
                                </div>

                                <!-- 이름 -->
                                <input type="text" id="memberName" name="memberName" class="input-text com-bg com-color com-border com-round" placeholder="이름">
                                <p id="name-error" class="error-message"></p>
                                
                                <!-- 프론트에서 보낼 때 phone 으로 컬럼명 설정 -->
                                <div class="phone-num-wrapper">
                                    <select id="member_phone_front" name="member_phone_front" class="input-text com-bg com-color com-border com-round" readonly>
                                        <option value="010" selected>010</option>
                                    </select>
                                    <input type="text" id="member_phone_middle" name="member_phone_middle" placeholder="1234" class="input-text com-bg com-color com-border com-round" maxlength="4">
                                    <input type="text" id="member_phone_back" name="member_phone_back" placeholder="5678" class="input-text com-bg com-color com-border com-round" maxlength="4">
                                </div>
                                <p id="phone-num-error" class="error-message"></p>

                                <!-- 생년월일 8자리 -->
                                <input type="text" name="birthday" placeholder="생년월일 8자리" class="input-text com-bg com-color com-border com-round" maxlength="8">
                                <p id="birthday-error" cl       ass="error-message"></p>
        
                                <!-- 최종 회원가입 폼 제출 -->
                                <div class="login-register-button-wrapper">
                                    <input type="submit" id="btn-register" class="btn-next-step com-border com-round com-btn-primary" value="회원가입" disabled>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="sns-login-wrapper hidden">
                        <span class="sns-login-title login-desc">간편 회원가입</span>
                        <div class="sns-login-btn-bundle">
                            <a href="/social/kakao/login" class="com-border com-shadow kakao"><img src="/resources/img/ico/ico-kakao.svg" alt="카카오 로고"></a>
                            <a href="/social/naver/login" class="com-border com-shadow naver"><img src="/resources/img/ico/ico-naver.svg" alt="네이버 로고"></a>
                            <a href="/social/google/login" class="com-border com-shadow google"><img src="/resources/img/ico/ico-google.svg" alt="구글 로고"></a>
                        </div>
                    </div>
                </div>
                <!-- 회원가입 컨테이너 끝 -->
                 
            </div>
        </div>
    </div>

</header>