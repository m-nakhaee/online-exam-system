package onlineSchool.service;

import onlineSchool.model.dao.QuestionDao;
import onlineSchool.model.entity.mainEntities.Question;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class QuestionService {
    @Autowired
    QuestionDao questionDao;
    public void save(Question question){
        questionDao.save(question);
    }
}
