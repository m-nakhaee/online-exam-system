package onlineSchool.service;

import onlineSchool.enumeration.RoleEnum;
import onlineSchool.exceptions.DuplicateUserException;
import onlineSchool.exceptions.NotAvailableUserException;
import onlineSchool.exceptions.PasswordException;
import onlineSchool.model.dao.CourseDao;
import onlineSchool.model.dao.UserDao;
import onlineSchool.model.entity.mainEntities.Course;
import onlineSchool.model.entity.helpEntities.Role;
import onlineSchool.model.entity.helpEntities.Status;
import onlineSchool.model.entity.mainEntities.User;
import onlineSchool.model.specification.UserSpecification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.*;

@Service
public class UserService {

//    @Autowired
//    PasswordEncoder passwordEncoder;

    @Autowired CourseDao courseDao;
    private UserDao userDao;

    @Autowired
    public UserService(UserDao userDao) {
        this.userDao = userDao;
    }

    public void register(User user) throws DuplicateUserException {
        Optional<User> found = userDao.findByEmail(user.getEmail());
        if (!found.isPresent()) {
//            user.setPassword(passwordEncoder.encode(user.getPassword()));
            userDao.save(user);
        } else throw new DuplicateUserException();
    }

    public void remove(User user) {
        userDao.delete(user);
    }

    public User login(User userLogin) throws NotAvailableUserException, PasswordException {
        User user;
        Optional<User> foundUser = userDao.findByEmail(userLogin.getEmail());
        if (foundUser.isPresent()) user = foundUser.get();
        else throw new NotAvailableUserException("invalid email");
        String userLoginPassword = userLogin.getPassword();
        String userPassword = user.getPassword();
        if (!Objects.equals(userLoginPassword, userPassword))
            throw new PasswordException("incorrect password");
        return user;
    }

    public void confirmEmailAddress(User user) {
        Status status = new Status();
        status.setId(2);
        user.setStatus(status);
        userDao.update(user.getEmail(), user.getStatus());
    }

    public List<User> getFilteredUsers(int pageNumber, User user) {
        Pageable pageable = PageRequest.of(pageNumber, 5);
        Page<User> users = userDao.findAll(UserSpecification.findMaxMatch(user), pageable);
        return users.getContent();
    }

    public List<User> getCourseStudents(int pageNumber, Course course){
        Role role = new Role();
        role.setId(2);
        role.setName(RoleEnum.student.toString());
        User user = new User();
        user.setRole(role);
        Set<Course> courses = new HashSet<>();
        courses.add(course);
        user.setCourseSet(courses);
        return getFilteredUsers(pageNumber, user);
//        user.setFirstName("akbar");
//        return Arrays.asList(user);
    }

    public List<User> getAllUsers(int pageNumber) {
        Pageable pageable = PageRequest.of(pageNumber, 5);
        Page<User> users = userDao.findAll(pageable);
        return users.getContent();
    }

    public User getUser(String email){
        Optional<User> byEmail = userDao.findByEmail(email);
        return byEmail.orElse(null);
    }

    public void update(User user) {
        String email = user.getEmail();
        String firstName = user.getFirstName();
        String lastName = user.getLastName();
        String password = user.getPassword();
        Role role = user.getRole();
        Status status = user.getStatus();
        if (!StringUtils.isEmpty(firstName))
            userDao.updateFirstName(email, firstName);
        if (!StringUtils.isEmpty(lastName))
            userDao.updateLastName(email, lastName);
        if (!StringUtils.isEmpty(password))
            userDao.updatePassword(email, password);
        if (!StringUtils.isEmpty(status.getName())) {
            if (Objects.equals(status.getName(), "email confirm waiting..."))
                status.setId(1);
            if (Objects.equals(status.getName(), "admin accept waiting..."))
                status.setId(2);
            userDao.update(email, status);
        }
        if (!StringUtils.isEmpty(user.getRole().getName())){
            if (Objects.equals(role.getName(), "master"))
                role.setId(1);
            if (Objects.equals(role.getName(), "student"))
                role.setId(2);
//            userDao.update(email, role);
        }
    }
}
