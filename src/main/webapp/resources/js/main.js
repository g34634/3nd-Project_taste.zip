
$(document).ready(function() {

    // 일반 리스트 섹션
    $(function() {
        // 1자형 리스트 스크롤 버튼
        $('.scroll-left').click(function() {
            doScroll($(this), 'left');
        });
    
        $('.scroll-right').click(function() {
            doScroll($(this), 'right');
        });
    
        function doScroll($button, direction) {
            const $wrapper = $button.closest('.card-list-wrapper');
            const $list = $wrapper.find('.card-list');
            const itemWidth = $list.find('li').outerWidth(true);
        
            const scrollAmount = direction === 'left' ? '-=' + (itemWidth * 3) : '+=' + (itemWidth * 3);
        
            $list.animate({ scrollLeft: scrollAmount }, 100, function() {
                updateButton($wrapper, $list);
            });
        }
    
        function updateButton($wrapper, $list) {
            const $scrollLeftBtn = $wrapper.find('.scroll-left');
            const $scrollRightBtn = $wrapper.find('.scroll-right');
            const scrollLeft = $list.scrollLeft();
            const maxScrollLeft = $list[0].scrollWidth - $list.outerWidth();
        
            $scrollLeftBtn.prop('disabled', scrollLeft <= 0);
            $scrollRightBtn.prop('disabled', scrollLeft >= maxScrollLeft);
        }
    
        $('.card-list').on('scroll', function() {
            const $list = $(this);
            const $wrapper = $list.closest('.card-list-wrapper');
            updateButton($wrapper, $list);
        });

        // 리뷰.zip 섹션 목록 샘플 출력
        for (let i = 0; i < 10; i++) {
            let listItem = 
                `<li class="com-border com-list-hover-animate">
                    <div class="list-thumb-img">
                        <img src="https://picsum.photos/245/195?random=${i}" alt="리뷰 섬네일 이미지">
                    </div>
                    <div class="list-content-wrapper">
                        <div class="review-top-wrapper rv-wrapper">
                            <strong class="rv-name">닉네임 ${i + 1}</strong>
                            <div class="rv-date">2021.09.11</div>
                        </div>
                        <div class="rv-title">리뷰 제목 ${i + 1}</div>
                        <div class="rv-desc">
                            Lorem ipsum dolor sit amet, consectetur adipisicing elit. Maxime et numquam debitis reprehenderit minus esse quaerat tempora odit enim consequatur quibusdam nesciunt, dolore aliquam itaque atque, laborum rem voluptatibus nulla?
                        </div>
                        <div class="review-bottom-wrapper rv-wrapper">
                            <div class="rv-like"><i class="far fa-heart"></i> 88</div>
                            <div class="rv-rate"><i class="far fa-thumbs-up"></i> 88</div>
                        </div>
                    </div>
                </li>`;

            $('#reviews .card-list').append(listItem);
        }

        // 오늘의 테마 추천 식당 섹션 목록 샘플 출력
        for (let i = 0; i < 6; i++) {
            let listItem = 
                `<li class="com-border com-list-hover-animate">
                    <div class="list-thumb-img">
                        <img src="https://picsum.photos/245/195?random=${i + 10}" alt="리뷰 섬네일 이미지">
                    </div>
                    <div class="list-content-wrapper">
                        <div class="review-top-wrapper rv-wrapper">
                            <strong class="rv-name">업종이름 ${i + 1}</strong>
                        </div>
                        <div class="rv-title">식당이름 ${i + 1}</div>
                        <div class="rv-desc">
                            Lorem ipsum dolor sit amet, consectetur adipisicing elit. Maxime et numquam debitis reprehenderit minus esse quaerat tempora odit enim consequatur quibusdam nesciunt, dolore aliquam itaque atque, laborum rem voluptatibus nulla?
                        </div>
                        <div class="review-bottom-wrapper rv-wrapper">
                            <div class="rv-rate"><i class="fas fa-star"></i> 5.0</div>
                            <div class="rv-like"><i class="far fa-heart"></i> 88</div>
                        </div>
                    </div>
                </li>`;
                        
            $('#today-theme .card-list').append(listItem);
        }
    })

    // 타이틀 시간별 아침,점심,저녁 및 랜덤 카테고리 출력
    const hour = new Date().getHours();
    const time = hour < 12 ? '아침' : hour < 18 ? '점심' : '저녁';
    const menuKeyword = ["한식", "중식", "양식", "일식", "카페·디저트"][Math.floor(Math.random() * 3)];
    $('#recommand-title').html(`<i class="fas fa-fish-cooked"></i>오늘 #${time}은 #${menuKeyword} 으로 결정!`);

    // 카테고리별 추천 섹션
    // 탭별 그리드 리스트 출력
    let currentPage = 1;
    let itemsPerPage = 10;
    let totalItems = 50;
    let totalPages = Math.ceil(totalItems / itemsPerPage);
    
    let tabCount = 7;
    let tabHeader = $('#category .category-tab-header');
    let tabContent = $('#category .category-tab-contents');
    
    for (let i = 1; i <= tabCount; i++) {
        let tabItem = `<div class="cate-tab-item" data-tab="tab${i}">탭 ${i}</div>`;
        tabHeader.append(tabItem);
        let contentItem = 
            `<div class="cate-tab-content" id="tab${i}" style="display:none;">
                <ul class="cate-card-list"></ul>
            </div>`;
        tabContent.append(contentItem);
    }

    // 첫번째 탭 기본으로 활성화 및 내용 로드
    $('.cate-tab-item').first().addClass('active');
    $('.cate-tab-content').first().show();
    loadTab('tab1', currentPage);

    // 탭을 클릭하면 클릭한 탭에 해당하는 페이지 로드
    $('.cate-tab-item').click(function() {
        $('.cate-tab-item').removeClass('active');
        $('.cate-tab-content').hide();
        $(this).addClass('active');
        let targetTab = $(this).data('tab');
        $('#' + targetTab).show();
        currentPage = 1;
        loadTab(targetTab, currentPage);
        updatePagenation();
    });

    // 다음 페이지 이전 페이지 버튼
    $('#prev-btn').click(function() {
        if (currentPage > 1) {
            currentPage--;
            loadTab(pickTab(), currentPage);
            updatePagenation();
        }
    });

    $('#next-btn').click(function() {
        if (currentPage < totalPages) {
            currentPage++;
            loadTab(pickTab(), currentPage);
            updatePagenation();
        }
    });

    // 다음, 이전 페이지 버튼 활성화, 비활성화 상태 업데이트
    function updatePagenation() {
        $('#prev-btn').prop('disabled', currentPage === 1);
        $('#next-btn').prop('disabled', currentPage === totalPages);
    }

    // 현재 켜져있는 탭을 반환하는 함수
    function pickTab() {
        return $('.cate-tab-item.active').data('tab');
    }

    // 탭의 내용들을 불러오는 함수
    // 현재 임시로 가상의 리스트를 만들어 출력하도록 함
    function loadTab(tabId, page) {
        let listContainer = $('#' + tabId + ' .cate-card-list');
        listContainer.empty();
    
        let startIndex = (page - 1) * itemsPerPage;
        let endIndex = startIndex + itemsPerPage;
    
        for (let i = startIndex; i < endIndex && i < totalItems; i++) {
            let listItem = 
                `<li class="com-border com-list-hover-animate">
                    <div class="list-thumb-img">
                        <img src="https://picsum.photos/245/195?random=${i + 100}-${tabId.replace('tab', '')}" alt="리뷰 섬네일 이미지">
                    </div>
                    <div class="list-content-wrapper">
                        <div class="review-top-wrapper rv-wrapper">
                            <strong class="rv-name">업종이름 ${i + 1}</strong>
                        </div>
                        <div class="rv-title">식당이름 ${i + 1}</div>
                        <div class="rv-desc">
                            Lorem ipsum dolor sit amet, consectetur adipisicing elit. Maxime et numquam debitis reprehenderit minus esse quaerat tempora odit enim consequatur quibusdam nesciunt, dolore aliquam itaque atque, laborum rem voluptatibus nulla?
                        </div>
                        <div class="review-bottom-wrapper rv-wrapper">
                            <div class="rv-rate"><i class="fas fa-star"></i> 5.0</div>
                            <div class="rv-like"><i class="far fa-heart"></i> 88</div>
                        </div>
                    </div>
                </li>`;
                        
            listContainer.append(listItem);
        }
    }

    // 가로 스크롤 동작 함수 (.horizontal-scroll 있으면 작동)
    $('.horizontal-scroll').each(function () {
        const scrollContainer = $(this);
      
        scrollContainer.on('wheel', function (event) {
          event.preventDefault();
      
          const delta = event.originalEvent.deltaY;
          const scrollAmount = 100;
      
          $(this).stop().animate({
            scrollLeft: this.scrollLeft + delta * scrollAmount
          }, 300);
        });
    });

});