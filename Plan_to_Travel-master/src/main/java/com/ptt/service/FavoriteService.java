package com.ptt.service;

import java.util.List;

import com.ptt.model.FavoriteVO;

public interface FavoriteService {
	
	//즐겨찾기 추가
	public void addFavorite(FavoriteVO favoriteVO);
	
	//즐겨찾기 목록 불러오기
	public List<FavoriteVO> selectFavorite(FavoriteVO favorite) throws Exception;
	
	//즐겨찾기 삭제
	public void deleteFav(String fav_id) throws Exception;
	
	//즐겨찾기 전체 삭제
	public void deleteAllFav(String u_id);
	
	//즐겨찾기 하나 클릭
	public FavoriteVO getFavInfo(String fav_id);
}