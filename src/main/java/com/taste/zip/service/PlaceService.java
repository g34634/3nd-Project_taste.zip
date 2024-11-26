package com.taste.zip.service;

import java.util.List;

import com.taste.zip.entity.PlaceEntity;
import com.taste.zip.vo.PlaceVO;

public interface PlaceService {
    int insertPlace(PlaceVO data);
    List<PlaceEntity> getPlaceList();
    int updateAreaName(String areaName, String sigunguName, String contentid);
    List<PlaceEntity> getPlacePage(int page, int size);
    PlaceEntity getPlace(String contentid);
    int updatePlaceDetails(PlaceEntity place);
    int updatePlaceIntro(PlaceEntity place);
    int updatePlaceInfo(PlaceEntity place);
    List<PlaceEntity> searchPlaces(String searchTerm);
    int updateCategories();

}

