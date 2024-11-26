// ------------------------------------
//              헤더 좌측
// ------------------------------------

// (임시) 실시간/일주일간 좋아요 순위 목록
const restaurants = [
    "(천안) 달래 식당 ",
    "(대전) 고기 굽는 마을",
    "(광주) 불낙지 탕탕이 전문",
    "(아산) 우리한우 정육식당",
    "(서울) 서울 오리 전문점",
    "EE 식당 이달의 메뉴!",
    "FF 식당 최고 맛집!",
    "GG 식당 신메뉴 출시!",
    "HH 식당 강추!",
    "II 식당 가성비 갑!"
];

// 현재 순서 변수 초기화
let currentIndex = 0;

// 첫번째 순서 표시
$("#restaurant-rotation").html(`<strong class="popular-rank">${currentIndex + 1}</strong>${restaurants[currentIndex]}`);
$("#mob-restaurant-rotation").html(`<strong class="popular-rank">${currentIndex + 1}</strong>${restaurants[currentIndex]}`);

// 5초마다 다음 순서 회전하면서 표시
setInterval(function() {
    $("#restaurant-rotation").addClass("slide-out").one("animationend", function() {
        $(this)
            .removeClass("slide-out")
            .html(`<strong class="popular-rank">${currentIndex + 1}</strong>${restaurants[currentIndex]}`)
            .addClass("slide-in")
            .one("animationend", function() {
                $(this).removeClass("slide-in");
            });
        currentIndex = (currentIndex + 1) % restaurants.length;
    });
}, 5000);

setInterval(function() {
    $("#mob-restaurant-rotation").addClass("slide-out").one("animationend", function() {
        $(this)
            .removeClass("slide-out")
            .html(`<strong class="popular-rank">${currentIndex + 1}</strong>${restaurants[currentIndex]}`)
            .addClass("slide-in")
            .one("animationend", function() {
                $(this).removeClass("slide-in");
            });
        currentIndex = (currentIndex + 1) % restaurants.length;
    });
}, 5000);

// 순위 표시하는 부분에 마우스 올릴 시 전체 목록 보여주기
$('.popular-restaurant-list').on('mouseenter', function() {
    const $popup = $('.popular-restaurant-popup');
    const $list = $('#restaurant-full-list');

    $list.empty();
    restaurants.forEach((restaurant, index) => {
        $list.append(`<li class="com-border-bottom-thin"><strong class="popular-rank">${index + 1}</strong><a href="#">${restaurant}</a></li>`);
    });
    $popup.addClass('open');
});

// 마우스 위치에 따라 보이고 사라지게 하기
$('.popular-restaurant-list').on('mouseleave', function() { $popup.removeClass('open'); });
$('.popular-restaurant-popup').on('mouseenter', function() { $(this).addClass('open'); }).on('mouseleave', function() { $(this).removeClass('open'); });

// 모바일일때 위치 변경
function updateMobileRankingUI() {
    if (isMobile()) {
        $('#mob-popular-container').show();
        $('#popular-container').hide();
    } else {
        $('#mob-popular-container').hide();
        $('#popular-container').show();
    }
}

// 모바일 확인 함수
function isMobile() {
    return window.matchMedia("(max-width: 1024px)").matches;
}

$(window).resize(updateMobileRankingUI);
updateMobileRankingUI();
