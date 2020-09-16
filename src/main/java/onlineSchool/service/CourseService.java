package onlineSchool.service;

import onlineSchool.model.dao.CourseDao;
import onlineSchool.model.entity.mainEntities.Course;
import onlineSchool.model.specification.CourseSpecification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CourseService {
@Autowired
    CourseDao courseDao;
    public List<Course> getFilteredCourse(int pageNumber, Course course) {
        Pageable pageable = PageRequest.of(pageNumber, 5);
        Page<Course> courses = courseDao.findAll(CourseSpecification.findMaxMatch(course), pageable);
        return courses.getContent();
    }
}
