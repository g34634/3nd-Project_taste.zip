package com.taste.zip.controller;

import java.util.Map;
import java.util.Optional;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.taste.zip.entity.MemberEntity;
import com.taste.zip.service.MemberService;

@Controller
public class SocialMemberController {

    private static final Logger logger = LoggerFactory.getLogger(SocialMemberController.class);

    private final RestTemplate restTemplate;
    private final MemberService memberService;

    public SocialMemberController(RestTemplate restTemplate, MemberService memberService) {
        this.restTemplate = restTemplate;
        this.memberService = memberService;
    }

    // Kakao 관련 정보
    @Value("${kakao.client-id}")
    private String kakaoClientId;

    @Value("${kakao.client-secret}")
    private String kakaoClientSecret;

    @Value("${kakao.redirect-uri}")
    private String kakaoRedirectUri;

    @Value("${kakao.token-uri}")
    private String kakaoTokenUri;

    @Value("${kakao.user-info-uri}")
    private String kakaoUserInfoUri;

    // Naver 관련 정보
    @Value("${naver.client-id}")
    private String naverClientId;

    @Value("${naver.client-secret}")
    private String naverClientSecret;

    @Value("${naver.redirect-uri}")
    private String naverRedirectUri;

    @Value("${naver.token-uri}")
    private String naverTokenUri;

    @Value("${naver.user-info-uri}")
    private String naverUserInfoUri;

    // Google 관련 정보
    @Value("${google.client-id}")
    private String googleClientId;

    @Value("${google.client-secret}")
    private String googleClientSecret;

    @Value("${google.redirect-uri}")
    private String googleRedirectUri;

    @Value("${google.token-uri}")
    private String googleTokenUri;

    @Value("${google.user-info-uri}")
    private String googleUserInfoUri;

    @PostConstruct
    public void logConfigValues() {
        logger.info("Social configurations loaded.");
    }

    // Google 로그인 URL 생성 및 리다이렉트
    @GetMapping("/social/google/login")
    public String googleLogin() {
        String authorizationUri = "https://accounts.google.com/o/oauth2/v2/auth" +
                "?client_id=" + googleClientId +
                "&redirect_uri=" + googleRedirectUri +
                "&response_type=code" +
                "&scope=email%20profile";
        logger.info("Redirecting to Google authorization URI: {}", authorizationUri);
        return "redirect:" + authorizationUri;
    }

    // Google 콜백 처리
    @GetMapping("/social/google/callback")
    public String googleCallback(@RequestParam("code") String code, Model model, HttpServletRequest request) {
        try {
            // Access Token 가져오기
            String accessToken = getGoogleAccessToken(code);

            // 사용자 정보 가져오기
            Map<String, Object> userInfo = getGoogleUserInfo(accessToken);

            // 사용자 정보 파싱
            String socialId = userInfo.get("id").toString();
            String email = userInfo.containsKey("email") ? userInfo.get("email").toString() : socialId;
            String name = userInfo.containsKey("name") ? userInfo.get("name").toString() : "Unknown";

            // 기존 사용자 여부 확인 및 저장
            Optional<MemberEntity> existingMember = memberService.findByMemberIdAndSocialType(email, "GOOGLE");

            MemberEntity member;
            if (existingMember.isPresent()) {
                member = existingMember.get();
                logger.info("Existing GOOGLE member found: {}", member);
            } else {
                member = MemberEntity.builder()
                        .memberId(email)
                        .memberName(name)
                        .socialType("GOOGLE")
                        .build();
                member = memberService.save(member);
                logger.info("New GOOGLE member saved: {}", member);
            }

            // 세션에 사용자 정보 및 액세스 토큰 저장
            HttpSession session = request.getSession();
            session.setAttribute("member", member);
            session.setAttribute("GOOGLE_accessToken", accessToken); // Google 액세스 토큰 저장
            logger.info("User session set for GOOGLE member: {} with access token", member);

            return "redirect:/";
        } catch (Exception e) {
            logger.error("Error during GOOGLE login", e);
            model.addAttribute("error", "Google 로그인 중 오류가 발생했습니다.");
            return "error";
        }
    }

    // Google Access Token 요청
    private String getGoogleAccessToken(String code) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", googleClientId);
        params.add("client_secret", googleClientSecret);
        params.add("redirect_uri", googleRedirectUri);
        params.add("code", code);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

        ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                googleTokenUri,
                HttpMethod.POST,
                request,
                new ParameterizedTypeReference<Map<String, Object>>() {
                });

        Map<String, Object> responseBody = response.getBody();

        if (responseBody != null && responseBody.containsKey("access_token")) {
            return responseBody.get("access_token").toString();
        } else {
            throw new RuntimeException("Failed to retrieve Google access token");
        }
    }

    // Google 사용자 정보 요청
    private Map<String, Object> getGoogleUserInfo(String accessToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);

        HttpEntity<Void> request = new HttpEntity<>(headers);

        ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                googleUserInfoUri,
                HttpMethod.GET,
                request,
                new ParameterizedTypeReference<Map<String, Object>>() {
                });

        Map<String, Object> responseBody = response.getBody();

        if (responseBody != null) {
            return responseBody;
        } else {
            throw new RuntimeException("Failed to fetch Google user info");
        }
    }

    // Kakao 로그인 URL 생성 및 리다이렉트
    @GetMapping("/social/kakao/login")
    public String kakaoLogin() {
        String authorizationUri = "https://kauth.kakao.com/oauth/authorize?client_id=" + kakaoClientId +
                "&redirect_uri=" + kakaoRedirectUri + "&response_type=code" + "&scope=account_email profile_nickname";
        logger.info("Redirecting to Kakao authorization URI: {}", authorizationUri);
        return "redirect:" + authorizationUri;
    }

    // Kakao 콜백 처리
    @GetMapping("/social/kakao/callback")
    public String kakaoCallback(@RequestParam("code") String code, Model model, HttpServletRequest request) {
        return handleCallback("KAKAO", code, model, request);
    }

    // Naver 로그인 URL 생성 및 리다이렉트
    @GetMapping("/social/naver/login")
    public String naverLogin() {
        String authorizationUri = "https://nid.naver.com/oauth2.0/authorize?client_id=" + naverClientId +
                "&redirect_uri=" + naverRedirectUri + "&response_type=code";
        logger.info("Redirecting to Naver authorization URI: {}", authorizationUri);
        return "redirect:" + authorizationUri;
    }

    // Naver 콜백 처리
    @GetMapping("/social/naver/callback")
    public String naverCallback(@RequestParam("code") String code, Model model, HttpServletRequest request) {
        return handleCallback("NAVER", code, model, request);
    }

    // 공통 콜백 처리
    private String handleCallback(String socialType, String code, Model model, HttpServletRequest request) {
        try {
            // 1. Access Token 가져오기
            String accessToken = getAccessToken(socialType, code, Map.class);

            // 2. 사용자 정보 가져오기
            Map<String, Object> userInfo = getUserInfo(socialType, accessToken,
                    new ParameterizedTypeReference<Map<String, Object>>() {
                    });

            // 3. 사용자 정보 파싱
            String email = null;
            String memberName = "Unknown"; // 기본값 설정

            if (socialType.equalsIgnoreCase("KAKAO")) {
                Map<String, Object> kakaoAccount = getNestedMap(userInfo, "kakao_account");
                if (kakaoAccount != null) {
                    email = (String) kakaoAccount.get("email");
                    Map<String, Object> profile = getNestedMap(kakaoAccount, "profile");
                    if (profile != null) {
                        memberName = (String) profile.getOrDefault("nickname", "Unknown");
                    }
                }
            } else if (socialType.equalsIgnoreCase("NAVER")) {
                Map<String, Object> response = getNestedMap(userInfo, "response");
                if (response != null) {
                    email = (String) response.get("email");
                    memberName = (String) response.getOrDefault("name", "Unknown");
                }
            }

            if (email == null) {
                throw new RuntimeException("Failed to fetch email for " + socialType);
            }

            // 4. 기존 사용자 여부 확인 및 저장
            Optional<MemberEntity> existingMember = memberService.findByMemberIdAndSocialType(email, socialType);

            MemberEntity member;
            if (existingMember.isPresent()) {
                member = existingMember.get();
                logger.info("Existing {} member found: {}", socialType, member);
            } else {
                member = MemberEntity.builder()
                        .memberId(email) // 이메일을 memberId로 저장
                        .memberName(memberName) // 이름 저장
                        .socialType(socialType)
                        .build();
                member = memberService.save(member);
                logger.info("New {} member saved: {}", socialType, member);
            }

            // 5. 세션에 사용자 정보 및 액세스 토큰 저장
            HttpSession session = request.getSession();
            session.setAttribute("member", member);
            session.setAttribute(socialType + "_accessToken", accessToken); // 액세스 토큰 저장
            logger.info("User session set for {} member: {} with access token", socialType, member);

            // 6. 성공 시 리다이렉트
            return "redirect:/";
        } catch (Exception e) {
            logger.error("Error during {} login", socialType, e);
            model.addAttribute("error", socialType + " 로그인 중 오류가 발생했습니다.");
            return "error";
        }
    }

    private <T> String getAccessToken(String socialType, String code, Class<T> responseType) {
        String tokenUrl = null;
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        params.add("grant_type", "authorization_code");
        params.add("code", code);

        if (socialType.equalsIgnoreCase("KAKAO")) {
            tokenUrl = kakaoTokenUri;
            params.add("client_id", kakaoClientId);
            params.add("redirect_uri", kakaoRedirectUri);
            params.add("client_secret", kakaoClientSecret);
        } else if (socialType.equalsIgnoreCase("NAVER")) {
            tokenUrl = naverTokenUri;
            params.add("client_id", naverClientId);
            params.add("client_secret", naverClientSecret);
            params.add("redirect_uri", naverRedirectUri);
        }

        // tokenUrl이 null인지 확인
        if (tokenUrl == null) {
            throw new IllegalArgumentException("Invalid social type: " + socialType);
        }

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
        try {
            ResponseEntity<T> response = restTemplate.postForEntity(tokenUrl, request, responseType);
            T responseBody = response.getBody();
            if (responseBody instanceof Map) {
                Map<?, ?> responseMap = (Map<?, ?>) responseBody;
                if (responseMap.containsKey("access_token")) {
                    return (String) responseMap.get("access_token");
                }
            }
            throw new RuntimeException("Failed to fetch access token for " + socialType);
        } catch (Exception e) {
            throw new RuntimeException("Error fetching access token for " + socialType, e);
        }
    }

    private Map<String, Object> getUserInfo(String socialType, String accessToken,
            ParameterizedTypeReference<Map<String, Object>> responseType) {
        String userInfoUrl = null;

        if (socialType.equalsIgnoreCase("KAKAO")) {
            userInfoUrl = kakaoUserInfoUri;
        } else if (socialType.equalsIgnoreCase("NAVER")) {
            userInfoUrl = naverUserInfoUri;
        }

        // userInfoUrl이 null인지 확인
        if (userInfoUrl == null) {
            throw new IllegalArgumentException("Invalid social type: " + socialType);
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        HttpEntity<Void> request = new HttpEntity<>(headers);

        try {
            ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                    userInfoUrl, HttpMethod.GET, request, responseType);

            Map<String, Object> responseBody = response.getBody();
            if (responseBody != null) {
                logger.info("{} user info retrieved: {}", socialType, responseBody);
                return responseBody;
            } else {
                throw new RuntimeException("Failed to fetch user info from " + socialType);
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to fetch user info from " + socialType, e);
        }
    }

    // 안전하게 중첩된 Map 가져오기
    @SuppressWarnings("unchecked")
    private Map<String, Object> getNestedMap(Map<String, Object> map, String key) {
        Object value = map.get(key);
        if (value instanceof Map) {
            return (Map<String, Object>) value;
        }
        return null;
    }
}
