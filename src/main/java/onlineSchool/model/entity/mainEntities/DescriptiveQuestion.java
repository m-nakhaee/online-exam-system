package onlineSchool.model.entity.mainEntities;

import javax.persistence.Entity;

@Entity
public class DescriptiveQuestion extends Question {
    private String answer;

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }
}
