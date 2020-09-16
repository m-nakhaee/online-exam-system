package onlineSchool.controller;

import onlineSchool.model.entity.mainEntities.Question;
import onlineSchool.model.entity.mainEntities.Quiz;
import onlineSchool.service.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class QuizRestController {
    @Autowired
    QuizService quizService;

    @PostMapping(value = "/updateQuiz")
    public ResponseEntity<String> updateQuiz(@RequestBody Quiz quiz) {
        try {
            quizService.update(quiz);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("a problem has occurred");
        }
        return ResponseEntity.ok("quiz updated successfully");
    }

    @PostMapping(value = "/saveNewQuiz")
    public ResponseEntity<String> saveNewQuiz(@RequestBody Quiz quiz) {
        try {
            quizService.save(quiz);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("a problem has occurred");
        }
        return ResponseEntity.badRequest().body("new quiz saved successfully");
    }

//    @GetMapping(value = "/getQuestions")
//    public List<Question> getAddQuestionsPage(@RequestParam("category") Integer categoryId) {
//        List<Question> questions = categoryService.getQuestions(categoryId);
//        return questions;
//    }

}
