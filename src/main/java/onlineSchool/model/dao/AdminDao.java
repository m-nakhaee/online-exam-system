package onlineSchool.model.dao;

import onlineSchool.model.entity.mainEntities.Admin;
import org.springframework.data.jpa.repository.JpaRepository;

@org.springframework.stereotype.Repository
public interface AdminDao extends JpaRepository<Admin, Integer> {

}