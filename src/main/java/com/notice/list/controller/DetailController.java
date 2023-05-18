package com.notice.list.controller;

import com.notice.list.service.ListService;
import com.notice.vo.FileVO;
import com.notice.vo.ListVo;
import com.notice.vo.NbVO;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

@Controller
@Slf4j
public class DetailController {

    @Autowired
    private ListService listService;

    @RequestMapping("/detailPage.do")
    public  String goDetailPage(@RequestParam int boardId, Model model){

        log.debug("보드아이디 확인:{} ", boardId);

        ListVo notice = listService.getNoticeById(boardId);
        model.addAttribute("notice", notice);
        return "list/detailPage";
    }

    @RequestMapping("/update.do")
    @ResponseBody
    public String updateBoard(
            @RequestParam("boardId") int boardId,
            @RequestParam("title") String title,
            @RequestParam("noticeStatus") String noticeStatus,
            @RequestParam("content") String content,
            @RequestParam("writer") String writer,
            @RequestParam("password") String password,
            @RequestParam(value = "files[]", required = false) List<MultipartFile> files,
            @RequestParam("delFileList") String delFileListString
    ){

        NbVO nbVO = new NbVO(boardId,title,writer,password,content,noticeStatus,files);
        log.debug("수정 nbVO : {} " , nbVO);
        log.debug("수정 delFileListString : {} " , delFileListString);
        List<FileVO> delFileList = new ArrayList<>();

        if(delFileListString != null && !delFileListString.equals("")){
            // delFileListString을 JSON 형태로 변환하여 사용
            try {
                JSONArray delFileListJSON = new JSONArray(delFileListString);
                for (int i = 0; i < delFileListJSON.length(); i++) {
                    JSONObject fileVOJSON = delFileListJSON.getJSONObject(i);
                    FileVO fileVO = new FileVO();
                    fileVO.setId(fileVOJSON.getInt("id"));
                    fileVO.setFilePath(fileVOJSON.getString("filePath"));
                    delFileList.add(fileVO);
                }
            } catch (JSONException e) {
                // JSON 파싱 오류 처리
                e.printStackTrace();
            }

            log.debug("수정 delFileList : {} " , delFileList);
            nbVO.setDelFileList(delFileList);
        }

        log.debug("수정 nbVO : {} " , nbVO);

        listService.updateBoard(nbVO);


        return "";
    }
}
