package com.taste.zip.service;

import java.util.List;

import javax.persistence.EntityNotFoundException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.taste.zip.entity.ReviewEntity;
import com.taste.zip.repository.ReviewRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Override
    @Transactional
    public ReviewEntity createReview(ReviewEntity review) {
        return reviewRepository.save(review);
    }

    @Override
    @Transactional
    public ReviewEntity updateReview(Long reviewId, ReviewEntity review) {
        ReviewEntity existingReview = reviewRepository.findById(reviewId)
            .orElseThrow(() -> new EntityNotFoundException("Review not found"));
        
        existingReview.setRating(review.getRating());
        existingReview.setContent(review.getContent());
        existingReview.setImageUrl(review.getImageUrl());
        
        return reviewRepository.save(existingReview);
    }

    @Override
    @Transactional
    public void deleteReview(Long reviewId) {
        ReviewEntity review = reviewRepository.findById(reviewId)
            .orElseThrow(() -> new EntityNotFoundException("Review not found"));
        review.setStatus(0);
        reviewRepository.save(review);
    }

    @Override
    public ReviewEntity getReview(Long reviewId) {
        return reviewRepository.findById(reviewId)
            .orElseThrow(() -> new EntityNotFoundException("Review not found"));
    }

    @Override
    public List<ReviewEntity> getReviewsByPlace(int placeId) {
        return reviewRepository.findByPlacePlaceId(placeId);
    }

    @Override
    public List<ReviewEntity> getReviewsByMember(int memIdx) {
        return reviewRepository.findByMemberMemIdx(memIdx);
    }

    @Override
    public List<ReviewEntity> getAllReviews() {
        return reviewRepository.findAll();
    }
}
