package com.notice.vo;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Data

public class FileVO {

    private int id;
    private String filename;

    private String realFilename;

    private int boardId;

    private String filePath;

    private long fileSize;





}
