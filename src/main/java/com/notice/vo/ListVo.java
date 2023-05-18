package com.notice.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter
@Setter
@ToString
public class ListVo {

    private NbVO nbVO;

    private List<FileVO> fileVOList;

    public ListVo() {
    }

    public ListVo(NbVO nbVO, List<FileVO> fileVOList) {
        this.nbVO = nbVO;
        this.fileVOList = fileVOList;
    }
}
