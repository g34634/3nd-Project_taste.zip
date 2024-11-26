package com.taste.zip.controller;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Calendar;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
public class HomeController {

	// 게시판과 관련해서 요청을 처리할 수 있는 객체 정의
	// private BoardService boardServiceImpl; // 일반 게시판
	// private NoticeService noticeServiceImpl; // 공지사항 게시판
	// private PagingManager pagingManager;
	// private PagingVO pagingVO;

	// 기타 요청URL에 대한 처리 메소드

	// 메인 페이지 요청
	@GetMapping("/")
	public ModelAndView home(ModelAndView mav) {
		mav.setViewName("index");
		return mav;
	}

	@GetMapping("/map")
    public ModelAndView map(ModelAndView mav) {
        mav.setViewName("map");
        return mav;
    }

	// 마이 페이지 요청
	@GetMapping("/myzip")
	public ModelAndView mypage(ModelAndView mav) {
		mav.setViewName("myzip");
		return mav;
	}

	@GetMapping("/filteredReviews")
	public ModelAndView filteredReviews(ModelAndView mav) {
		mav.setViewName("filteredReviews");
		return mav;
	}

  // 에러 페이지 요청
	@GetMapping("/logout/complete")
	public String logoutComplete() {
		// 홈 페이지로 리다이렉트
		return "redirect:/";
	}

	// 에러 페이지 요청
	@GetMapping("/error/error500.do")
	public String error500(Exception e, HttpServletRequest request, Model model) {

		// 예외 정보 구성
		model.addAttribute("time", Calendar.getInstance().getTime());// 예외 발생 시간
		model.addAttribute("url", request.getServletPath());// 예외 발생 URL
		model.addAttribute("message", e.getMessage());// 예외 메시지
		// 예외 상세내용
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);
		e.printStackTrace(pw); // 스택 트레이스를 PrintWriter로 출력
		String stackTrace = sw.toString(); // 문자열로 변환
		model.addAttribute("stackTrace", stackTrace);

		return "error/error";
	}

}
