package com.taste.zip.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.taste.zip.entity.ReviewEntity;
import com.taste.zip.service.ReviewService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
public class ReviewController {

    @Autowired
    private ReviewService reviewService;


    @PostMapping("/create")  
    public ResponseEntity<ReviewEntity> createReview(@RequestBody ReviewEntity review) {
        ReviewEntity savedReview = reviewService.createReview(review);
        return ResponseEntity.ok(savedReview);
    }

    @GetMapping("/{reviewId}")
    public ResponseEntity<ReviewEntity> getReview(@PathVariable Long reviewId) {
        return ResponseEntity.ok(reviewService.getReview(reviewId));
    }

    @GetMapping("/place/{placeId}")
    public ResponseEntity<List<ReviewEntity>> getPlaceReviews(@PathVariable int placeId) {
        return ResponseEntity.ok(reviewService.getReviewsByPlace(placeId));
    }

    @GetMapping("/member/{memIdx}")
    public ResponseEntity<List<ReviewEntity>> getMemberReviews(@PathVariable int memIdx) {
        return ResponseEntity.ok(reviewService.getReviewsByMember(memIdx));
    }

    @PutMapping("/{reviewId}")
    public ResponseEntity<ReviewEntity> updateReview(@PathVariable Long reviewId, @RequestBody ReviewEntity review) {
        return ResponseEntity.ok(reviewService.updateReview(reviewId, review));
    }

    @DeleteMapping("/{reviewId}")
    public ResponseEntity<Void> deleteReview(@PathVariable Long reviewId) {
        reviewService.deleteReview(reviewId);
        return ResponseEntity.noContent().build();
    }
    @GetMapping("/all")
    @ResponseBody
    public ResponseEntity<List<ReviewEntity>> getAllReviews() {
        List<ReviewEntity> reviews = reviewService.getAllReviews();
        return ResponseEntity.ok(reviews);
    }
    
    
    
    
    


    
}
