package com.notice.login;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {

    @RequestMapping(value = "/login")
    public String login() {
        return "loginPage";
    }


    @RequestMapping(value = "/admin")
    public String admin() {
        return "admin";
    }

    @RequestMapping(value = "/user")
    public String user() {
        return "user";
    }

    @RequestMapping(value = "/all")
    public String all() {
        return "all";
    }
}
