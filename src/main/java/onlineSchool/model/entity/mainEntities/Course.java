package onlineSchool.model.entity.mainEntities;

import onlineSchool.model.entity.helpEntities.Category;

import javax.persistence.*;
import java.util.Set;

@Entity
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private Integer courseId;
    private String title;
    @ManyToOne
    private Category category;
    @OneToMany(mappedBy = "course", fetch = FetchType.EAGER)
    private Set<Quiz> quizSet;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getCourseId() {
        return courseId;
    }

    public void setCourseId(Integer courseId) {
        this.courseId = courseId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Set<Quiz> getQuizSet() {
        return quizSet;
    }

    public void setQuizSet(Set<Quiz> quizSet) {
        this.quizSet = quizSet;
    }

    @Override
    public String toString() {
        return "Course{" +
                "id=" + id +
                ", courseId=" + courseId +
                ", title='" + title + '\'' +
                ", category=" + category +
                ", quizSet=" + quizSet +
                '}';
    }
}
