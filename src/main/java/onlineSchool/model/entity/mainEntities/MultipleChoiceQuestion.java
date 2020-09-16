package onlineSchool.model.entity.mainEntities;

import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import java.util.Set;

@Entity
public class MultipleChoiceQuestion extends Question {
    private String correctAnswer;
    @ElementCollection(fetch = FetchType.EAGER)
    private Set<String> answerOptions;

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    public Set<String> getAnswerOptions() {
        return answerOptions;
    }

    public void setAnswerOptions(Set<String> answerOptions) {
        this.answerOptions = answerOptions;
    }
}
