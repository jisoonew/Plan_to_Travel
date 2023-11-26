package com.ptt.model;

public class ScheduleVO {
	
	private String sche_id;
	private String u_id;
	private String sche_title;


	public String getSche_id() {
		return sche_id;
	}

	public void setSche_id(String sche_id) {
		this.sche_id = sche_id;
	}

	public String getU_id() {
		return u_id;
	}

	public void setU_id(String u_id) {
		this.u_id = u_id;
	}

	public String getSche_title() {
		return sche_title;
	}

	public void setSche_title(String sche_title) {
		this.sche_title = sche_title;
	}

	@Override
	public String toString() {
	    return "ScheduleVo "
	    		+ "[" + "sche_id=" + sche_id + ", u_id=" + u_id + ", sche_title=" + sche_title + "]";
	}
}
