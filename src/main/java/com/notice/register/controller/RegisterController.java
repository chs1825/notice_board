package com.notice.register.controller;

import com.notice.register.service.RegisterService;
import com.notice.vo.NbVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@Slf4j
@RequestMapping("/register")
public class RegisterController {

    @Autowired
    private RegisterService registerService;

    @RequestMapping(value = "/registerPage.do")
    public String goRegisterForm(){

//        NbVO nbVO = new NbVO("test","chs","1234","안뇽",1);

//        log.debug("실행횟수가 왜 3번?");
//        registerService.registerBoard(nbVO);

        return "register/registerPage";

    }

    @RequestMapping(value = "/register.do", method = RequestMethod.POST)
    @ResponseBody
    public String registerBoard(@ModelAttribute NbVO nbVO){

        log.debug("nbVO : {} " , nbVO);

        registerService.registerBoard(nbVO);

        log.debug("nbVOfiles : {} " , nbVO.getFiles());

//        return "redirect:/";
        return "";
    }







}
