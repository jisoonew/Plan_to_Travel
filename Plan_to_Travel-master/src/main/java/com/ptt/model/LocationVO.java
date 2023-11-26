package com.ptt.model;

import java.sql.Date;

public class LocationVO {
private String location_UUID;
private String uID;
private String location_ID;
private String location_TITLE;
private String location_DATE;
private String location_TIME;
private String location_NAME;
private String location_LAT;
private String location_LNG;
private String location_MEMO;
private String location_REVIEW;


public String getLocation_UUID() {
	return location_UUID;
}
public void setLocation_UUID(String location_UUID) {
	this.location_UUID = location_UUID;
}
public String getuID() {
	return uID;
}
public void setuID(String uID) {
	this.uID = uID;
}
public String getLocation_ID() {
	return location_ID;
}
public void setLocation_ID(String location_ID) {
	this.location_ID = location_ID;
}
public String getLocation_TITLE() {
	return location_TITLE;
}
public void setLocation_TITLE(String location_TITLE) {
	this.location_TITLE = location_TITLE;
}
public String getLocation_DATE() {
	return location_DATE;
}
public void setLocation_DATE(String arrStr) {
	this.location_DATE = arrStr;
}
public String getLocation_TIME() {
	return location_TIME;
}
public void setLocation_TIME(String location_TIME) {
	this.location_TIME = location_TIME;
}
public String getLocation_NAME() {
	return location_NAME;
}
public void setLocation_NAME(String location_NAME) {
	this.location_NAME = location_NAME;
}
public String getLocation_LAT() {
	return location_LAT;
}
public void setLocation_LAT(String location_LAT) {
	this.location_LAT = location_LAT;
}
public String getLocation_LNG() {
	return location_LNG;
}
public void setLocation_LNG(String location_LNG) {
	this.location_LNG = location_LNG;
}
public String getLocation_MEMO() {
	return location_MEMO;
}
public void setLocation_MEMO(String location_MEMO) {
	this.location_MEMO = location_MEMO;
}
public String getLocation_REVIEW() {
	return location_REVIEW;
}
public void setLocation_REVIEW(String location_REVIEW) {
	this.location_REVIEW = location_REVIEW;
}
@Override
public String toString() {
    return "LocationVo "
    		+ "[location_UUID=" + location_UUID + ", uID=" + uID + ", location_ID=" + location_ID + ", location_TITLE=" + location_TITLE + ", location_DATE=" + location_DATE + 
    		", location_TIME=" + location_TIME + ", location_NAME=" + location_NAME + ", location_LAT=" + location_LAT + ", location_LNG=" + location_LNG + 
    		", location_MEMO=" + location_MEMO + ", location_REVIEW=" + location_REVIEW + "]";
}
}
