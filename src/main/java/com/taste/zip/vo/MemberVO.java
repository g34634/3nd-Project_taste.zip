package com.taste.zip.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class MemberVO {

	private int memIdx;// 회원번호(시퀀스를 이용)
	private String memberId;// 회원아이디(이메일을 이용)
	private String memberPw;// 비밀번호
	private String memberName;// 회원이름
	private String birthday;// 생일(YYYYMMDD형식의 8자리)
	private String phone;// 핸드폰번호(010다음의 -을 포함한 9자리)
	private Date regDate;// 가입일
	private Date modDate;// 수정일
	private String memStatus;// 회원상태(삭제요청여부:N(미요청), Y(요청))
	private int memGrade;// 회원등급(1:일반, 2:관리자, 3:슈퍼관리자(시스템운영자))

}
