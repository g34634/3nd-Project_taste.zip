package com.taste.zip.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityNotFoundException;

import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.taste.zip.entity.PlaceEntity;
import com.taste.zip.repository.PlaceRepository;
import com.taste.zip.vo.PlaceVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PlaceServiceImpl implements PlaceService {

    private final PlaceRepository placeRepository;

    @Override
    public int insertPlace(PlaceVO data) {
        try {
            List<PlaceEntity> places = data.getResponse().getBody().getItems().getItem();
            placeRepository.saveAll(places);
            return places.size();
        } catch (Exception e) {
            return 0;
        }
    }

    @Override
    public List<PlaceEntity> getPlaceList() {
        return placeRepository.findAll();
    }

    @Override
    @Transactional
    public int updateAreaName(String areaName, String sigunguName, String contentid) {
        return placeRepository.updateAreaName(areaName, sigunguName, contentid);
    }

    @Override
    public List<PlaceEntity> getPlacePage(int page, int size) {
        PageRequest pageRequest = PageRequest.of(page - 1, size);
        return placeRepository.findAllPaged(pageRequest).getContent();
    }

    @Override
    public PlaceEntity getPlace(String contentid) {
        return placeRepository.findByContentid(contentid)
                .orElseThrow(() -> new EntityNotFoundException("Place not found"));
    }

    @Override
    @Transactional
    public int updatePlaceDetails(PlaceEntity place) {
        try {
            placeRepository.save(place);
            return 1;
        } catch (Exception e) {
            return 0;
        }
    }

    @Override
    @Transactional
    public int updatePlaceIntro(PlaceEntity place) {
        try {
            placeRepository.save(place);
            return 1;
        } catch (Exception e) {
            return 0;
        }
    }

    @Override
    @Transactional
    public int updatePlaceInfo(PlaceEntity place) {
        try {
            placeRepository.save(place);
            return 1;
        } catch (Exception e) {
            return 0;
        }
    }

    @Override
    public List<PlaceEntity> searchPlaces(String searchTerm) {
        return placeRepository.findByTitleContaining(searchTerm);
    }

    @Override
    @Transactional
    public int updateCategories() {
        Map<String, String> categories = new HashMap<>();
        categories.put("A05020100", "한식");
        categories.put("A05020200", "서양식");
        categories.put("A05020300", "일식");
        categories.put("A05020400", "중식");
        categories.put("A05020700", "이색음식점");
        categories.put("A05020900", "카페/찻집");

        int totalUpdated = 0;
        for (Map.Entry<String, String> entry : categories.entrySet()) {
            totalUpdated += placeRepository.updateCategory(entry.getValue(), entry.getKey());
        }
        return totalUpdated;
    }


}

