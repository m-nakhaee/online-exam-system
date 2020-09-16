package onlineSchool.controller;

import onlineSchool.exceptions.*;
import onlineSchool.model.entity.mainEntities.Course;
import onlineSchool.model.entity.helpEntities.Status;
import onlineSchool.model.entity.mainEntities.User;
import onlineSchool.service.UserService;
import onlineSchool.service.VerificationCodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@RestController
public class UserRestController {
    private UserService userService;
    private CheckOTickClass checkOTick;
    private VerificationCodeService verificationCodeService;
    @Autowired
    ServletContext servletContext;

    @Autowired
    public UserRestController(UserService userService, VerificationCodeService verificationCodeService) {
        this.userService = userService;
        this.checkOTick = new CheckOTickClass();
        this.verificationCodeService = verificationCodeService;
    }

    @Transactional
    @PostMapping(value = "/register")  //TODO chek kon age ret value string e sade bashe
    public ResponseEntity<String> register(@RequestBody User user, HttpServletRequest request) {
        try {
            checkOTick.checkAnyLogIn(request);
            Status status = new Status();
            status.setId(1);
            status.setName("email confirm waiting...");
            user.setStatus(status);
            userService.register(user);
            verificationCodeService.sendEmail(user);
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            checkOTick.addToServletContext(user.getEmail(), servletContext);
        } catch (CurrentLoginException | DuplicateUserException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
        return ResponseEntity.ok("registered");
    }

    @PostMapping(value = "/login")
    public ResponseEntity<String> login(@RequestBody User userLogin, HttpServletRequest request) {
        try {
            //TODO you can write it by spring aop
            checkOTick.checkAnyLogIn(request);
            checkOTick.checkUserNotLoggedInBefore(userLogin.getEmail(), servletContext);
            User user = userService.login(userLogin);
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            checkOTick.addToServletContext(userLogin.getEmail(), servletContext);
        } catch (CurrentLoginException | NotAvailableUserException | PasswordException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
        return ResponseEntity.ok("");
    }

    @PostMapping(value = "/getFilteredUsers")
    public List<User> getFilteredUsers(@RequestBody User user) {
        List<User> filteredUsers = userService.getFilteredUsers(0, user);
        return filteredUsers;
    }

    @GetMapping(value = "/getAllUsers")
    public List<User> getAllUsers() {
        return userService.getAllUsers(0);
    }

    @PostMapping(value = "/createDropUser")
    public String crateDropUser(@RequestBody User user) {
        String userStatus = user.getStatus().getName();
        if (Objects.equals(userStatus, "deleted"))
            userService.remove(user);
        if (Objects.equals(userStatus, "registered")) {
            try {
                userService.register(user);
            } catch (DuplicateUserException e) {
                return e.getMessage();
            }
        }
        return "action completed";
    }

    @PostMapping(value = "/updateUser")
    public String updateUser(@RequestBody User user) {
        userService.update(user);
        return "update completed";
    }

    @GetMapping(value = "/getCourses")
    public List<Course> getCourses(@RequestParam("email") String email){
        User user = userService.getUser(email);
        Set<Course> courseSet = user.getCourseSet();
        List<Course> courseList = new ArrayList<>();
        courseList.addAll(courseSet);
        return courseList;
    }

}
