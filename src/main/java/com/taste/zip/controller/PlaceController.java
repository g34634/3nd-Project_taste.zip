package com.taste.zip.controller;

// import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
// import org.springframework.web.servlet.ModelAndView;

import com.taste.zip.api.AreaCodeApiExplorer;
import com.taste.zip.api.DetailInfoApiExplorer;
import com.taste.zip.api.PlaceAreaBasedListApiExplorer;
import com.taste.zip.api.PlaceDetailCommonApiExplorer;
import com.taste.zip.api.PlaceIntroApiExplorer;
import com.taste.zip.entity.PlaceEntity;
import com.taste.zip.service.PlaceService;
import com.taste.zip.vo.AreaCodeVO;
import com.taste.zip.vo.AreaCodeVO.AreaCode;
import com.taste.zip.vo.DetailCommonVO;
import com.taste.zip.vo.DetailInfoVO;
import com.taste.zip.vo.PlaceDetailIntroVO;
import com.taste.zip.vo.PlaceVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/places")
public class PlaceController {
    
    @Autowired
    private PlaceService placeService;
    
    private static final String SERVICE_KEY = "YwBZem4wHPLMylzzg9Oy6PTiDA94x1cmOJRsaOmTMu31f6jYqU/x2gLHziEJIpxkn7p0XTfSyJqVXIjaazct5w==";
    private static final String BASE_URL = "http://apis.data.go.kr/B551011/KorService1";
    private static final String AREA_LIST_URL = BASE_URL + "/areaBasedList1";
    private static final String AREA_CODE_URL = BASE_URL + "/areaCode1";
    private static final String DETAIL_COMMON_URL = BASE_URL + "/detailCommon1";
    private static final String DETAIL_INTRO_URL = BASE_URL + "/detailIntro1";
    private static final String DETAIL_INFO_URL = BASE_URL + "/detailInfo1";
    private static final String NUM_OF_ROWS = "50";



    @GetMapping("/places.do")
    public String places(Model model) {
        List<PlaceEntity> initialPlaces = placeService.getPlacePage(1, 12);
        model.addAttribute("initialPlaces", initialPlaces);
        return "places/places";
    }

    @GetMapping("/api/mapPlaces")
    @ResponseBody
    public List<PlaceEntity> getMapPlaces() {
        return placeService.getPlaceList();
    }

    @GetMapping("/api/getInitialPlaces")
    @ResponseBody
    public List<PlaceEntity> getInitialPlaces() {
        return placeService.getPlacePage(1, 10);  // Get first 10 places
    }


    @GetMapping("/getPlaceList")
    @ResponseBody
    public ResponseEntity<List<PlaceEntity>> getPlaceList(@RequestParam(defaultValue = "1") int page, 
                                                         @RequestParam(defaultValue = "8") int size) {
        List<PlaceEntity> places = placeService.getPlacePage(page, size);
        return ResponseEntity.ok(places);
    }
    


    




    @GetMapping("/insertPlaces.do")
    @ResponseBody
    public String insertPlaces() {
        try {
            int pageNo = 1;
            int result = 0;
            
            while (true) {
                PlaceVO data = PlaceAreaBasedListApiExplorer.getApiJsonData(
                    SERVICE_KEY, AREA_LIST_URL, String.valueOf(pageNo), NUM_OF_ROWS, PlaceVO.class);
                
                if (data.getResponse().getBody().getItems().equals("")) break;
                
                result += placeService.insertPlace(data);
                
                if (pageNo > 400) break;
                pageNo++;
            }
            
            return result >= 1 ? "success" : "failed";
            
        } catch (Exception e) {
            log.error("Error inserting places", e);
            return "error";
        }
    }
    
    @GetMapping("/getAreaName.do")
    public String getAreaName() {
        try {
            AreaCodeVO area = AreaCodeApiExplorer.getApiJsonData(SERVICE_KEY, AREA_CODE_URL, 
                    "1", NUM_OF_ROWS, "", AreaCodeVO.class);
            List<AreaCode> areacode = area.getResponse().getBody().getItems().getItem();
            
            Map<String, String> areaCodeMap = areacode.stream()
                .collect(Collectors.toMap(AreaCode::getCode, AreaCode::getName));
            
            for(AreaCode item : areacode) {
                AreaCodeVO area2 = AreaCodeApiExplorer.getApiJsonData(SERVICE_KEY, AREA_CODE_URL, 
                        "1", NUM_OF_ROWS, item.getCode(), AreaCodeVO.class);
                List<AreaCode> area2code = area2.getResponse().getBody().getItems().getItem();
                
                for (AreaCode newItem : area2code) {
                    String codeKey = item.getCode() + "_" + newItem.getCode();
                    areaCodeMap.put(codeKey, newItem.getName());
                }
            }
            
            List<PlaceEntity> placeList = placeService.getPlaceList();
            placeList.parallelStream().forEach(item -> {
                String areaCode = item.getAreacode();
                if(areaCode != null) {
                    String sigunguCode = areaCode + "_" + item.getSigungucode();
                    placeService.updateAreaName(
                        areaCodeMap.get(areaCode),
                        areaCodeMap.get(sigunguCode),
                        item.getContentid()
                    );
                }
            });
            
            return "home";
        } catch (Exception e) {
            log.error("Error updating area names", e);
            return "error";
        }
    }

@GetMapping("/updatePlaceInfo.do")
public String updatePlaceInfo(Model model) {
    try {
        List<PlaceEntity> allPlaces = placeService.getPlaceList();
        
        for (PlaceEntity place : allPlaces) {
            String contentid = place.getContentid();
            String contenttypeid = place.getContenttypeid();
            
            DetailInfoVO infodata = DetailInfoApiExplorer.getApiJsonData(SERVICE_KEY, DETAIL_INFO_URL,
                    contentid, contenttypeid, DetailInfoVO.class);

            if (infodata.getResponse().getBody().getItems() == null ||
                    infodata.getResponse().getBody().getItems().getItem().isEmpty()) {
                continue;
            }
            
            List<DetailInfoVO.DetailInfo> infoItems = infodata.getResponse().getBody().getItems().getItem();
            
            for (DetailInfoVO.DetailInfo infoItem : infoItems) {
                String serialnum = infoItem.getSerialnum();

                switch (serialnum) {
                    case "0":
                        place.setInfoname1(infoItem.getInfoname());
                        place.setInfotext1(infoItem.getInfotext());
                        break;
                    case "1":
                        place.setInfoname2(infoItem.getInfoname());
                        place.setInfotext2(infoItem.getInfotext());
                        break;
                    case "2":
                        place.setInfoname3(infoItem.getInfoname());
                        place.setInfotext3(infoItem.getInfotext());
                        break;
                    case "3":
                        place.setInfoname4(infoItem.getInfoname());
                        place.setInfotext4(infoItem.getInfotext());
                        break;
                    case "4":
                        place.setInfoname5(infoItem.getInfoname());
                        place.setInfotext5(infoItem.getInfotext());
                        break;
                    case "5":
                        place.setInfoname6(infoItem.getInfoname());
                        place.setInfotext6(infoItem.getInfotext());
                        break;
                    case "6":
                        place.setInfoname7(infoItem.getInfoname());
                        place.setInfotext7(infoItem.getInfotext());
                        break;
                }
            }
            
            placeService.updatePlaceInfo(place);
        }

        log.info("All place details have been updated successfully.");
        return "home";

    } catch (Exception e) {
        log.error("Error updating place details", e);
        return "error";
    }
}

    @GetMapping("/updatePlaceIntro.do")
    public String updatePlaceIntro(Model model) {
        try {
            List<PlaceEntity> allPlaces = placeService.getPlaceList();
            
            for (PlaceEntity place : allPlaces) {
                String contentid = place.getContentid();
                String contenttypeid = place.getContenttypeid();
                
                DetailCommonVO comdata = PlaceDetailCommonApiExplorer.getApiJsonData(SERVICE_KEY, 
                        DETAIL_COMMON_URL, contentid, contenttypeid, DetailCommonVO.class);
                
                if (comdata.getResponse().getBody().getItems() == null ||
                        comdata.getResponse().getBody().getItems().getItem().isEmpty()) {
                    continue;
                }
                
                DetailCommonVO.Item item = comdata.getResponse().getBody().getItems().getItem().get(0);
                place.setHomepage(item.getHomepage());
                place.setOverview(item.getOverview());
                
                PlaceDetailIntroVO intdata = PlaceIntroApiExplorer.getApiJsonData(SERVICE_KEY, 
                        DETAIL_INTRO_URL, contentid, contenttypeid, PlaceDetailIntroVO.class);
                
                if (intdata.getResponse().getBody().getItems() == null ||
                        intdata.getResponse().getBody().getItems().getItem().isEmpty()) {
                    continue;
                }
                
                PlaceDetailIntroVO.PlaceDetailIntro intItem = intdata.getResponse().getBody().getItems().getItem().get(0);
                
                place.setChkcreditcardfood(intItem.getChkcreditcardfood());
                place.setDiscountinfofood(intItem.getDiscountinfofood());
                place.setFirstmenu(intItem.getFirstmenu());
                place.setInfocenterfood(intItem.getInfocenterfood());
                place.setKidsfacility(intItem.getKidsfacility());
                place.setOpendatefood(intItem.getOpendatefood());
                place.setOpentimefood(intItem.getOpentimefood());
                place.setPacking(intItem.getPacking());
                place.setParkingfood(intItem.getParkingfood());
                place.setReservationfood(intItem.getReservationfood());
                place.setRestdatefood(intItem.getRestdatefood());
                place.setScalefood(intItem.getScalefood());
                place.setSeat(intItem.getSeat());
                place.setSmoking(intItem.getSmoking());
                place.setTreatmenu(intItem.getTreatmenu());
                place.setLcnsno(intItem.getLcnsno());

                placeService.updatePlaceIntro(place);
            }

            log.info("All place intro details have been updated successfully.");
            return "home";

        } catch (Exception e) {
            log.error("Error updating place intro details", e);
            return "error";
        }
    }

    @GetMapping("/updateCategories.do")
    @ResponseBody
    public String updateCategories() {
        try {
            int result = placeService.updateCategories();
            return result > 0 ? "success" : "no updates needed";
        } catch (Exception e) {
            log.error("Error updating categories", e);
            return "error";
        }
    }
    


    @GetMapping("/getMorePlaces")
    @ResponseBody
    public List<PlaceEntity> getMorePlaces(@RequestParam int page, @RequestParam int size) {
        return placeService.getPlacePage(page, size);
    }

    @GetMapping("/searchPlaces")
    @ResponseBody
    public List<PlaceEntity> searchPlaces(@RequestParam String searchTerm) {
        return placeService.searchPlaces(searchTerm);
    }



}
