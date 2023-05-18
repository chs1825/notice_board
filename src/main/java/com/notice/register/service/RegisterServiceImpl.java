package com.notice.register.service;

import com.notice.register.mapper.RegisterMapper;
import com.notice.vo.FileVO;
import com.notice.vo.NbVO;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@Slf4j
public class RegisterServiceImpl implements RegisterService{

    @Autowired
    private RegisterMapper registerMapper;


    public void registerBoard(NbVO nbVO) {

        log.debug("null? : {}" , nbVO.getNoticeStatus());

//        대표 게시글 체크
        if(nbVO.getNoticeStatus().equals("1")){
            registerMapper.updateNoticeStatus();
        }

        //게시글 인서트
        registerMapper.insertBoard(nbVO);
        log.debug("반환 보드아이디: {}",nbVO.getBoardId());

        //보드 아이디 리턴받기
        int board_id = nbVO.getBoardId();


        //인서트할 파일 리스트
        List<FileVO> fileVOList = new ArrayList<FileVO>();

        List<MultipartFile> files = nbVO.getFiles();
        log.debug("등록 파일 널체크: {}" , files);
        log.debug("등록 파일 널체크: {}" , files.get(0));
        log.debug("등록 파일 널체크: {}" , files.get(0).getOriginalFilename());

        if(!files.get(0).getOriginalFilename().equals("")){

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
                fileVO.setBoardId(board_id);

                //리스트 추가
                fileVOList.add(fileVO);
            }
            //파일 테이블 인서트
            registerMapper.insertFile(fileVOList);
        }



    }
}
