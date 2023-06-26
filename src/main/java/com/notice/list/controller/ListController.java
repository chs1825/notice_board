package com.notice.list.controller;

import com.notice.list.mapper.ListMapper;
import com.notice.list.service.ListService;
import com.notice.vo.ListVo;
import com.notice.vo.NbVO;
import com.notice.vo.PagingVO;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
public class ListController {

    @Autowired
    private ListService listService;

    @Autowired
    private ListMapper listMapper;

    @RequestMapping("/")
    public String goListPage(Model model){
//        log.debug("대표공지글 구성 확인표 : {}",listService.selectMainNotice());

        ListVo mainNotice = listService.getMainNotice();
        log.debug("메인노티스 로그: {}" , mainNotice);
        model.addAttribute("mainNotice", mainNotice);

        return "list/listPage";
    }


    @GetMapping("/getListPage.do")
    public String getListPage(Model model, @RequestParam(defaultValue="1") int currentPage){

        log.debug("페이징 처리 진행중");
        log.debug("커렌트페이지: {}", currentPage);
        //전체 리스트의 row개수 구하기
        int total = listService.getListSize();
        //한번에 보여줄 행의 개수
        int size = 5;
        //보여줄 행의 시작점 찾기
        int offset = (currentPage -1)  * size  ;
        //페이징이 적용된 리스트 조회해오기
        List<NbVO> nbVOList = listService.getListByPaging(offset, size);

        model.addAttribute("List", new PagingVO(total, currentPage, size, 5, nbVOList));

//        model.addAttribute("list", nbVOList);

        return "jsonview";
    }

    @RequestMapping(value = "/dowmFile.do")
//    public void downJson(HttpServletResponse response, @RequestParam("filePath") String filePath) throws IOException {
    public void downJson(HttpServletResponse response, @RequestParam("filePath") String filePath, @RequestParam("fileName") String fileName) throws IOException {

        log.debug("이거 작동은 해??");
        log.debug("filePath : {}" , filePath);
//        log.debug("fileName : {}" , fileName);
        File file = new File(filePath);
//        String fileName = file.getName();
//        String fileName = "ddd.hwp";

        response.setContentType("application/json");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        // 파일 내용을 읽어들여서 response body에 작성합니다.
        InputStream inputStream = new FileInputStream(file);
        OutputStream outputStream = response.getOutputStream();
        byte[] buffer = new byte[1024];
        int bytesRead;
        while ((bytesRead = inputStream.read(buffer)) != -1) {
            outputStream.write(buffer, 0, bytesRead);
        }
        outputStream.flush();
        outputStream.close();
        inputStream.close();
    }



}
