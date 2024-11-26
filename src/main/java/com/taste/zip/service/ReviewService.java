package com.taste.zip.service;

import java.util.List;

import com.taste.zip.entity.ReviewEntity;

public interface ReviewService {
    ReviewEntity createReview(ReviewEntity review);
    ReviewEntity updateReview(Long reviewId, ReviewEntity review);
    void deleteReview(Long reviewId);
    ReviewEntity getReview(Long reviewId);
    List<ReviewEntity> getReviewsByPlace(int placeId);
    List<ReviewEntity> getReviewsByMember(int memIdx);
    List<ReviewEntity> getAllReviews();
}
