package onlineSchool.model.dao;

import onlineSchool.model.entity.mainEntities.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface CourseDao extends JpaRepository<Course, Integer>, JpaSpecificationExecutor<Course> {
}
