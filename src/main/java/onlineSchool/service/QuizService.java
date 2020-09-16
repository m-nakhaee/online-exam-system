package onlineSchool.service;

import onlineSchool.enumeration.QuestionTypeEnum;
import onlineSchool.model.dao.QuestionDao;
import onlineSchool.model.dao.QuizDao;
import onlineSchool.model.entity.mainEntities.Question;
import onlineSchool.model.entity.mainEntities.Quiz;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class QuizService {
    @Autowired
    QuizDao quizDao;
    @Autowired
    QuestionDao questionDao;

    @Transactional
    public Integer save(Quiz quiz) {
     //TODO validation haye UI bayad back ham bashe
        quizDao.save(quiz);
        return quiz.getId();
    }

    public Quiz getQuiz(Integer id) {
        //TODO if null throw exception
        Optional<Quiz> quizOptional = quizDao.findById(id);
        if (quizOptional.isPresent()) return quizOptional.get();
        return null;
    }

    @Transactional
    public Map<QuestionTypeEnum, List<Question>> getQuestions(Quiz quiz) {
        Map<QuestionTypeEnum, List<Question>> questions = new HashMap<>();
        List<Question> descriptiveQuestions = new ArrayList<>();
        List<Question> multipleChoiceQuestions = new ArrayList<>();
        Set<Question> questionSet = quiz.getQuestionScoreMap().keySet();
        Iterator<Question> questionIterator = questionSet.iterator();
        while (questionIterator.hasNext()) {
            Question question = questionIterator.next();
            if (Objects.equals(question.getType(), QuestionTypeEnum.descriptive))
                descriptiveQuestions.add(question);
            if (Objects.equals(question.getType(), QuestionTypeEnum.multipleChoice))
                multipleChoiceQuestions.add(question);
        }
        questions.put(QuestionTypeEnum.descriptive, descriptiveQuestions);
        questions.put(QuestionTypeEnum.multipleChoice, multipleChoiceQuestions);
        return questions;
    }

    @Transactional
    public void update(Quiz quizUpdate) {
        Optional<Quiz> byId = quizDao.findById(quizUpdate.getId());
        if (byId.isPresent()) {
            Quiz quiz = byId.get();
            if (Objects.nonNull(quizUpdate.getTitle()))
                quiz.setTitle(quizUpdate.getTitle());
            if (Objects.nonNull(quizUpdate.getDescription()))
                quiz.setDescription(quizUpdate.getDescription());
            if (Objects.nonNull(quizUpdate.getDuration()))
                quiz.setDuration(quizUpdate.getDuration());
            if (Objects.nonNull(quizUpdate.getStartDate()))
                quiz.setStartDate(quizUpdate.getStartDate());
            if (Objects.nonNull(quizUpdate.getEndDate()))
                quiz.setEndDate(quizUpdate.getEndDate());
//            if (Objects.nonNull(quizUpdate.getQuestionScoreSet()))
//                updateQuestionSet(quizUpdate, quiz);
            if (Objects.nonNull(quizUpdate.getState()))
                quiz.setState(quizUpdate.getState());
        }
    }

    private void updateQuestionSet(Quiz newQuiz, Quiz quiz) {
//        for (QuestionScore newQuestionScore : newQuiz.getQuestionScoreSet()) {
//            Question newQuestion = newQuestionScore.getQuestion();
//            if (isSameQuestionInQuiz(quiz, )) {
//                Question mainQuestion = result.get();
//                if (Objects.nonNull(newQuestion.getDefaultScore()))
//                    mainQuestion.setDefaultScore(newQuestion.getDefaultScore());
//                else
//                    deleteQuestion(quiz, mainQuestion);
//            } else
//                addNewQuestion(quiz, newQuestion);
//        }
    }

    private void addNewQuestion(Quiz quiz, Question newQuestion) {
//        questionDao.save(newQuestion);
//        Set<Question> questionSet = quiz.getQuestionSet();
//        questionSet.add(newQuestion);
//        quiz.setQuestionSet(questionSet);
    }

    private void deleteQuestion(Quiz quiz, Question mainQuestion) {
//        Set<Question> questionSet = quiz.getQuestionSet();
//        boolean remove = questionSet.remove(mainQuestion);
//        quiz.setQuestionSet(questionSet);
    }
}
