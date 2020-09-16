package onlineSchool.model.specification;

import onlineSchool.model.entity.mainEntities.Course;
import onlineSchool.model.entity.helpEntities.Role;
import onlineSchool.model.entity.helpEntities.Status;
import onlineSchool.model.entity.mainEntities.User;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Set;

public interface UserSpecification {
    static Specification<User> findMaxMatch(User user) {
        return (Specification<User>) (root, criteriaQuery, builder) -> {
            CriteriaQuery<User> resultCriteria = builder.createQuery(User.class);
            String firstName = user.getFirstName();
            String lastName = user.getLastName();
            String email = user.getEmail();
            String password = user.getPassword();
            Role role = user.getRole();
            Set<Course> courseSet = user.getCourseSet();
            Status status = user.getStatus();

            List<Predicate> predicates = new ArrayList<Predicate>();
            if (!StringUtils.isEmpty(firstName)) {
                predicates.add(builder.equal(root.get("firstName"), firstName));
            }
            if (!StringUtils.isEmpty(lastName)) {
                predicates.add(builder.equal(root.get("lastName"), lastName));
            }
            if (!StringUtils.isEmpty(email)) {
                predicates.add(builder.equal(root.get("email"), email));
            }
            if (!StringUtils.isEmpty(password)) {
                predicates.add(builder.equal(root.get("password"), password));
            }
            if (Objects.nonNull(role) && !StringUtils.isEmpty(role.getName())) {
                predicates.add(builder.equal(root.join("role").get("name"), role.getName()));
            }
            if (!CollectionUtils.isEmpty(courseSet)) {
                predicates.add(builder.in(root.join("courseSet")).value(courseSet));
            }
            if (Objects.nonNull(status) && !StringUtils.isEmpty(status.getName())) {
                predicates.add(builder.equal(root.join("status").get("name"), status.getName()));
            }

            resultCriteria.select(root).where(predicates.toArray(new Predicate[0]));
            return resultCriteria.getRestriction();
        };
    }

}
