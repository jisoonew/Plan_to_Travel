package com.ptt.model;

public class HistoryVO {

	//다룰 데이터 선언
		//실제 DB에 있는 데이터와 동일 시 하는 것이 좋다.
		
		//schedule 테이블의 uID
		private String uID;
		//schedule 테이블의 uID
		private String travel_TITLE;
		//schedule 테이블의 schedule_UUID
		private String schedule_UUID;

		//getter, setter 메소드 생성 : 데이터를 불러오고 적용할 때 사용한다. 
		
		//Setter (세터):
		//	Setter 메서드는 객체의 속성 값을 설정하거나 저장합니다.
		//	외부에서 전달된 값을 객체의 속성에 할당하여 값을 변경하거나 설정합니다.
		//	이를 통해 속성의 값을 변경하고 유효성 검사를 수행하는 등의 작업을 수행할 수 있습니다.
		
		//Getter (게터):
		//	Getter 메서드는 객체의 속성 값을 반환해주는 역할을 합니다.
		//	외부에서 객체의 속성 값을 읽어올 때 사용됩니다.
		//	Getter 메서드를 통해 속성 값을 읽고 외부로 노출시킴으로써, 속성 값을 안전하게 읽을 수 있습니다.
		
		public String getuID() {
			return uID;
		}
		public void setuID(String uID) {
			this.uID = uID;
		}
		
		public String getTravel_TITLE() {
			return travel_TITLE;
		}
		public void setTravel_TITLE(String travel_TITLE) {
			this.travel_TITLE = travel_TITLE;
		}
		
		public String getSchedule_UUID() {
			return schedule_UUID;
		}
		public void setSchedule_UUID(String schedule_UUID) {
			this.schedule_UUID = schedule_UUID;
		}
		
		
		
		@Override
		public String toString() {
			return "HistoryVO [travel_TITLE=" + travel_TITLE + ", schedule_UUID=" + schedule_UUID + "]";
		}
		
}
