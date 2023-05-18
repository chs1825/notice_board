package com.notice.register.mapper;

import com.notice.vo.FileVO;
import com.notice.vo.NbVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface RegisterMapper {

    public void insertBoard(NbVO nbVO);

    public void insertFile(List<FileVO> fileVOList);


    public void updateNoticeStatus();
}
