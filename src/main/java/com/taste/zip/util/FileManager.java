package com.taste.zip.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
// import java.text.SimpleDateFormat;
// import java.util.ArrayList;
// import java.util.Date;
// import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
// import org.springframework.web.multipart.MultipartFile;

// import com.taste.zip.vo.BoardAttachedVO;
// import com.taste.zip.vo.BoardVO;

// import net.coobird.thumbnailator.Thumbnails;
// import net.coobird.thumbnailator.name.Rename;

@Component
public class FileManager {

    // public BoardVO handleFile(BoardVO vo, HttpServletRequest request) {
	// 	//서버로 업로드한 파일들 가져오기
	// 	MultipartFile[] uploadFiles = vo.getUploadFiles();
		
	// 	//업로드된 파일들을 실제 파일과 저장파일로 구분해서 저장하기 위한 List객체 생성
	// 	List<BoardAttachedVO> attachedList = new ArrayList<>();
		
	// 	for(int i=0; i<uploadFiles.length; i++) {
	// 		if(uploadFiles[i].getSize() != 0) { //파일이 업로드된 경우
				
	// 			//1. 저장 디렉터리에 저장할 새로운 파일명 만들기
	// 			String originFileName = uploadFiles[i].getOriginalFilename();//원본 파일명 가져오기
	// 			String ext = originFileName.substring(originFileName.lastIndexOf("."));//파일 확장자 추출
	// 			String now = new SimpleDateFormat("yyyyMMdd_HmsS").format(new Date());//저장 파일명 만들기
	// 			String saveFileName = now+ext; //저장 파일명
				
	// 			//2. 지정된 경로에 파일 저장하기
	// 			String saveDirectory = request.getServletContext().getRealPath("resources/uploads/");
	// 			String fullPath = saveDirectory+saveFileName;
				
	// 			try {
	// 				uploadFiles[i].transferTo(new File(fullPath)); //지정된 경로에 파일저장
	// 				//업로드된 파일을 지정된 경로에 저장 파일명으로 저장
	// 			} catch (Exception e) {
	// 				System.out.println("파일저장 중 예외발생: " + e);
	// 			}
				
				
	// 			//3. 파일 관련 값들을 BoardVO에 저장하기
	// 			BoardAttachedVO naVO = new BoardAttachedVO();
	// 			naVO.setOrigin_filename(originFileName);
	// 			naVO.setSave_filename(saveFileName);
	// 			attachedList.add(naVO);
				
	// 			//이미지 파일인 경우 섬네일을 만들어 저장소에 함께 저장함(jpg, png, gif 등)
	// 			/* 섬네일을 만들기 위한 API를 pom.xml 파일에 추가함: thumbnailator-0.4.20.jar
	// 			 	<!-- https://mvnrepository.com/artifact/net.coobird/thumbnailator -->
	// 				<dependency>
	// 				    <groupId>net.coobird</groupId>
	// 				    <artifactId>thumbnailator</artifactId>
	// 				    <version>0.4.20</version>
	// 				</dependency>

	// 			 */
	// 			// if(ext.equals(".png") || ext.equals(".jpg") || ext.equals("gif")) {
	// 			// 	String extFormat = ext.substring(1); //확장자명에서 점(.) 제거
	// 			// 	saveThumnail(fullPath, extFormat);
	// 			// }
	// 		}
	// 	}//end of for
	// 	vo.setAttachedList(attachedList);
	// 	return vo;
	// }

	//섬네일로 이미지 파일 저장하기
	// private void saveThumnail(String fullPath, String extFormat) {
	// 	try {
	// 		Thumbnails.of(new File(fullPath))
	// 		.size(120, 90) //섬네일 크기
	// 		.outputFormat(extFormat) //포맷 형식
	// 		.toFiles(Rename.PREFIX_HYPHEN_THUMBNAIL); //새로운 이름: thumbnail-이 파일명 앞에 붙음
	// 	} catch (Exception e) {
	// 		System.out.println("섬네일 저장 중 예외발생");
	// 	}
		
	// }

	//첨부파일 다운로드
	public void download(String origin_filename, String save_filename, HttpServletRequest request,
			HttpServletResponse response) {
		
		try {
			String saveDirectory = request.getServletContext().getRealPath("resources/uploads/");//저장경로
            System.out.println("FileManager.java: saveDirectory - " + saveDirectory);
			File file = new File(saveDirectory, save_filename);//파일 작업을 하기 위해 파일객체 생성
			InputStream in = new FileInputStream(file);//파일 작업을 하기 위한 파일입력 객체 생성
			
			//한글 파일명 깨짐 방지 처리
			String client = request.getHeader("User-Agent");//사용자가 사용하는 웹 브라우저
			if(client.indexOf("WOW64") == -1) {//인터넷 익스플로러인 경우
				//WOW64: Windows on Windows 64-bit 약어, 64비트 버전의 Window에서 32비트 응용프로그램을 실행할 수 있음
				origin_filename = new String(origin_filename.getBytes("UTF-8"), "ISO-8859-1");
				
			}else {//그 외의 웹브라우저인 경우
				origin_filename = new String(origin_filename.getBytes("KSC5601"), "ISO-8859-1");
			}
			
			//파일 다운로드를 위한 응답헤더 설정
			response.reset();
			response.setContentType("application/octet-stream"); //파일 다운로드를 위한 MIME 타입
			response.setHeader("Content-Disposition", "attachment; filename=\""+origin_filename+"\"");
			//위의 MIME 타입과 함께 설정되는 컨텐츠 처리 헤더 설정
			response.setHeader("Content-Length", ""+file.length());
			
			//response 객체로부터 새로운 출력 스트림 생성
			OutputStream out = response.getOutputStream();
			
			//출력 스트림에 파일내용 출력하기
			//파일 크기의 바이트 배열을 생성해서 버퍼로 사용
			byte[] buffer = new byte[(int)file.length()];
			int readBuffer = 0;
			while((readBuffer = in.read(buffer))>0) {
				out.write(buffer, 0, readBuffer);
			}
			
			//입출력 스트림 닫기
			in.close();
			out.close();
			
		} catch (Exception e) {
			System.out.println("다운로드 중 예외발생: " + e);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
		

	
	
}
