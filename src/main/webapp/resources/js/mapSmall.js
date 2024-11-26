// ---------------------------------------------------
// 지역별 추천 섹션 작은 지도 기능 스크립트 mapSmall.js
// ---------------------------------------------------
$(function () {
    const regions = [
        { name: "서울", data: "seoul", lat: 37.5665, lng: 126.9780 },
        { name: "인천", data: "incheon", lat: 37.4563, lng: 126.7052 },
        { name: "대전", data: "daejeon", lat: 36.3504, lng: 127.3845 },
        { name: "대구", data: "daegu", lat: 35.8722, lng: 128.6018 },
        { name: "광주", data: "gwangju", lat: 35.1595, lng: 126.8526 },
        { name: "부산", data: "busan", lat: 35.1796, lng: 129.0756 },
        { name: "울산", data: "ulsan", lat: 35.5384, lng: 129.3114 },
        { name: "경기", data: "gyeonggi", lat: 37.4138, lng: 127.5183 },
        { name: "강원", data: "gangwon", lat: 37.8228, lng: 128.1555 },
        { name: "충북", data: "chungbuk", lat: 36.6357, lng: 127.4917 },
        { name: "충남", data: "chungnam", lat: 36.5184, lng: 126.8000 },
        { name: "경북", data: "gyeongbuk", lat: 36.5760, lng: 128.5056 },
        { name: "경남", data: "gyeongnam", lat: 35.2377, lng: 128.6923 },
        { name: "전북", data: "jeonbuk", lat: 35.7175, lng: 127.1530 },
        { name: "전남", data: "jeonnam", lat: 34.8679, lng: 126.9910 },
        { name: "제주", data: "jeju", lat: 33.4996, lng: 126.5312 }
    ];
    
    const regionsPerPage = 8;
    const totalPages = Math.ceil(regions.length / regionsPerPage);
    const regionListWrapper = document.querySelector('.region-list-wrapper');
    let currentRegionPage = 1;
    let isDragging = false, startX;

    const mapContainer = document.getElementById('map-small');
    const mapOptions = { center: new kakao.maps.LatLng(37.5665, 126.9780), level: 9 };
    const map = new kakao.maps.Map(mapContainer, mapOptions);

    function isMobile() {
        return window.matchMedia("(max-width: 1024px)").matches;
    }

    function renderRegions() {
        regionListWrapper.innerHTML = '';
        if (isMobile()) {
            const regionListHTML = `
                <ul class="region-list">
                    ${regions
                        .map(
                            (region) =>
                                `<li class="com-border" data-region="${region.data}" data-lat="${region.lat}" data-lng="${region.lng}">
                                    <span class="region-title com-bg-primary-tr">${region.name}</span>
                                </li>`
                        )
                        .join("")}
                </ul>
            `;
            regionListWrapper.innerHTML = regionListHTML;
            $(".pagenation-dots").hide();
        } else {
            const regionListHTML = `
                <div class="region-slider">
                    ${Array.from({ length: totalPages }).map((_, i) => {
                        const start = i * regionsPerPage;
                        const end = start + regionsPerPage;
                        const pageRegions = regions.slice(start, end);
    
                        return `
                            <ul class="region-list page page-${i + 1}" style="left: ${i * 100}%;">
                                ${pageRegions
                                    .map(
                                        (region) =>
                                            `<li class="com-border" data-region="${region.data}" data-lat="${region.lat}" data-lng="${region.lng}">
                                                <span class="region-title com-bg-primary-tr">${region.name}</span>
                                            </li>`
                                    )
                                    .join("")}
                            </ul>
                        `;
                    }).join("")}
                </div>
            `;
            regionListWrapper.innerHTML = regionListHTML;
            $(".pagenation-dots").show();
        }
    }

    function goToPage(page) {
        currentRegionPage = page;
    
        const slider = document.querySelector('.region-slider');
        if (slider) {
            slider.style.transform = `translateX(-${(page - 1) * 100}%)`;
        }
    
        $(".pagenation-dots .dot").removeClass("active");
        $(`.pagenation-dots .dot[data-page="${page}"]`).addClass("active");
    }
    
    function updatePagination() {
        $(".pagenation-dots").html("");
        if (!isMobile()) {
            for (let i = 0; i < totalPages; i++) {
                $(".pagenation-dots").append(
                    `<span class="dot ${i === currentRegionPage - 1 ? "active" : ""}" data-page="${i + 1}"></span>`
                );
            }
        }
    }
    
    function handleResponsive() {
        renderRegions(currentRegionPage);
        updatePagination();
    }

    function init() {
        renderRegions(currentRegionPage);
        updatePagination();

        $(".pagenation-dots .dot").on("click", function () {
            goToPage($(this).data("page"));
        });

        $(".region-list-wrapper").on("mousedown touchstart", function (e) {
            startX = e.pageX || e.originalEvent.touches[0].pageX;
            isDragging = true;
        });

        $(document).on("mousemove touchmove", function (e) {
            if (isDragging) {
                const moveX = e.pageX || e.originalEvent.touches[0].pageX;
                const diffX = startX - moveX;

                if (Math.abs(diffX) > 50) {
                    isDragging = false;
                    if (diffX > 0 && currentRegionPage < Math.ceil(regions.length / regionsPerPage)) {
                        goToPage(currentRegionPage + 1);
                    } else if (diffX < 0 && currentRegionPage > 1) {
                        goToPage(currentRegionPage - 1);
                    }
                }
            }
        });

        $(document).on("mouseup touchend", function () {
            isDragging = false;
        });

        $(document).on("click", ".region-list li", function () {
            const lat = $(this).data("lat");
            const lng = $(this).data("lng");
            map.setCenter(new kakao.maps.LatLng(lat, lng));
        });

        $(window).resize(handleResponsive);
    }

    init();
})