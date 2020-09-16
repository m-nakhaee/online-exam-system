package onlineSchool.model.dao;

import onlineSchool.model.entity.helpEntities.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RoleDao extends JpaRepository<Role,Integer> {

    Role getByName(String roleName);
}

