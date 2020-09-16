package onlineSchool.controller;

import onlineSchool.enumeration.RoleEnum;
import onlineSchool.model.entity.helpEntities.Role;
import onlineSchool.model.entity.helpEntities.Status;
import onlineSchool.model.entity.mainEntities.User;
import onlineSchool.service.RoleService;
import onlineSchool.service.StatusService;
import onlineSchool.service.UserService;
import onlineSchool.service.VerificationCodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Objects;

@Controller
public class UserController {
    private UserService userService;
    private VerificationCodeService verificationCodeService;
    private RoleService roleService;
    @Autowired
    private StatusService statusService;
    private CheckOTickClass checkOTick;
    @Autowired
    ServletContext servletContext;

    @Autowired
    public UserController(UserService userService,
                          VerificationCodeService verificationCodeService, RoleService roleService) {
        this.userService = userService;
        this.verificationCodeService = verificationCodeService;
        this.roleService = roleService;
        checkOTick = new CheckOTickClass();
    }

    @GetMapping(value = "/registerForm")
    public String showRegisterForm(Model model) {
        List<Role> allRoles = roleService.getAllRoles();
        List<Status> allStatus = statusService.getAllStatus();
        model.addAttribute("user", new User());
        model.addAttribute("roles", allRoles);
        model.addAttribute("allStatus", allStatus);
        return "forms/registerFormPage";
    }

    @GetMapping(value = "/loginForm")
    public String showLoginForm(Model model) {
        model.addAttribute("user", new User());
        return "forms/loginFormPage";
    }

    @GetMapping(value = "/userPanel")
    public String showUserPanel(Model model, HttpServletRequest request) {
        //TODO you must logged in first or registered to use this servlet
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String onlineUsers = (String) servletContext.getAttribute("onlineUsers");
        if (Objects.isNull(user))
            return "forward:loginForm";
        else {
            model.addAttribute("onlineUsers", onlineUsers);
            model.addAttribute("user", user);
        }
        String roleName = user.getRole().getName();
        if (Objects.equals(roleName, RoleEnum.teacher.toString()))
            return "panels/teacherPanelPage";
        return "panels/studentPanelPage";
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpServletRequest request, ModelMap model) {
        //TODO spring security--- you must be log in first then you can log out!!
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
//        session.setAttribute("user", null);
        session.removeAttribute("user");
        String onlineUsers = (String) servletContext.getAttribute("onlineUsers");
        onlineUsers = onlineUsers.replace(user.getEmail(), "");
        servletContext.setAttribute("onlineUsers", onlineUsers);
        session.invalidate();
        model.clear();
        return "forms/loginFormPage";
    }

    @RequestMapping(value = "/verify/{code}", method = RequestMethod.GET)
    public ModelAndView verify(@PathVariable("code") String receivedCode, HttpServletRequest request) {
        /*     TODO write it by spring security
            checkOTick.checkAnyLogIn(request);
            return new ModelAndView("massages/massagePage",
                    "massage", " TODO first log in please");
        */
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (!Objects.equals(user.getStatus().getName(), "email confirm waiting..."))
            return new ModelAndView("massages/massagePage", "massage",
                    "this verification is not valid! please check every thing or register again");
        String savedCode = verificationCodeService.getCode(user);
        if (Objects.equals(savedCode, receivedCode)) {
            userService.confirmEmailAddress(user);
            return new ModelAndView("userPanelPage",
                    "user", user);
        } else return new ModelAndView("massages/massagePage",
                "massage",
                "this verification is not valid! please check every thing or register again");
    }

}
