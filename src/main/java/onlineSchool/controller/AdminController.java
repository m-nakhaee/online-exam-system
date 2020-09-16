package onlineSchool.controller;

import onlineSchool.model.entity.helpEntities.Role;
import onlineSchool.model.entity.helpEntities.Status;
import onlineSchool.service.RoleService;
import onlineSchool.service.StatusService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class AdminController {
    @Autowired
    RoleService roleService;
    @Autowired
    StatusService statusService;

    @GetMapping(value = "/adminPanel")
    public String getAdminPanel(Model model) {
        List<Role> roles = roleService.getAllRoles();
        List<Status> allStatus = statusService.getAllStatus();
        model.addAttribute("roles", roles);
        model.addAttribute("allStatus", allStatus);
        return "panels/adminPanel";
    }
}
