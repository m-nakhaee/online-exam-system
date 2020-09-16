package onlineSchool.controller;

import onlineSchool.enumeration.QuestionTypeEnum;
import onlineSchool.enumeration.QuizStateEnum;
import onlineSchool.model.entity.mainEntities.*;
import onlineSchool.service.CourseService;
import onlineSchool.service.QuizService;
import onlineSchool.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.*;

@Controller
public class CourseController {

    @Autowired
    CourseService courseService;
    @Autowired
    UserService userService;

    @GetMapping(value = "/courseStudents")
    public String getCourseStudents(@RequestParam("courseTitle") String courseTitle,
                                    @RequestParam("courseId") Integer courseId,
                                    Model model) {
        Course course = new Course();
        course.setId(courseId);
        List<Course> courseList = courseService.getFilteredCourse(0, course);
        Course courseFind = courseList.get(0);
        if (Objects.isNull(courseFind)) return "massages/massagePage";
        List<User> courseStudents = userService.getCourseStudents(0, courseFind);
        if (Objects.isNull(courseStudents)) return "massages/massagePage";
        model.addAttribute("courseStudents", courseStudents);
        model.addAttribute("courseTitle", courseTitle);
        return "decelerations/courseStudentsPage";
    }

    @GetMapping(value = "/courseQuizzes")
    public String getCourseQuizzes(@RequestParam("courseId") Integer courseId
            , @RequestParam("teacherId") Integer teacherId, Model model) {
        Course course = new Course();
        course.setId(courseId);
        List<Course> courseList = courseService.getFilteredCourse(0, course);
        if (Objects.isNull(courseList)) return "massages/massagePage";
        Course courseFind = courseList.get(0);
        model.addAttribute("teacherId", teacherId);
        model.addAttribute("course", courseFind);
        model.addAttribute("quizStates", QuizStateEnum.values());
        return "decelerations/courseQuizzesPage";
    }

}
