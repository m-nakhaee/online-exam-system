package onlineSchool.model.specification;

import onlineSchool.model.entity.helpEntities.Category;
import onlineSchool.model.entity.mainEntities.Course;
import onlineSchool.model.entity.mainEntities.Quiz;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Set;

public interface CourseSpecification {
    static Specification<Course> findMaxMatch(Course course) {
        return (Specification<Course>) (root, criteriaQuery, builder) -> {
            CriteriaQuery<Course> resultCriteria = builder.createQuery(Course.class);
            Integer courseId = course.getId();
            String title = course.getTitle();
            Category category = course.getCategory();
            Set<Quiz> quizSet = course.getQuizSet();

            List<Predicate> predicates = new ArrayList<Predicate>();
            if (Objects.nonNull(courseId)) {
                predicates.add(builder.equal(root.get("id"), courseId));
            }
            if (!StringUtils.isEmpty(title)) {
                predicates.add(builder.equal(root.get("title"), title));
            }
            if (Objects.nonNull(category)) {
                predicates.add(builder.equal(root.get("category"), category));
            }
            if (!CollectionUtils.isEmpty(quizSet)) {
                predicates.add(builder.in(root.join("quizSet")).value(quizSet));
            }

            resultCriteria.select(root).where(predicates.toArray(new Predicate[0]));
            return resultCriteria.getRestriction();
        };
    }

}
