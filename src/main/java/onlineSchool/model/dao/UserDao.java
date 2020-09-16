package onlineSchool.model.dao;

import onlineSchool.model.entity.helpEntities.Role;
import onlineSchool.model.entity.helpEntities.Status;
import onlineSchool.model.entity.mainEntities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface UserDao extends JpaRepository<User, Integer>, JpaSpecificationExecutor<User> {

//    @Query("select user from User user, Course course where ")

    Optional<User> findByEmail(String email);

    @Modifying
    @Query("update User set status =:newStatus where email =:email")
    void update(@Param("email") String email, @Param("newStatus") Status newStatus);

    @Modifying
    @Query("update User set role =:newRole where email =:email")
    void update(@Param("email") String email, @Param("newRole") Role newRole);

    @Modifying
    @Query("update User set firstName =:newFirstName where email =:email")
    void updateFirstName(@Param("email") String email, @Param("newFirstName") String newFirstName);

    @Modifying
    @Query("update User set lastName =:newLastName where email =:email")
    void updateLastName(@Param("email") String email, @Param("newLastName") String newLastName);

    @Modifying
    @Query("update User set password =:newPassword where email =:email")
    void updatePassword(@Param("email") String email, @Param("newPassword") String newPassword);

}
