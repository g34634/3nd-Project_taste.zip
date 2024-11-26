package com.taste.zip.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "place")
@Getter @Setter
@NoArgsConstructor
public class PlaceEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "place_id")
    private int placeId;
    
    @Column(name = "addr1", length = 200)
    private String addr1;
    
    @Column(name = "addr2", length = 50)
    private String addr2;
    
    @Column(name = "areacode", length = 20)
    private String areacode;
    
    @Column(name = "areaname", length = 20)
    private String areaname;
    
    @Column(name = "booktour", length = 10)
    private String booktour;
    
    @Column(name = "cat1", length = 20)
    private String cat1;
    
    @Column(name = "cat2", length = 20)
    private String cat2;
    
    @Column(name = "cat3", length = 20)
    private String cat3;
    
    @Column(name = "contentid", length = 30)
    private String contentid;
    
    @Column(name = "contenttypeid", length = 20)
    private String contenttypeid;
    
    @Column(name = "createdtime", length = 50)
    private String createdtime;
    
    @Column(name = "firstimage", length = 150)
    private String firstimage;
    
    @Column(name = "firstimage2", length = 150)
    private String firstimage2;
    
    @Column(name = "cpyrht_div_cd", length = 20)
    private String cpyrhtDivCd;
    
    @Column(name = "mapx", length = 50)
    private String mapx;
    
    @Column(name = "mapy", length = 50)
    private String mapy;
    
    @Column(name = "mlevel", length = 10)
    private String mlevel;
    
    @Column(name = "readcount", length = 20)
    private String readcount;
    
    @Column(name = "modifiedtime", length = 30)
    private String modifiedtime;
    
    @Column(name = "sigungucode", length = 20)
    private String sigungucode;
    
    @Column(name = "sigunguname", length = 20)
    private String sigunguname;
    
    @Column(name = "tel", length = 500)
    private String tel;
    
    @Column(name = "title", length = 40)
    private String title;
    
    @Column(name = "zipcode", length = 10)
    private String zipcode;
    
    @Column(name = "info", length = 10)
    private String info;
    
    @Column(name = "opendate", length = 10)
    private String opendate;
    
    @Column(name = "enddate", length = 10)
    private String enddate;
    
    @Column(name = "restdate", length = 10)
    private String restdate;
    
    @Column(name = "price", length = 10)
    private String price;
    
    @Column(name = "usetime", length = 10)
    private String usetime;
    
    @Column(name = "overview", length = 2000)
    private String overview;
    
    @Column(name = "homepage", length = 1000)
    private String homepage;
    
    @Column(name = "infoname1", length = 20)
    private String infoname1;
    
    @Column(name = "infotext1", length = 500)
    private String infotext1;
    
    @Column(name = "infoname2", length = 20)
    private String infoname2;
    
    @Column(name = "infotext2", length = 500)
    private String infotext2;
    
    @Column(name = "infoname3", length = 20)
    private String infoname3;
    
    @Column(name = "infotext3", length = 500)
    private String infotext3;
    
    @Column(name = "infoname4", length = 20)
    private String infoname4;
    
    @Column(name = "infotext4", length = 500)
    private String infotext4;
    
    @Column(name = "infoname5", length = 10)
    private String infoname5;
    
    @Column(name = "infotext5", length = 500)
    private String infotext5;
    
    @Column(name = "infoname6", length = 10)
    private String infoname6;
    
    @Column(name = "infotext6", length = 500)
    private String infotext6;
    
    @Column(name = "infoname7", length = 10)
    private String infoname7;
    
    @Column(name = "infotext7", length = 100)
    private String infotext7;
    
    @Column(name = "chkcreditcardfood", length = 20)
    private String chkcreditcardfood;
    
    @Column(name = "discountinfofood", length = 1000)
    private String discountinfofood;
    
    @Column(name = "firstmenu", length = 500)
    private String firstmenu;
    
    @Column(name = "infocenterfood", length = 500)
    private String infocenterfood;
    
    @Column(name = "kidsfacility", length = 10)
    private String kidsfacility;
    
    @Column(name = "opendatefood", length = 1000)
    private String opendatefood;
    
    @Column(name = "opentimefood", length = 1000)
    private String opentimefood;
    
    @Column(name = "packing", length = 40)
    private String packing;
    
    @Column(name = "parkingfood", length = 300)
    private String parkingfood;
    
    @Column(name = "reservationfood", length = 200)
    private String reservationfood;
    
    @Column(name = "restdatefood", length = 500)
    private String restdatefood;
    
    @Column(name = "scalefood", length = 1000)
    private String scalefood;
    
    @Column(name = "seat", length = 500)
    private String seat;
    
    @Column(name = "smoking", length = 20)
    private String smoking;
    
    @Column(name = "treatmenu", length = 900)
    private String treatmenu;
    
    @Column(name = "lcnsno", length = 40)
    private String lcnsno;
}
