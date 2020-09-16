package onlineSchool.controller;

import onlineSchool.configuration.DataBaseContext;
import onlineSchool.exceptions.NotAvailableUserException;
import onlineSchool.exceptions.PasswordException;
import onlineSchool.model.dao.QuizDao;
import onlineSchool.model.dao.UserDao;
import onlineSchool.model.entity.mainEntities.Quiz;
import onlineSchool.model.entity.mainEntities.User;
import onlineSchool.service.UserService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import java.util.Optional;

public class Main {
    static ApplicationContext applicationContext = new AnnotationConfigApplicationContext(DataBaseContext.class);


    public static void main(String[] args) throws PasswordException, NotAvailableUserException {
        UserDao userDao = (UserDao) applicationContext.getBean("userDao");
        UserService userService = (UserService) applicationContext.getBean("userService");
        QuizDao quizDao = (QuizDao) applicationContext.getBean("quizDao");
        User user = new User();
        Optional<Quiz> byId = quizDao.findById(99);
        if(byId.isPresent()) System.out.println(byId.get().getDescription());
        else System.out.println("naboooooood");
        user.setEmail("8531nakhmail.com");
//        user.setPassword("aaaa1111");
//        User login = userService.login(user);
//        System.out.println(login.getCourseList());
//        List<User> userList = userService.getCourseStudents(0, maktab22);
//        System.out.println(userList);

    }
}
