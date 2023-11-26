package com.ptt.model;

public class EventVO {
	private String event_id;
	private int event_num;
	private String sche_id;
	private String event_title;
	private String event_datetime;
	private String event_date;
	private String event_place;
	private String event_lat;
	private String event_lng;
	private String event_memo;
	private String event_review;
	
	public String getEvent_id() {
		return event_id;
	}
	public void setEvent_id(String event_id) {
		this.event_id = event_id;
	}
	public int getEvent_num() {
		return event_num;
	}
	public void setEvent_num(int event_num) {
		this.event_num = event_num;
	}
	public String getSche_id() {
		return sche_id;
	}
	public void setSche_id(String sche_id) {
		this.sche_id = sche_id;
	}
	public String getEvent_title() {
		return event_title;
	}
	public void setEvent_title(String event_title) {
		this.event_title = event_title;
	}
	public String getEvent_datetime() {
		return event_datetime;
	}
	public void setEvent_datetime(String event_datetime) {
		this.event_datetime = event_datetime;
	}
	
	public String getEvent_date() {
		return event_date;
	}
	public void setEvent_date(String event_date) {
		this.event_date = event_date;
	}
	public String getEvent_place() {
		return event_place;
	}
	public void setEvent_place(String event_place) {
		this.event_place = event_place;
	}
	public String getEvent_lat() {
		return event_lat;
	}
	public void setEvent_lat(String event_lat) {
		this.event_lat = event_lat;
	}
	public String getEvent_lng() {
		return event_lng;
	}
	public void setEvent_lng(String event_lng) {
		this.event_lng = event_lng;
	}
	public String getEvent_memo() {
		return event_memo;
	}
	public void setEvent_memo(String event_memo) {
		this.event_memo = event_memo;
	}
	public String getEvent_review() {
		return event_review;
	}
	public void setEvent_review(String event_review) {
		this.event_review = event_review;
	}
	
	@Override
	public String toString() {
	    return "EventVo "
	    		+ "[event_id=" + event_id + ", event_num=" + event_num + ", sche_id=" + sche_id + ", event_title=" + event_title + ", event_datetime=" + event_datetime + 
	    		", event_place=" + event_place + ", event_lat=" + event_lat + ", event_lng=" + event_lng + ", event_memo=" + event_memo + ", event_review=" + event_review + "]";
	}
}
