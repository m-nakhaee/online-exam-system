package onlineSchool.model.dao;

import onlineSchool.model.entity.helpEntities.VerificationCode;
import onlineSchool.model.entity.mainEntities.User;
import org.springframework.data.repository.Repository;

@org.springframework.stereotype.Repository
public interface VerificationCodeDao extends Repository<VerificationCode, Integer> {
    void save(VerificationCode verificationCode);
    VerificationCode getByUser(User user);
}
