package onlineSchool.controller;

import onlineSchool.model.entity.mainEntities.Question;
import onlineSchool.service.QuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class QuestionRestController {
@Autowired
QuestionService questionService;

    @PostMapping(value = "/saveNewQuestion")
    public ResponseEntity<String> saveNewQuestion(@RequestBody Question question) {
        try {
            questionService.save(question);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("a problem has occurred");
        }
        return ResponseEntity.badRequest().body("new question saved successfully");
    }
}
