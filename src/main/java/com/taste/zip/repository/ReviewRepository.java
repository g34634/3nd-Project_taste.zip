package com.taste.zip.repository;

import com.taste.zip.entity.ReviewEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.lang.NonNull;

import java.util.List;

public interface ReviewRepository extends JpaRepository<ReviewEntity, Long> {
    List<ReviewEntity> findByPlacePlaceId(int placeId);
    List<ReviewEntity> findByMemberMemIdx(int memIdx);
    @NonNull
    List<ReviewEntity> findAll();
}
