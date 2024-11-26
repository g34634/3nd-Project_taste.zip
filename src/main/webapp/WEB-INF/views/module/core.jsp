<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- css  -->
    <link rel="stylesheet" type="text/css" href="/resources/css/reset.css"> <!-- 기본 html 서식 초기화 스타일시트 -->
    <link rel="stylesheet" type="text/css" href="/resources/css/common.css"> <!-- 공통 사용 색상, 테마 스타일시트 -->
    <link rel="stylesheet" type="text/css" href="/resources/css/style.css"> <!-- 전체 스타일시트 -->
 
    <!-- js -->
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script> <!-- jquery -->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=ef64587d646853f13513117efca020e0"></script> <!-- 카카오맵 api -->
    
    <!-- 다크 모드 감지 -->
    <script> 
        if (localStorage.getItem("mode") === "dark") { document.documentElement.classList.add("dark-mode"); }
    </script>

    <!-- font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
    
    <!-- icon -->
    <script src="https://kit.fontawesome.com/d7e414b2e7.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/hung1001/font-awesome-pro@4cac1a6/css/all.css" />
    
    <!-- 타이틀 -->
    <title>우리들의 맛집 정보 모음집 - 맛.zip</title>
</head>