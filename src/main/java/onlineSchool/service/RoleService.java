package onlineSchool.service;

import onlineSchool.model.dao.RoleDao;
import onlineSchool.model.entity.helpEntities.Role;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RoleService {
    @Autowired
    RoleDao roleDao;

    public List<Role> getAllRoles() {
        return roleDao.findAll();
    }
}
