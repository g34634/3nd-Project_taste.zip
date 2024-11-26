<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Review Detail</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://kit.fontawesome.com/d7e414b2e7.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/hung1001/font-awesome-pro@4cac1a6/css/all.css" />


    <style>
        .review-detail-modal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 500px;
            max-height: 80vh;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow-y: auto;
            z-index: 1000;
        }

        .review-detail-header {
            position: relative;
            width: 100%;
            height: 350px;
        }

        .review-detail-header img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .close-button {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 30px;
            height: 30px;
            border: none;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.9);
            cursor: pointer;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .review-detail-content {
            padding: 20px;
        }

        .restaurant-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .restaurant-name {
            font-size: 24px;
            font-weight: bold;
            cursor: pointer;
        }

        .restaurant-name:hover {
            color: var(--zip-lightmode-primary);
        }

        .more-options {
            position: relative;
            cursor: pointer;
        }

        .more-options-btn {
            font-size: 20px;
            background: none;
            border: none;
            cursor: pointer;
        }

        .options-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border: 1px solid #eee;
            border-radius: 4px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            display: none;
        }

        .options-dropdown.show {
            display: block;
        }

        .option-item {
            padding: 10px 20px;
            cursor: pointer;
        }

        .option-item:hover {
            background: #f5f5f5;
        }

        .restaurant-info {
            color: #666;
            margin-bottom: 20px;
            line-height: 1.4;
        }

        .review-content-wrapper {
            display: flex;
            gap: 15px;
        }

        .review-profile-image {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            overflow: hidden;
        }

        .review-profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .review-main-content {
            flex: 1;
        }

        .reviewer-name {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .review-rating {
            color: #FFB800;
            margin-bottom: 10px;
        }

        .review-text {
            line-height: 1.6;
            margin-bottom: 15px;
        }

        .review-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #666;
        }

        .review-date {
            font-size: 14px;
        }

        .review-like {
            cursor: pointer;
        }

        .review-like i:hover {
            color: #ff4444;
        }

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }
    </style>
</head>
<body>
    <div class="modal-overlay"></div>
    <div class="review-detail-modal">
        <div class="review-detail-header">
            <img src="https://via.placeholder.com/500x350" alt="리뷰 이미지">
            <button class="close-button">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="review-detail-content">
            <div class="restaurant-header">
                <h2 class="restaurant-name">맛있는 식당</h2>
                <div class="more-options">
                    <button class="more-options-btn">
                        <i class="fas fa-ellipsis-v"></i>
                    </button>
                    <div class="options-dropdown">
                        <div class="option-item">수정하기</div>
                        <div class="option-item">삭제하기</div>
                    </div>
                </div>
            </div>
            <div class="restaurant-info">
                서울시 강남구 역삼동 123-45 • 한식 • 4.5점
            </div>
            <div class="review-content-wrapper">
                <div class="review-profile-image">
                    <img src="https://via.placeholder.com/50" alt="프로필">
                </div>
                <div class="review-main-content">
                    <div class="reviewer-name">맛집탐험가</div>
                    <div class="review-rating">
                        <i class="fas fa-star"></i> 4.5
                    </div>
                    <div class="review-text">
                        정말 맛있었어요! 특히 김치찌개가 일품이었습니다. 
                        친절한 서비스도 좋았고 분위기도 너무 좋았어요.
                        다음에 또 방문하고 싶은 맛집입니다.
                    </div>
                    <div class="review-meta">
                        <div class="review-date">2024.02.15</div>
                        <div class="review-like">
                            <i class="far fa-heart"></i> 12
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // 닫기 버튼
            $('.close-button').click(function() {
                 $('#reviewDetailModal').hide();
            });

            // 더보기 버튼
            $('.more-options-btn').click(function(e) {
                e.stopPropagation();
                $('.options-dropdown').toggleClass('show');
            });

            // 음식점 이름 클릭
            $('.restaurant-name').click(function() {
                window.location.href = '/map?from=review';
            });

            // 좋아요 버튼
            $('.review-like').click(function() {
                $(this).find('i').toggleClass('far fas');
            });

            // 외부 클릭 시 드롭다운 닫기
            $(document).click(function(e) {
                if (!$(e.target).closest('.more-options').length) {
                    $('.options-dropdown').removeClass('show');
                }
            });
        });
    </script>
</body>
</html>
