<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="module/core.jsp" %>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons CDN 추가 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
          <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    


    <style>

        html, body {
            min-width: 0;
        }

        .profile-circle {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            margin-bottom: 20px;
        }
        .profile-circle img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .category-btn {
            margin: 10px;
            padding: 10px 20px;
            border: none;
            background-color: #f8f9fa;
            border-radius: 20px;
            cursor: pointer;
        }
        .category-btn.active {
            background-color: #0d6efd;
            color: white;
        }
        .item-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .item-card {
            border-radius: 10px;
            overflow: hidden;
        }
        .item-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }





        .profile-edit-modal {
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

        .profile-edit-content {
            width: 90%;
            max-width: 400px;
            background: white;
            border-radius: 8px;
            padding: 20px;
        }

        .profile-edit-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }

        .back-btn {
            font-size: 20px;
            cursor: pointer;
            padding: 10px;
            margin-right: 10px;
            color: #ddd;
        }

        .profile-image-container {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
        }

        .profile-image-circle {
            position: relative;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            overflow: hidden;
            cursor: pointer;
        }

        .profile-image-circle img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .image-upload-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(0,0,0,0.7);
            padding: 10px;
            text-align: center;
            color: white;
            transition: all 0.3s ease;
        }
        .image-upload-overlay i {
            font-size: 24px; /* 기존 코드에 추가 */
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-group input:disabled {
            background: #f5f5f5;
            cursor: not-allowed;
        }

        .form-group textarea {
            height: 100px;
            resize: none;
        }

        .save-profile-btn {
            width: 100%;
            padding: 15px;
            background: #ddd;
            color: black;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
        }

        .save-profile-btn:hover {
            background: #ddd;
        }

        .hidden {
            display: none !important;
        }
    </style>

    <%@ include file="module/header.jsp" %>

<body>
    <div class="container mt-5">
        <!-- Title Box -->
        <div class="p-4 mb-4 bg-light rounded">
            <h1 class="text-center">MY ZIP</h1>
        </div>

        <!-- Profile Box -->
        <div class="p-4 mb-4 bg-light rounded">
            <div class="row">
                <div class="col-md-4 text-center">
                    <div class="profile-circle mx-auto">
                        <img src="https://via.placeholder.com/150" alt="Profile Picture">
                    </div>
                    <button class="btn btn-outline-primary w-75 mb-2">편집</button>
                    <button class="btn btn-outline-danger w-75" onclick="location.href='member/logout.do'">로그아웃</button>
                </div>
                <div class="col-md-8">
                    <h2 class="mb-3">${member.memberName}</h2>
                    <p class="text-muted">안녕하세요! 전국 맛집 탐방이 취미인 미식가입니다.</p>
                </div>
            </div>
        </div>


        <!-- Category and Items Box -->
        <div class="p-4 bg-light rounded">
            <div class="text-center mb-4">
                <button class="category-btn active">관심</button>
                <button class="category-btn">리뷰</button>
                <button class="category-btn">나의식당</button>
            </div>

            <div class="item-grid">
                <!-- Sample restaurant items -->
                <div class="item-card">
                    <img src="https://via.placeholder.com/300/FF5733/ffffff?text=맛있는식당1" alt="Restaurant 1">
                    <div class="p-2">
                        <h5>서울식당</h5>
                        <p class="small text-muted">서울시 강남구</p>
                    </div>
                </div>
                <div class="item-card">
                    <img src="https://via.placeholder.com/300/33FF57/ffffff?text=맛있는식당2" alt="Restaurant 2">
                    <div class="p-2">
                        <h5>부산횟집</h5>
                        <p class="small text-muted">부산시 해운대구</p>
                    </div>
                </div>
                <div class="item-card">
                    <img src="https://via.placeholder.com/300/3357FF/ffffff?text=맛있는식당3" alt="Restaurant 3">
                    <div class="p-2">
                        <h5>제주흑돼지</h5>
                        <p class="small text-muted">제주시 노형동</p>
                    </div>
                </div>
                <div class="item-card">
                    <img src="https://via.placeholder.com/300/FF33F6/ffffff?text=맛있는식당4" alt="Restaurant 4">
                    <div class="p-2">
                        <h5>인천중화요리</h5>
                        <p class="small text-muted">인천시 중구</p>
                    </div>
                </div>
                <div class="item-card">
                    <img src="https://via.placeholder.com/300/33FFF6/ffffff?text=맛있는식당5" alt="Restaurant 5">
                    <div class="p-2">
                        <h5>대구찜갈비</h5>
                        <p class="small text-muted">대구시 중구</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- 프로필편집모달 --%>
    <div class="profile-edit-modal hidden">
        <div class="profile-edit-content">
            <div class="profile-edit-header">
                <button class="back-btn">
                    <i class="fas fa-chevron-left"></i>
                </button>
                <h2>프로필 편집</h2>
            </div>
            
            <form method="post" action="member/updateProcess.do">
                <input type="hidden" name="memIdx" value="${member.memIdx}">
                <input type="hidden" name="memberPw" value="${member.memberPw}">
                        
                <div class="profile-image-container">
                    <div class="profile-image-circle">
                        <img src="https://via.placeholder.com/150" alt="Profile Picture">
                        <div class="image-upload-overlay">
                            <i class="fas fa-camera"></i>
                            <input type="file" accept="image/*" class="profile-image-input hidden">
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label>아이디</label>
                    <input type="text" name="memberId" value="${member.memberId}" readonly>
                </div>

                <div class="form-group">
                    <label>이름</label>
                    <input type="text" name="memberName" value="${member.memberName}">
                </div>

                <div class="form-group">
                    <label>전화번호</label>
                    <input type="text" name="phone" value="${member.phone}">
                </div>

                <div class="form-group">
                    <label>생년월일</label>
                    <input type="text" name="birthday" value="${member.birthday}">
                </div>

                <div class="form-group text-center mb-3">
                    <a href="#" id="changePasswordBtn" style="color: #666; margin-right: 20px; text-decoration: none;">비밀번호 변경</a>
                    <a href="javascript:cancel()" style="color: #666; text-decoration: none;">회원 탈퇴</a>
                </div>

                <button type="submit" class="save-profile-btn">저장하기</button>
            </form>
        </div>
    </div>

    <div class="password-change-modal hidden" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 1200; display: flex; justify-content: center; align-items: center;">
        <div class="profile-edit-content">
            <div class="profile-edit-header">
                <button class="back-btn-pw">
                    <i class="fas fa-chevron-left"></i>
                </button>
                <h2>비밀번호 변경</h2>
            </div>
            
            <form id="passwordChangeForm" method="post" action="member/updatePassword.do">
                <input type="hidden" name="memIdx" value="${member.memIdx}">
                <input type="hidden" name="memberId" value="${member.memberId}">
                
                <div class="form-group">
                    <input type="password" name="currentPassword" placeholder="현재 비밀번호" required>
                </div>
                <div class="form-group">
                    <input type="password" name="memberPw" id="memberPw" placeholder="새 비밀번호" required>
                </div>
                <div class="form-group">
                    <input type="password" name="confirmPassword" placeholder="새 비밀번호 확인" required>
                </div>
                <button type="submit" class="save-profile-btn">변경하기</button>
            </form>


        </div>
    </div>




      <script>



          // Category button click handling
          document.querySelectorAll('.category-btn').forEach(button => {
              button.addEventListener('click', () => {
                  document.querySelectorAll('.category-btn').forEach(btn => btn.classList.remove('active'));
                  button.classList.add('active');
                  // Add logic to load different content based on category
              });
          });

            // Add to existing script section in myzip.jsp
            $(document).ready(function() {
                // Load reviewDetail.jsp content when item-card is clicked
                $(document).on('click', '.item-card', function() {

                    // $.get('/reviewDetail', function(data) {
                        // $('body').append(data);
                         $('#reviewDetailModal').show();
                    // });
                    
                });


            // Show profile edit modal
            $('.btn-outline-primary').click(function() {
                $('.profile-edit-modal').removeClass('hidden');
            });

            // Hide profile edit modal
            $('.back-btn').click(function() {
                $('.profile-edit-modal').addClass('hidden');
            });

            // Profile image upload
            $('.profile-image-circle').click(function() {
                $('.profile-image-input').click();
            });

            $('.profile-image-input').change(function(e) {
                if (e.target.files && e.target.files[0]) {
                    let reader = new FileReader();
                    reader.onload = function(e) {
                        $('.profile-image-circle img').attr('src', e.target.result);
                    }
                    reader.readAsDataURL(e.target.files[0]);
                }
            });


    // 프로필 편집 폼 제출 처리
    $('.profile-edit-content form').submit(function(e) {
        e.preventDefault();
        
        if(this.action.includes('updateProcess.do')) {
            this.submit();
            alert('프로필이 성공적으로 수정되었습니다.');
        } else if(this.action.includes('updatePassword.do')) {
            const newPw = $('#memberPw').val();
            const confirmPw = $('input[name="confirmPassword"]').val();
            
            if(newPw === confirmPw) {
                this.submit();
                alert('비밀번호가 성공적으로 변경되었습니다.');
            } else {
                alert('새 비밀번호가 일치하지 않습니다.');
            }
        }
    });


    // Password change modal handling
    $('#changePasswordBtn').click(function() {
        $('.password-change-modal').removeClass('hidden');
    });

    $('.back-btn-pw').click(function() {
        $('.password-change-modal').addClass('hidden');
    });





            });

function cancel() {
    const answer = confirm("정말 회원탈퇴 하시겠습니까?");
    if(answer) {
        location.href = "member/cancelProcess.do";
    }
}
        
      </script>
    

    
    <!-- 모바일 탭바 include -->
    <%@ include file="module/mobileNav.jsp" %>

    <div id="reviewDetailModal" style="display: none;">
        <%@ include file="/WEB-INF/views/reviewDetail.jsp" %>
    </div>

        <!-- Previous review detail modal content here -->
    </div>
</body>
</html>
