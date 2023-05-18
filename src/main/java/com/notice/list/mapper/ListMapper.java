package com.notice.list.mapper;

import com.notice.vo.FileVO;
import com.notice.vo.NbVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.RowBounds;

import java.util.List;
import java.util.Map;

@Mapper
public interface ListMapper {

    public NbVO selectMainNotice();

    public List<NbVO> selectAllList();

    public List<FileVO> selectFileByBoard_id(int boardId);

    public int selectAllSize();

    public List<NbVO> selectByPaging(Map<String, Integer> rowMap);

    public NbVO selectNoticeById(int boardId);

    public void updateNoticeViews(int boardId);

    public void updateBoard(NbVO nbVO);

    public void deleteFile(List<FileVO> delFileList);
}
