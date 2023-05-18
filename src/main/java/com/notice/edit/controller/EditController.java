package com.notice.edit.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;


@Slf4j
@Controller
@RequestMapping("/")
public class EditController {

    @RequestMapping("/edit.do")
    public String goEdit(){

        return "edit/editPage";
    }
}
