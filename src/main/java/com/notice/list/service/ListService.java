package com.notice.list.service;

import com.notice.vo.ListVo;
import com.notice.vo.NbVO;

import java.util.List;

public interface ListService {

    public List<NbVO> getAllList();

    public ListVo getMainNotice();

    public int getListSize();

    public List<NbVO> getListByPaging(int offset, int limit);

    public ListVo getNoticeById(int boardId);

    public void updateBoard(NbVO nbVO);
}
