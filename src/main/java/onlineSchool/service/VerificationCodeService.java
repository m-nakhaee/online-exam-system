package onlineSchool.service;

import onlineSchool.model.dao.VerificationCodeDao;
import onlineSchool.model.entity.mainEntities.User;
import onlineSchool.model.entity.helpEntities.VerificationCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.UUID;

@Service
public class VerificationCodeService {
    @Autowired
    VerificationCodeDao verificationCodeDao;

    private String createCode() {
        String code = UUID.randomUUID().toString();
        return code;
    }

    public void sendEmail(User user) {
        //Get properties object
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class",
                "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", "465");
        //get Session
        Session session = Session.getDefaultInstance(props,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication("8531nakhaei@gmail.com", "sePdeh135muz!");
                    }
                });
        //compose message
        try {
            MimeMessage message = new MimeMessage(session);             //TODO correct email address
            message.addRecipient(Message.RecipientType.TO, new InternetAddress("8531nakhaei@gmail.com"));
            message.setSubject("test");
//            https://login-app-passport.herokuapp.com/verify/${token}`
            String code = createCode();
            message.setText("http://localhost:8080/verify/"+code);
            //send message
            Transport.send(message);
            VerificationCode verificationCode = new VerificationCode();
            verificationCode.setUser(user);
            verificationCode.setValue(code);
            verificationCodeDao.save(verificationCode);
            System.out.println("message sent successfully");
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }

    }

    public String getCode(User user) {
        VerificationCode verificationCode = verificationCodeDao.getByUser(user);
        return verificationCode.getValue();
    }
}

