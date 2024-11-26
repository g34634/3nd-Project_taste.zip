package com.taste.zip.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.taste.zip.entity.MemberEntity;
import com.taste.zip.service.MemberService;
import com.taste.zip.vo.MemberVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	private final MemberService memberServiceImpl;
	private final RestTemplate restTemplate;

	@Value("${naver.client-id}")
	private String naverClientId;

	@Value("${naver.client-secret}")
	private String naverClientSecret;

	@Value("${kakao.client-id}")
	private String kakaoClientId;

	@Value("${kakao.logout-redirect-uri}")
	private String kakaoLogoutRedirectUri;

	@PostMapping("/joinProcess.do")
	@ResponseBody
	public Map<String, Object> joinProcess(MemberVO vo) {
		Map<String, Object> response = new HashMap<>();

		// 회원 정보 생성
		MemberEntity entity = MemberEntity.builder()
				.memberId(vo.getMemberId())
				.memberPw(vo.getMemberPw())
				.memberName(vo.getMemberName())
				.birthday(vo.getBirthday())
				.phone(vo.getPhone())
				.socialType("LOCAL") // 이메일 계정 명시
				.build();

		try {
			MemberEntity savedEntity = memberServiceImpl.save(entity);
			if (savedEntity != null) {
				response.put("success", true);
			} else {
				response.put("success", false);
				response.put("msg", "회원가입이 실패했습니다.");
			}
		} catch (Exception e) {
			response.put("success", false);
			response.put("msg", "서버 오류가 발생했습니다.");
			System.out.println("회원가입 프로세스 오류 발생: " + e);
		}

		return response;
	}

	@PostMapping("/loginProcess.do")
	@ResponseBody
	public Map<String, Object> loginProcess(String memberId, String memberPw, HttpServletRequest request) {
		Map<String, Object> response = new HashMap<>();

		if (memberId == null || memberPw == null) {
			response.put("success", false);
			response.put("msg", "아이디나 비밀번호가 입력되지 않았습니다.");
			return response;
		}

		MemberEntity member = memberServiceImpl.login(memberId, memberPw, "LOCAL");

		if (member != null) {
			HttpSession session = request.getSession();
			session.setAttribute("member", member);
			response.put("success", true);
		} else {
			response.put("success", false);
			response.put("msg", "아이디나 비밀번호가 일치하지 않습니다.");
		}
		return response;
	}

	@GetMapping("/update.do")
	public ModelAndView update(ModelAndView mav) {
		mav.setViewName("member/update");
		return mav;
	}

	@PostMapping("/updateProcess.do")
	public ModelAndView updateProcess(MemberVO vo, HttpServletRequest request, ModelAndView mav) {

		MemberEntity entity = MemberEntity.builder()
				.memberId(vo.getMemberId())
				.memberPw(vo.getMemberPw())
				.memberName(vo.getMemberName())
				.birthday(vo.getBirthday())
				.phone(vo.getPhone())
				.build();

		entity.updateMemIdx(vo.getMemIdx());
		String viewName = "member/update";
		int result = memberServiceImpl.updateMember(entity);

		if (result == 1) {
			HttpSession session = request.getSession();
			session.removeAttribute("member");

			memberServiceImpl.getMember(entity.getMemIdx()).ifPresent(member -> {
				session.setAttribute("member", member);
			});

			viewName = "redirect:/";
		} else {
			mav.addObject("msg", "회원정보 변경시 오류가 발생했습니다. 변경내용을 확인해 주세요");
		}
		mav.setViewName(viewName);

		return mav;
	}

	@GetMapping("/logout.do")
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String kakaoAccessToken = (String) session.getAttribute("KAKAO_accessToken");
		String googleAccessToken = (String) session.getAttribute("GOOGLE_accessToken");
		String naverAccessToken = (String) session.getAttribute("NAVER_accessToken");

		session.invalidate();

		if (kakaoAccessToken != null) {
			String kakaoLogoutUrl = "https://kauth.kakao.com/oauth/logout"
					+ "?client_id=" + kakaoClientId
					+ "&logout_redirect_uri=" + kakaoLogoutRedirectUri;
			return "redirect:" + kakaoLogoutUrl;
		}

		if (googleAccessToken != null) {
			revokeGoogleToken(googleAccessToken);
		}

		if (naverAccessToken != null) {
			deleteNaverToken(naverAccessToken);
		}

		return "redirect:/logout/complete";
	}

	private void revokeGoogleToken(String accessToken) {
		String googleRevokeUrl = "https://oauth2.googleapis.com/revoke?token=" + accessToken;
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<Void> request = new HttpEntity<>(headers);

		try {
			restTemplate.exchange(googleRevokeUrl, HttpMethod.POST, request, String.class);
			logger.info("Google access token revoked successfully.");
		} catch (Exception e) {
			logger.error("Failed to revoke Google access token.", e);
		}
	}

	private void deleteNaverToken(String accessToken) {
		String naverDeleteUrl = "https://nid.naver.com/oauth2.0/token"
				+ "?grant_type=delete"
				+ "&client_id=" + naverClientId
				+ "&client_secret=" + naverClientSecret
				+ "&access_token=" + accessToken
				+ "&service_provider=NAVER";

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<Void> request = new HttpEntity<>(headers);

		try {
			restTemplate.exchange(naverDeleteUrl, HttpMethod.GET, request, String.class);
			logger.info("Naver access token deleted successfully.");
		} catch (Exception e) {
			logger.error("Failed to delete Naver access token.", e);
		}
	}
}
