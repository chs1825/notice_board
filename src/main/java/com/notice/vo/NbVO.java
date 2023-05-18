package com.notice.vo;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.sql.Date;
import java.util.List;
import java.util.Map;

@Setter
@Getter
@ToString
public class NbVO {


    private int boardId;
    private String title;
    private String writer;
    private String password;
    private String content;
    private Date date;
    private String noticeStatus;
    private int views;
    private int fileNum;
    private List<MultipartFile> files;
    private List<FileVO> delFileList;



    public NbVO() {
    }

    public NbVO(int boardId, String title, String writer, String password, String content, String noticeStatus, List<MultipartFile> files) {
        this.boardId = boardId;
        this.title = title;
        this.writer = writer;
        this.password = password;
        this.content = content;
        this.noticeStatus = noticeStatus;
        this.files = files;
    }
}

