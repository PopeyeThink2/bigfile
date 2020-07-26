package com.xia.bigfile.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class Gotoindex {
    @RequestMapping("/index")
    public String gotoindex(){
        return "upload";
    }
}
