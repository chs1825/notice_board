package com.notice.register.controller;

import com.notice.vo.NbVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@Slf4j
@RequestMapping("/")
public class HiddenTestController {

    @RequestMapping("/test.do")
    public String testXss(){

        return "register/hiddenTest";
    }

    @RequestMapping("testXss1.do")
    public String testXss1(Model model, @RequestParam String test){

        log.debug("test : {}", test);
        model.addAttribute("changeText", test);
        return "register/hiddenTest";
    }

    @RequestMapping("testXss2.do")
    public String testXss2(Model model, @RequestParam String test){

        log.debug("test : {}", test);
        model.addAttribute("changeText", test);
        return "register/hiddenTest";
    }

    @PostMapping("/ajaxModel.do")
    public void ajaxTest3(NbVO param, Model model){
        log.debug("xss 방지 되는가?: {}" , param );


        model.addAttribute("data",param);
//        return "jsonview";
    }



    @RequestMapping("goHidden2.do")
    public String goHidden2(){

        return "register/hiddenPage2";
    }



    @PostMapping("/customFilterTest.do")
    @ResponseBody
    public String customFilterTest(@RequestBody String title){

        log.debug("customFilterTest 확인: {}" , title);


        return title;
    }

}
