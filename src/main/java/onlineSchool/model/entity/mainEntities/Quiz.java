package onlineSchool.model.entity.mainEntities;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import onlineSchool.enumeration.QuizStateEnum;

import javax.persistence.*;
import java.util.Date;
import java.util.Map;

@Entity
public class Quiz {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String title;
    private String description;
    private Integer duration; //TODO search about Time classes //duration
    //    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date startDate;
    //    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endDate;
    @ManyToOne
    private User teacher;
    @ManyToOne
    private Course course;
    @ElementCollection(fetch = FetchType.EAGER)
    @MapKeyJoinColumn(name = "questionID")
    @Column(name = "score")
    @JsonSerialize(keyUsing = QuestionSerializer.class)
    @JsonDeserialize(keyUsing = QuestionKeyDeserializer.class)
    private Map<Question, Double> questionScoreMap; //map soalo score
    private QuizStateEnum state;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer time) {
        this.duration = time;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public User getUser() {
        return teacher;
    }

    public void setUser(User teacher) {
        this.teacher = teacher;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public User getTeacher() {
        return teacher;
    }

    public void setTeacher(User teacher) {
        this.teacher = teacher;
    }

    public Map<Question, Double> getQuestionScoreMap() {
        return questionScoreMap;
    }

    public void setQuestionScoreMap(Map<Question, Double> questionScoreMap) {
        this.questionScoreMap = questionScoreMap;
    }

    public QuizStateEnum getState() {
        return state;
    }

    public void setState(QuizStateEnum state) {
        this.state = state;
    }
}
