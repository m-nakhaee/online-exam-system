package onlineSchool.service;

import onlineSchool.model.dao.StatusDao;
import onlineSchool.model.entity.helpEntities.Status;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StatusService {
    @Autowired
    StatusDao statusDao;

    public List<Status> getAllStatus() {
        return statusDao.findAll();
    }
}
