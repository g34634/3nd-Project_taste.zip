package com.taste.zip.vo;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class PlaceDetailIntroVO {
    private Response response;

    @Getter @Setter
    public static class Response {
        private Header header;
        private Body body;
    }

    @Getter @Setter
    public static class Header {
        private String resultCode;
        private String resultMsg;
    }

    @Getter @Setter
    public static class Body {
        private Items items;
        private int numOfRows;
        private int pageNo;
        private int totalCount;
    }

    @Getter @Setter
    public static class Items {
        private List<PlaceDetailIntro> item;
    }

    @Getter @Setter
    public static class PlaceDetailIntro {
        private String contentid;
        private String contenttypeid;
        
        // Tourism
        private String accomcount;
        private String chkbabycarriage;
        private String chkcreditcard;
        private String chkpet;
        private String expagerange;
        private String expguide;
        private String heritage1;
        private String heritage2;
        private String heritage3;
        private String infocenter;
        private String opendate;
        private String parking;
        private String restdate;
        private String useseason;
        private String usetime;

        // Festival
        private String agelimit;
        private String bookingplace;
        private String discountinfofestival;
        private String eventenddate;
        private String eventhomepage;
        private String eventplace;
        private String eventstartdate;
        private String festivalgrade;
        private String placeinfo;
        private String playtime;
        private String program;
        private String spendtimefestival;
        private String sponsor1;
        private String sponsor1tel;
        private String sponsor2;
        private String sponsor2tel;
        private String subevent;
        private String usetimefestival;

        // Leisure
        private String accomcountleports;
        private String chkbabycarriageleports;
        private String chkcreditcardleports;
        private String chkpetleports;
        private String expagerangeleports;
        private String infocenterleports;
        private String openperiod;
        private String parkingfeeleports;
        private String parkingleports;
        private String reservation;
        private String restdateleports;
        private String scaleleports;
        private String usefeeleports;
        private String usetimeleports;
        
        // Restaurant
        private String chkcreditcardfood;
        private String discountinfofood;
        private String firstmenu;
        private String infocenterfood;
        private String kidsfacility;
        private String opendatefood;
        private String opentimefood;
        private String packing;
        private String parkingfood;
        private String reservationfood;
        private String restdatefood;
        private String scalefood;
        private String seat;
        private String smoking;
        private String treatmenu;
        private String lcnsno;
    }
}

