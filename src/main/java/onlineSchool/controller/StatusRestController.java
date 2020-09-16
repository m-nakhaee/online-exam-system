package onlineSchool.controller;

import onlineSchool.model.entity.helpEntities.Status;
import onlineSchool.service.StatusService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class StatusRestController {
    @Autowired
    StatusService statusService;

    @GetMapping(value = "/getAllStatus")
    public List<Status> getAllStatus() {
        return statusService.getAllStatus();
    }

}
