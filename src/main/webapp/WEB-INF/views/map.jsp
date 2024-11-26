<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="ko">

    <%@ include file="module/core.jsp" %>

         <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">

        <style>
        
        #map {
            width: 100%;
            height: 100%;
            background: #f5f5f5; /* 임시 배경색 */
            }

        .map-controls {
            position: absolute;
            top: 10px;
            right: 10px;
            display: flex;
            flex-direction: column;
            gap: 15px;
            z-index: 100;
        }

        .map-control-btn {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: white;
            border: none;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            transition: all 0.2s ease;
        }

        .map-control-btn:hover {
            background: var(--zip-lightmode-hover);
            transform: scale(1.05);
        }

        .map-control-btn i {
            color: var(--zip-black);
        }


        /* 식당목록,상세 통합컨테이너 */
        .restaurant-container {
            position: absolute;
            top: 0;
            left: 0;
            bottom: 0;
            display: flex;
            transition: transform 0.3s ease;
            width: fit-content;
            z-index: 1000;
        }

        .restaurant-container.collapsed {
            transform: translateX(-100%);
        }

        .restaurant-list-container {
            position: relative;
            width: 500px;
            background: white;
            border: 2px solid #eee;
            border-radius: 8px;
            z-index: 10;
            overflow: hidden;
            padding-right: 5px;
        }

        .search-container {
            padding: 10px 10px;
        }

        .search-wrapper {
            display: flex;
            align-items: center;
            background: #f5f5f5;
            border-radius: 15px;
            padding: 8px 15px;
        }

        .search-input {
            flex: 1;
            border: none;
            background: none;
            padding: 5px;
            font-size: 14px;
            outline: none;
        }

        .search-btn {
            background: none;
            border: none;
            cursor: pointer;
            padding: 5px;
            color: #666;
        }

        .search-btn:hover {
            color: var(--zip-lightmode-primary);
        }


        .filter-buttons {
            display: flex;
            gap: 10px;
            padding: 0 10px 10px 10px;
            
        }

        .filter-button {
            flex: 1;
            padding: 5px;
            border: 2px solid #eee;
            border-radius: 30px;
            background: white;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .filter-button:hover {
            background: var(--zip-black);
            color: white;
        }

        .filter-button.active {
            border-color: var(--zip-lightmode-primary);
            
        }


        .filter-options {
            position: absolute;
            top: 100px;
            left: 10px;
            right: 10px;
            background: white;
            border: 2px solid #eee;
            border-radius: 8px;
            padding: 10px;
            z-index: 100;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .options-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
        }

        .option-btn {
            padding: 10px;
            border: 2px solid #eee;
            border-radius: 4px;
            background: white;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .option-btn:hover {
            background: var(--zip-lightmode-primary);
            color: white;
        }

        .toggle-button {
            position: absolute;
            right: -30px;
            top: 50%;
            transform: translateY(-50%);
            width: 30px;
            height: 60px;
            background: white;
            border: none;
            border-left: none;
            border-radius: 0 8px 8px 0;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000; /* Add this line */
            box-shadow: 2px 0 4px rgba(0,0,0,0.1); 
        }

        .restaurant-list {
            height: calc(100% - 110px); /* filter-buttons 높이 제외 */
            overflow-y: auto;
            padding: 15px;
            box-sizing: border-box; /* padding이 height에 포함되도록 */
        }


        .collapsed {
            transform: translateX(-110%);
        }


        .restaurant-item {
            display: flex;
            padding: 15px;
            border-bottom: 1px solid #eee;
            gap: 15px;
            cursor: pointer;
        }

        .restaurant-thumb {
            width: 100px;
            height: 100px;
            flex-shrink: 0;
            overflow: hidden;
            border-radius: 4px;
            
        }

        .restaurant-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .restaurant-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .restaurant-name {
            font-weight: bold;
            font-size: 16px;
        }

        .restaurant-rating {
            color: #FFB800;
        }

        .restaurant-details {
            font-size: 14px;
            color: #666;
        }

        .bookmark-btn {
            flex-shrink: 0;
            width: 40px;
            height: 40px;
            border: none;
            background: none;
            cursor: pointer;
            font-size: 20px;
            color: var(--zip-black);
        }

        .bookmark-btn.active {
            color: #FFB800;
        }


        /* 식당상세 */
        .restaurant-detail-container {
            position: relative; 
            width: 500px;
            background: white;
            border: 2px solid #eee;
            border-radius: 8px;
            z-index: 9;
            margin-left: -503px; 
            transition: margin-left 0.3s ease; 
             overflow-y: auto;
             overflow-x: hidden;
             
             

        }   

    .restaurant-detail-container.show {
        margin-left: 0; 
    }

    .close-button {
        position: absolute;
        top: 15px;
        right: 15px;
        width: 30px;
        height: 30px;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        z-index: 11;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
    }

    .restaurant-detail-header {
        width: 100%;
        height: 350px;
    }

    .restaurant-detail-header img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .restaurant-detail-content {
        padding: 20px;
    }

    .restaurant-detail-name {
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 10px;
    }

    .restaurant-detail-rating {
        color: #FFB800;
        margin-bottom: 20px;
    }

    .restaurant-detail-buttons {
        display: flex;
        gap: 20px;
        margin-bottom: 30px;
    }

    .detail-button {
        flex: 1;
        padding: 10px;
        border: 2px solid #eee;
        border-radius: 4px;
        background: white;
        cursor: pointer;
    }


    /* 식당의 리뷰목록 */
    .restaurant-reviews {
        margin-top: 30px;
         width: 100%;
    }

    .review-item {
        padding: 20px;
        border-bottom: 1px solid #eee;
        display: flex;
        gap: 15px;
        width: calc(100% - 40px); /* 패딩값을 고려한 너비 계산 */
        box-sizing: border-box;
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

    .review-content {
        flex: 1;
        
    }

    .review-user-name {
        font-weight: bold;
        margin-bottom: 5px;
    }

    .review-rating {
        color: #FFB800;
        margin-bottom: 10px;
    }

    .review-photos {
        margin: 10px 0;
        display: flex;
        gap: 4px;
        flex-wrap: nowrap;
       
    }

    .review-photos img {
        max-height: 200px;
        max-width: calc(50% - 2px);
        object-fit: cover;
        border-radius: 4px;
       
    }

    .review-text {
        margin: 10px 0;
        line-height: 1.5;
    }

    .review-meta {
        text-align: right;
    }

    .review-date {
        color: #666;
        font-size: 14px;
    }

    .review-like {
        margin-top: 5px;
        color: var(--zip-black);
        cursor: pointer;
    }


    /* 리뷰작성창 */
    .review-modal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 1100;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .review-modal-content {
        width: 90%;
        max-width: 400px;
        background: white;
        border-radius: 8px;
        padding: 20px;
    }

    .review-modal-header {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
    }

    .back-btn {
        background: none;
        border: none;
        font-size: 20px;
        cursor: pointer;
        padding: 10px;
        margin-right: 10px;
    }

    .rating-container {
        margin-bottom: 20px;
        text-align: center;
    }

    .stars {
        font-size: 24px;
        color: #FFB800;
        margin-bottom: 10px;
    }

    .stars i {
        cursor: pointer;
        margin: 0 5px;
    }

    .rating-text {
        color: #666;
        font-size: 14px;
    }

    .review-text-input {
        width: 100%;
        height: 150px;
        padding: 15px;
        border: 1px solid #eee;
        border-radius: 8px;
        resize: none;
        margin-bottom: 20px;
        box-sizing: border-box;
    }

    .review-text-input:focus {
        outline: none;
        border: 2px solid var(--zip-lightmode-primary);
        
    }


    .photo-upload-container {
        margin-bottom: 20px;
    }

    .photo-upload-box {
        width: 100px;
        height: 100px;
        border: 2px dashed #ddd;
        border-radius: 8px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        color: #666;
    }

    .photo-upload-box i {
        font-size: 24px;
        margin-bottom: 5px;
    }

    .submit-review-btn {
        width: 100%;
        padding: 15px;
        background: var(--zip-lightmode-primary);
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: bold;
    }

    .submit-review-btn:hover {
        background: var(--zip-lightmode-secondary);
    }


        /* Add this media query section to your existing CSS */
        @media screen and (max-width: 1024px) {
            .restaurant-list-container {
                position: fixed;
                bottom: 60px;
                left: 0;
                width: 100%;
                height: 30vh; /* Initial height */
                transform: translateY(0); /* Start raised */
                transition: transform 0.3s ease, height 0.3s ease;
                border-radius: 20px 20px 0 0;
                z-index: 1000;
            }

            .restaurant-list-container.expanded {
                 height: calc(100vh - 182px);
                border-radius: 0;
            }

            .restaurant-list-container.collapsed {
                transform: translateY(calc(100% - 90px));
            }

            .restaurant-container > .toggle-button {
                display: none;
            }

            .toggle-button {
                position: absolute;
                top: 10px;
                left: 50%;
                transform: translateX(-50%);
                width: 50px;
                height: 5px;
                background: #ddd;
                border-radius: 10px;
                cursor: pointer;
            }

            .restaurant-detail-container {
                position: fixed;
                top: 122px; 
                right: -100%;
                bottom: 60px;
                width: 100%;
                height: calc(100vh - 182px);
                transition: right 0.3s ease;
                z-index: 1001;
            }

            .restaurant-detail-container.show {
                right: 0;
            }

            .restaurant-container {
                width: 100%;
            }

            .mobile-toggle-handle {
                width: 40px;
                height: 4px;
                background: #ddd;
                border-radius: 2px;
                margin: 10px auto;
                cursor: pointer;
            }

            .mobile-toggle-wrapper {
                width: 100%;
                height: 24px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .filter-options {
                position: absolute;
                top: 120px; /* 모바일에서의 검색바, 필터버튼, 핸들러 높이 고려 */
                left: 10px;
                right: 10px;
                z-index: 1001; /* 모바일에서 리스트 컨테이너보다 위에 표시되도록 z-index 조정 */
            }

        }



    </style>

    <body>

        <%@ include file="module/header.jsp" %>


        <main>
            <div id="map">
                <!-- 지도가 표시될 영역 -->
            </div>

                <!-- 지도 우측하단 버튼 -->
            <div class="map-controls">
                <button class="map-control-btn bookmark-control">
                    <i class="far fa-bookmark"></i>
                </button>
                <button class="map-control-btn location-control">
                    <i class="fas fa-location-arrow"></i>
                </button>
            </div>


            <div class="restaurant-container">
                    <!-- 음식점목록 -->
                <div class="restaurant-list-container">
                    <div class="mobile-toggle-wrapper">
                        <div class="mobile-toggle-handle"></div>
                    </div>
                    <div class="search-container">
                        <div class="search-wrapper">
                            <input type="text" class="search-input" placeholder="맛집 검색">
                            <button class="search-btn">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                    <div class="filter-buttons">
                        <button class="filter-button">카테고리</button>
                        <button class="filter-button">테마</button>
                        <button class="filter-button">거리순</button>
                    </div>
                    <div class="filter-options category-options hidden">
                        <div class="options-grid">
                            <button class="option-btn">한식</button>
                            <button class="option-btn">중식</button>
                            <button class="option-btn">일식</button>
                            <button class="option-btn">양식</button>
                            <button class="option-btn">카페</button>
                            <button class="option-btn">분식</button>
                        </div>
                    </div>

                    <div class="filter-options theme-options hidden">
                        <div class="options-grid">
                            <button class="option-btn">데이트</button>
                            <button class="option-btn">가족식사</button>
                            <button class="option-btn">회식</button>
                            <button class="option-btn">혼밥</button>
                            <button class="option-btn">미슐랭가이드</button>
                            <button class="option-btn">흑백요리사</button>
                        </div>
                    </div>
                    <div class="restaurant-list">
                        <!-- 음식점 목록이 들어갈 영역 -->
                    </div>
                </div>

                <%-- 음식점 상세, 리뷰목록 --%>
                <div class="restaurant-detail-container">
                        <button class="close-button">
                            <i class="fas fa-times"></i>
                        </button>
                    <div class="restaurant-detail-header">
                        <img src="https://via.placeholder.com/500x350" alt="식당 대표 이미지">
                    </div>
                    <div class="restaurant-detail-content">
                        <h2 class="restaurant-detail-name">맛있는 식당</h2>
                        <div class="restaurant-detail-rating">
                            <i class="fas fa-star"></i> 4.5 (리뷰 238)
                        </div>
                        <div class="restaurant-detail-buttons">
                            <button class="detail-button"><i class="far fa-bookmark"></i> 북마크</button>
                            <button class="detail-button"><i class="far fa-edit"></i> 리뷰작성</button>
                            <button class="detail-button"><i class="far fa-share-alt"></i> 공유</button>
                        </div>
                        <div class="restaurant-info">
                            <p>주소: 서울시 강남구 역삼동 123-45</p>
                            <p>전화: 02-123-4567</p>
                            <p>영업시간: 11:00 - 22:00</p>
                        </div>
                        <div class="restaurant-reviews">
                            <h3>리뷰</h3>
                            <div class="review-item">
                                <div class="review-profile-image">
                                    <img src="https://via.placeholder.com/50" alt="프로필">
                                </div>
                                <div class="review-content">
                                    <div class="review-user-name">맛집탐험가</div>
                                    <div class="review-rating"><i class="fas fa-star"></i> 4.5</div>
                                    <div class="review-photos">
                                        <img src="https://via.placeholder.com/150x150" alt="리뷰 사진">
                                        <img src="https://via.placeholder.com/150x150" alt="리뷰 사진">
                                    </div>
                                    <div class="review-text">정말 맛있었어요! 다음에 또 방문하고 싶습니다.</div>
                                </div>
                                <div class="review-meta">
                                    <div class="review-date">3일 전</div>
                                    <div class="review-like">
                                        <i class="far fa-heart"></i> 12
                                    </div>
                                </div>
                            </div>
                            <div class="review-item">
                                <div class="review-profile-image">
                                    <img src="https://via.placeholder.com/50" alt="프로필">
                                </div>
                                <div class="review-content">
                                    <div class="review-user-name">맛집탐험가2</div>
                                    <div class="review-rating"><i class="fas fa-star"></i> 4.5</div>
                                    <div class="review-photos">
                                        <img src="https://via.placeholder.com/150x150" alt="리뷰 사진">
                                    </div>
                                    <div class="review-text">정말 맛있었어요! 다음에 또 방문하고 싶습니다.</div>
                                </div>
                                <div class="review-meta">
                                    <div class="review-date">3일 전</div>
                                    <div class="review-like">
                                        <i class="far fa-heart"></i> 12
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                    <button class="toggle-button">
                        <i class="fas fa-chevron-left"></i>
                    </button>
            </div>

        <div class="review-modal hidden">
            <div class="review-modal-content">
                <div class="review-modal-header">
                    <button class="back-btn">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <h2 class="restaurant-name">맛있는 식당</h2>
                </div>
                <input type="hidden" id="currentUserMemIdx" value="${sessionScope.member.memIdx}">
                <div class="rating-container">
                    <div class="stars">
                        <i class="far fa-star" data-rating="1"></i>
                        <i class="far fa-star" data-rating="2"></i>
                        <i class="far fa-star" data-rating="3"></i>
                        <i class="far fa-star" data-rating="4"></i>
                        <i class="far fa-star" data-rating="5"></i>
                    </div>
                    <span class="rating-text">평가해주세요</span>
                </div>

                <textarea class="review-text-input" placeholder="맛있게 드셨나요? 식당의 분위기와 서비스도 궁금해요!"></textarea>

                <div class="photo-upload-container">
                    <div class="photo-upload-box">
                        <i class="fas fa-camera"></i>
                        <span>사진 추가</span>
                        <input type="file" multiple accept="image/*" class="photo-input hidden">
                    </div>
                    <div class="photo-preview-container"></div>
                </div>

                <button class="submit-review-btn">리뷰 등록하기</button>
            </div>
        </div>


        </main>
            <%@ include file="module/mobileNav.jsp" %>
    </body>
  
</html>
<script>
// Initial map setup
const container = document.getElementById('map');
const options = {
    center: new kakao.maps.LatLng(37.5665, 126.9780),
    level: 9
};
const map = new kakao.maps.Map(container, options);

let placesData = [];
let currentPlaceId;
let currentUserMemIdx;

function loadInitialPlaces() {
    $.ajax({
        url: '/places/api/getInitialPlaces',
        method: 'GET',
        dataType: 'json',
        success: function(response) {
            placesData = response;
            response.forEach(function(place) {
                var markerPosition = new kakao.maps.LatLng(place.mapy, place.mapx);
                var marker = new kakao.maps.Marker({
                    position: markerPosition,
                    map: map
                });

                var restaurantItem = $('<div>').addClass('restaurant-item').attr('data-id', place.placeId);
                var thumbDiv = $('<div>').addClass('restaurant-thumb');
                var infoDiv = $('<div>').addClass('restaurant-info');
                var bookmarkBtn = $('<button>').addClass('bookmark-btn');

                thumbDiv.append($('<img>').attr('src', place.firstimage || 'https://via.placeholder.com/100'));
                infoDiv.append($('<div>').addClass('restaurant-name').text(place.title));
                infoDiv.append($('<div>').addClass('restaurant-details')
                    .append($('<div>').text(place.cat3))
                    .append($('<div>').text(place.addr1))
                    .append($('<div>').text(place.opentimefood))
                );
                bookmarkBtn.append($('<i>').addClass('far fa-bookmark'));

                restaurantItem.append(thumbDiv).append(infoDiv).append(bookmarkBtn);
                $('.restaurant-list').append(restaurantItem);

                kakao.maps.event.addListener(marker, 'click', function() {
                    $('.restaurant-detail-container').addClass('show');
                    currentPlaceId = place.placeId;
                    updateDetailView(place);
                });
            });
        }
    });
}

function updateDetailView(place) {
    $('.restaurant-detail-name').text(place.title);
    $('.restaurant-detail-header img').attr('src', place.firstimage || 'https://via.placeholder.com/500x350');
    $('.restaurant-info p:nth-child(1)').text(place.addr1);
    $('.restaurant-info p:nth-child(2)').text(place.infocenterfood);
    $('.restaurant-info p:nth-child(3)').text(place.opentimefood);
    $('.restaurant-info p:nth-child(4)').text(place.restdatefood);
    $('.restaurant-info p:nth-child(5)').text(place.parkingfood);
    $('.restaurant-info p:nth-child(6)').text(place.treatmenu);
    $('.restaurant-info p:nth-child(7)').text(place.chkcreditcardfood);
    $('.restaurant-info p:nth-child(8)').text(place.packing);
    $('.restaurant-info p:nth-child(9)').text(place.overview);
    loadPlaceReviews(place.placeId);
}

function loadPlaceReviews(placeId) {
    $.ajax({
        url: '/api/reviews/place/' + placeId,
        method: 'GET',
        dataType: 'json',
        beforeSend: function() {
            $('.restaurant-reviews').html('<div>Loading reviews...</div>');
        },
        success: function(reviews) {
            displayReviews(reviews);
        },
        error: function(xhr, status, error) {
            console.log("Error loading reviews:", error);
            $('.restaurant-reviews').html('<div>Failed to load reviews</div>');

        }
    });
}

function formatDate(dateString) {
    const date = new Date(dateString);
    const now = new Date();
    const diff = Math.floor((now - date) / (1000 * 60 * 60 * 24));
    
    if (diff === 0) return '오늘';
    if (diff === 1) return '어제';
    if (diff < 7) return `${diff}일 전`;
    return `${date.getFullYear()}.${date.getMonth() + 1}.${date.getDate()}`;
}

$(document).ready(function() {
    loadInitialPlaces();

    $(document).on('click', '.bookmark-btn', function(e) {
        e.stopPropagation();
        $(this).find('i').toggleClass('far fas');
    });

    $(document).on('click', '.restaurant-item', function() {
        let placeId = $(this).data('id');
        let place = placesData.find(p => p.placeId === placeId);
        currentPlaceId = placeId;
        $('.restaurant-detail-container').addClass('show');
        updateDetailView(place);
    });

    $('.restaurant-detail-container .close-button').click(function() {
        $('.restaurant-detail-container').removeClass('show');
    });

    $('.toggle-button').click(function() {
        $('.restaurant-container').toggleClass('collapsed');
        $(this).find('i').toggleClass('fa-chevron-left fa-chevron-right');
    });

    $('.filter-button').eq(0).click(function() {
        if($('.category-options').hasClass('hidden')) {
            $('.theme-options').addClass('hidden');
            $('.category-options').removeClass('hidden');
            $('.filter-button').removeClass('active');
            $(this).addClass('active');
        } else {
            $('.category-options').addClass('hidden');
            $(this).removeClass('active');
        }
    });

    $('.filter-button').eq(1).click(function() {
        if($('.theme-options').hasClass('hidden')) {
            $('.category-options').addClass('hidden');
            $('.theme-options').removeClass('hidden');
            $('.filter-button').removeClass('active');
            $(this).addClass('active');
        } else {
            $('.theme-options').addClass('hidden');
            $(this).removeClass('active');
        }
    });

    $('.filter-button').eq(2).click(function() {
        let $btn = $(this);
        $btn.text($btn.text() === '거리순' ? '인기순' : '거리순');
    });

    $('.category-options .option-btn').click(function() {
        $('.filter-button').eq(0).text($(this).text());
        $('.category-options').addClass('hidden');
        $('.filter-button').eq(0).removeClass('active');
    });

    $('.theme-options .option-btn').click(function() {
        $('.filter-button').eq(1).text($(this).text());
        $('.theme-options').addClass('hidden');
        $('.filter-button').eq(1).removeClass('active');
    });

    // Review modal handlers
    $('.detail-button').on('click', function() {
        if($(this).find('i').hasClass('fa-edit')) {
            $('.review-modal').removeClass('hidden');
        }
    });

    $('.stars i').on('click', function() {
        const rating = $(this).data('rating');
        $('.stars i').each(function(index) {
            $(this).toggleClass('far fas', index < rating);
        });
        $('.rating-text').text(`${rating}점을 선택하셨습니다`);
    });

$('.submit-review-btn').on('click', function() {
    const reviewData = {
        rating: $('.stars .fas').length,
        content: $('.review-text-input').val(),
        place: {
            placeId: currentPlaceId
        },
        member: {
            memIdx: $('#currentUserMemIdx').val()
        },
        status: 1
    };

    $.ajax({
        url: '/api/reviews/create',  // Updated endpoint
        method: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify(reviewData),
        success: function(response) {
            $('.review-modal').addClass('hidden');
            $('.review-text-input').val('');
            $('.stars i').removeClass('fas').addClass('far');
            loadPlaceReviews(currentPlaceId);
        },
        error: function(xhr, status, error) {
            console.log('Review submission error:', error);
        }
    });
});


    // Mobile-specific handlers
    if (window.matchMedia("(max-width: 480px)").matches) {
        let startY = 0;
        let isDragging = false;

        $('.restaurant-list-container').on('touchstart', function(e) {
            startY = e.touches[0].clientY;
            isDragging = true;
            e.stopPropagation();
        });

        $('.restaurant-list-container').on('touchmove', function(e) {
            if (!isDragging) return;
            let currentY = e.touches[0].clientY;
            let diff = startY - currentY;

            e.stopPropagation();

            if (diff > 50) {
                $(this).addClass('expanded').removeClass('collapsed');
                map.setDraggable(false);
            } else if (diff < -50) {
                $(this).removeClass('expanded').addClass('collapsed');
                map.setDraggable(true);
            }
        });

        $('.restaurant-list-container').on('touchend', function() {
            isDragging = false;
        });

        $('.mobile-toggle-handle').click(function() {
            $('.restaurant-list-container').toggleClass('expanded collapsed');
            const isCollapsed = $('.restaurant-list-container').hasClass('collapsed');
            map.setDraggable(isCollapsed);
        });
    }
});
        // 모바일 뷰, 핸들 터치 혹은 슬라이드시 확장
        let startY = 0;
        let isDragging = false;

        $('.restaurant-list-container').on('touchstart', function(e) {
            startY = e.touches[0].clientY;
            isDragging = true;
        });

        $('.restaurant-list-container').on('touchmove', function(e) {
            if (!isDragging) return;

            let currentY = e.touches[0].clientY;
            let diff = startY - currentY;

            if (diff > 50) {
                $(this).addClass('expanded').removeClass('collapsed');
            } else if (diff < -50) { 
                $(this).removeClass('expanded').addClass('collapsed');
            }
        });

        $('.restaurant-list-container').on('touchend', function() {
            isDragging = false;
        });

        $('.toggle-button').click(function() {
            $('.restaurant-list-container').toggleClass('expanded collapsed');
        });

        $('.mobile-toggle-handle').click(function() {
            $('.restaurant-list-container').toggleClass('expanded collapsed');
        });

        //reviewdetail에서 map으로 이동시
        let hash = window.location.hash;

        const urlParams = new URLSearchParams(window.location.search);
        if(urlParams.get('from') === 'review') {
            $('.restaurant-detail-container').addClass('show');
        }

</script>

    