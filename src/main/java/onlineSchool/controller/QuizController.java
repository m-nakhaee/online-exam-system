package onlineSchool.controller;

import onlineSchool.enumeration.QuestionTypeEnum;
import onlineSchool.enumeration.QuizStateEnum;
import onlineSchool.model.entity.mainEntities.DescriptiveQuestion;
import onlineSchool.model.entity.mainEntities.MultipleChoiceQuestion;
import onlineSchool.model.entity.mainEntities.Question;
import onlineSchool.model.entity.mainEntities.Quiz;
import onlineSchool.service.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Controller
public class QuizController {

    @Autowired
    QuizService quizService;

    @GetMapping(value = "/addQuizForm")
    public String goToddQuizForm(@RequestParam("courseId") Integer courseId,
                                 @RequestParam("categoryId") Integer categoryId,
                                 @RequestParam Integer teacherId,Model model) {
        model.addAttribute("courseId", courseId);
        model.addAttribute("teacherId", teacherId);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("availableState", QuizStateEnum.values()[0].toString());
        model.addAttribute("typesOfQuestion", QuestionTypeEnum.values());
        return "forms/addQuizForm";
    }


    @GetMapping(value = "/quizQuestions")
    public String getQuizQuestions(@RequestParam("quizId") Integer quizId,
                                   @RequestParam("action") String action,
                                   Model model) {
        Quiz quiz = quizService.getQuiz(quizId);
        String description = quiz.getDescription();
        String title = quiz.getTitle();
//        System.out.println(quiz.getDescription());
        if (Objects.isNull(quiz)) return "massages/massagePage";
        Map<QuestionTypeEnum, List<Question>> questionMap = quizService.getQuestions(quiz);
        if (Objects.isNull(questionMap)) return "massages/massagePage";
        List<DescriptiveQuestion> descriptiveQuestions = getDescriptiveQuestions(questionMap);
        List<MultipleChoiceQuestion> multipleChoiceQuestions = getMultipleChoiceQuestions(questionMap);
        model.addAttribute("descriptiveQuestions", descriptiveQuestions);
        model.addAttribute("multipleChoiceQuestions", multipleChoiceQuestions);
        model.addAttribute("quiz", quiz);
        model.addAttribute("action", action);
        return "decelerations/quizQuestionsPage";
    }

    private List<MultipleChoiceQuestion> getMultipleChoiceQuestions(Map<QuestionTypeEnum, List<Question>> questionMap) {
        List<Question> questionList = questionMap.get(QuestionTypeEnum.multipleChoice);
        List<MultipleChoiceQuestion> multipleChoiceQuestions = new ArrayList<>();
        for (Question question : questionList)
            multipleChoiceQuestions.add((MultipleChoiceQuestion) question);
        return multipleChoiceQuestions;
    }

    private List<DescriptiveQuestion> getDescriptiveQuestions(Map<QuestionTypeEnum, List<Question>> questionMap) {
        List<Question> questionList = questionMap.get(QuestionTypeEnum.descriptive);
        List<DescriptiveQuestion> descriptiveQuestions = new ArrayList<>();
        for (Question question : questionList)
            descriptiveQuestions.add((DescriptiveQuestion) question);
        return descriptiveQuestions;
    }
}
