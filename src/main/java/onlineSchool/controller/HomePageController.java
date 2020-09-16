package onlineSchool.controller;

import onlineSchool.model.entity.mainEntities.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class HomePageController {

    @GetMapping(value = "/")
    public String goToHomePage(HttpServletRequest request, Model model){
        HttpSession session = request.getSession();
        User user = (User)session.getAttribute("user");
        model.addAttribute("user", user);
        return "home";
    }
}
