package com.taste.zip.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.taste.zip.entity.PlaceEntity;


@Repository
public interface PlaceRepository extends JpaRepository<PlaceEntity, Integer> {
    
    Optional<PlaceEntity> findByContentid(String contentid);
    
    List<PlaceEntity> findByTitleContaining(String searchTerm);
     
    @Query("SELECT p FROM PlaceEntity p ORDER BY p.placeId")
    Page<PlaceEntity> findAllPaged(Pageable pageable);
    
    @Modifying
    @Query("UPDATE PlaceEntity p SET p.areaname = :areaName, p.sigunguname = :sigunguName WHERE p.contentid = :contentid")
    int updateAreaName(@Param("areaName") String areaName, @Param("sigunguName") String sigunguName, @Param("contentid") String contentid);

    @Modifying
    @Query("UPDATE PlaceEntity p SET p.cat3 = :categoryName WHERE p.cat3 = :categoryCode")
    int updateCategory(@Param("categoryName") String categoryName, @Param("categoryCode") String categoryCode);

}

