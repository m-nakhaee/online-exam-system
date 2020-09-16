package onlineSchool.controller;

import onlineSchool.model.entity.helpEntities.Role;
import onlineSchool.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class RoleRestController {
    @Autowired
    RoleService roleService;

    @GetMapping(value = "/getRoles")
    public List<Role> getRoles() {
        return roleService.getAllRoles();
    }

}
