package onlineSchool.model.dao;

import onlineSchool.model.entity.helpEntities.Status;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StatusDao extends JpaRepository<Status, Integer> {

}

