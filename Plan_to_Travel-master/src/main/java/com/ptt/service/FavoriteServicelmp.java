package com.ptt.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ptt.mapper.FavoriteMapper;
import com.ptt.model.FavoriteVO;

@Service
public class FavoriteServicelmp implements FavoriteService {
	
	@Autowired
    private FavoriteMapper favoriteMapper;

	//즐겨찾기 저장
    @Override
    public void addFavorite(FavoriteVO favoriteVO) {
        favoriteMapper.addFavorite(favoriteVO);
    }
    
	//즐겨찾기 목록 불러오기
	@Override
    public List<FavoriteVO> selectFavorite(FavoriteVO favorite) throws Exception {
        return favoriteMapper.selectFavorite(favorite);
    }
	
    //즐겨찾기 삭제
    @Override
    public void deleteFav(String fav_id) {
        // 여기에서 ScheduleMapper를 이용하여 DB에서 해당 scheduleId에 해당하는 데이터를 삭제하는 로직을 작성
    	favoriteMapper.deleteFav(fav_id);
    }
    
    //즐겨찾기 전체 삭제
    @Override
    public void deleteAllFav(String u_id) {
        favoriteMapper.deleteAllFav(u_id);
    }
    
    //즐겨찾기 하나 클릭
    @Override
    public FavoriteVO getFavInfo(String fav_id) {
        return favoriteMapper.getFavInfo(fav_id);
    }
}