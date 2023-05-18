package com.notice.list.service;

import com.notice.list.mapper.ListMapper;
import com.notice.register.mapper.RegisterMapper;
import com.notice.vo.FileVO;
import com.notice.vo.ListVo;
import com.notice.vo.NbVO;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@Service
@Slf4j
public class ListServiceImpl implements ListService{

    @Autowired
    private ListMapper listMapper;
    @Autowired
    private RegisterMapper registerMapper;


    @Override
    public List<NbVO> getAllList() {

        List<NbVO> nbVOList= listMapper.selectAllList();
        log.debug("전체리스트 : {}" , nbVOList);
        return nbVOList;
    }

    @Override
    @Transactional
    public ListVo getNoticeById(int boardId) {
        listMapper.updateNoticeViews(boardId);
        NbVO nbVO = listMapper.selectNoticeById(boardId);
        List<FileVO> fileVOList = listMapper.selectFileByBoard_id(boardId);

        log.debug("널체크: {}", fileVOList);

        ListVo listVo = new ListVo();
        listVo.setNbVO(nbVO);
        listVo.setFileVOList(fileVOList);

        return listVo;
    }

    @Override
    public void updateBoard(NbVO nbVO) {

        log.debug("updateBoard 작동?");
        log.debug("updateBoard:{}" , nbVO);
        log.debug("updateBoard:{}" , nbVO);

        //대표글 설정이 되어 있다면 기존 대표글 설정 없애주
        if(nbVO.getNoticeStatus().equals("1")){
            registerMapper.updateNoticeStatus();
        }

        listMapper.updateBoard(nbVO);

        //추가할 첨부파일이 있을때
        if(nbVO.getFiles() != null && !nbVO.getFiles().isEmpty()){
            uploadFile(nbVO);
        }

        //삭제할 파일이 있을때
        if(nbVO.getDelFileList() != null && !nbVO.getDelFileList().isEmpty()){
            deleteFiles(nbVO);
        }

    }



    @Override
    public ListVo getMainNotice() {


        NbVO nbVO = listMapper.selectMainNotice();
        log.debug("mainnotice 확인 : {}",nbVO);
        if(nbVO == null){
            return null;
        }

        int boId = nbVO.getBoardId();
        List<FileVO> fileVOList = listMapper.selectFileByBoard_id(boId);
        log.debug("mainnotice 확인 : {}",fileVOList);

        ListVo listVo = new ListVo();
        listVo.setNbVO(nbVO);
        listVo.setFileVOList(fileVOList);

        return listVo;
    }

    @Override
    public int getListSize() {
        return listMapper.selectAllSize();
    }

    @Override
    public List<NbVO> getListByPaging(int offset, int limit) {

        Map<String, Integer> map = new HashMap<>();
        map.put("offset", offset);
        map.put("limit", limit);

        return listMapper.selectByPaging(map);
    }


    public void uploadFile(NbVO nbVO){

        List<FileVO> fileVOList = new ArrayList<FileVO>();

        List<MultipartFile> files = nbVO.getFiles();

        for(MultipartFile file : files){

            //파일저장하기 transfer 사용방식 >> uuid 사용 못함
            /*File uploadFile = new File("ds");
            try {
                file.transferTo(uploadFile);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }*/

            //파일 저장하기
            // 1. 저장할 디렉토리 경로 생성
            String userHome = System.getProperty("user.home");
            log.debug("유저홈 : {}",userHome);
            // 로컬용
            String uploadDir = userHome + "/IdeaProjects/test/notice_board/src/main/webapp/resources/uploadFolder/";

            //배포용
//            String uploadDir = userHome + "/deploy/ROOT/webapp/resources/uploadFolder/";
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // 2. 파일 정보 가져오기
            long fileSize = file.getSize();
            String fileType = file.getContentType();
            String originalFileName = file.getOriginalFilename();

            // 3. 파일 이름 변경
            String ext = FilenameUtils.getExtension(originalFileName);
            String newName = UUID.randomUUID().toString() + "." + ext;

            // 4. 파일 저장
            try {
                InputStream inputStream = file.getInputStream();
//                byte[] bytes = file.getBytes();
                Path path = Paths.get(uploadDir + newName);
//                Files.write(path, bytes);
                Files.copy(inputStream,path);
            } catch (IOException e) {
                // 예외 처리
            }

            //vo구성하기
            FileVO fileVO = new FileVO();
            fileVO.setFilename(newName);
            fileVO.setRealFilename(file.getOriginalFilename());
            fileVO.setFileSize(file.getSize());
            fileVO.setFilePath(uploadDir + newName);
            fileVO.setBoardId(nbVO.getBoardId());

            //리스트 추가
            fileVOList.add(fileVO);
        }

        //파일 테이블 인서트
        registerMapper.insertFile(fileVOList);

    }


    private void deleteFiles(NbVO nbVO) {

        List<FileVO> delFileList = nbVO.getDelFileList();

        listMapper.deleteFile(delFileList);

        for(FileVO fileVO : delFileList){
            String filePath = fileVO.getFilePath();
            File file = new File(filePath);
            if (file.exists()) {
                if (file.delete()) {
                    System.out.println("파일 삭제 성공: " + filePath);
                } else {
                    System.out.println("파일 삭제 실패: " + filePath);
                }
            } else {
                System.out.println("파일이 존재하지 않습니다: " + filePath);
            }
        }

    }

}





