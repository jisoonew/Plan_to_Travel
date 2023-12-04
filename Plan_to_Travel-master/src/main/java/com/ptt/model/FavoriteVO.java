package com.ptt.model;

public class FavoriteVO {
	
	private String u_id;
	private String fav_id;
	private String fav_name;
	private String fav_address1;
	private String fav_address2;
	private String fav_lat;
	private String fav_lng;
	private String fav_info;
	
	
	public String getU_id() {
		return u_id;
	}
	public void setU_id(String u_id) {
		this.u_id = u_id;
	}
	public String getFav_id() {
		return fav_id;
	}
	public void setFav_id(String fav_id) {
		this.fav_id = fav_id;
	}
	public String getFav_name() {
		return fav_name;
	}
	public void setFav_name(String fav_name) {
		this.fav_name = fav_name;
	}
	public String getFav_address1() {
		return fav_address1;
	}
	public void setFav_address1(String fav_address1) {
		this.fav_address1 = fav_address1;
	}
	public String getFav_address2() {
		return fav_address2;
	}
	public void setFav_address2(String fav_address2) {
		this.fav_address2 = fav_address2;
	}
	public String getFav_lat() {
		return fav_lat;
	}
	public void setFav_lat(String fav_lat) {
		this.fav_lat = fav_lat;
	}
	public String getFav_lng() {
		return fav_lng;
	}
	public void setFav_lng(String fav_lng) {
		this.fav_lng = fav_lng;
	}
	public String getFav_info() {
		return fav_info;
	}
	public void setFav_info(String fav_info) {
		this.fav_info = fav_info;
	}
	
	
	@Override
	public String toString() {
		return "FavoriteVO [u_id=" + u_id + ", fav_id=" + fav_id + ", fav_name=" + fav_name + ", fav_address1="
				+ fav_address1 + ", fav_address2=" + fav_address2 + ", fav_lat=" + fav_lat + ", fav_lng=" + fav_lng
				+ ", fav_info=" + fav_info + "]";
	}
	
	
}