package onlineSchool.controller;

import onlineSchool.exceptions.CurrentLoginException;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Objects;

public class CheckOTickClass {

    public void checkAnyLogIn(HttpServletRequest request) throws CurrentLoginException {
        HttpSession session = request.getSession();
        Object user = session.getAttribute("user");
        if (user != null) throw new CurrentLoginException("first log out from current account");
    }

    public void checkUserNotLoggedInBefore(String email, ServletContext servletContext) throws CurrentLoginException {
        String users = (String) servletContext.getAttribute("onlineUsers");
        if (users != null)
            if (users.contains(email)) throw new CurrentLoginException("this user is online now");
    }

    public void addToServletContext(String email, ServletContext servletContext) {
        Object contextUsersObject = null;
        String contextUsers = null;
        if (Objects.nonNull(servletContext)) contextUsersObject = servletContext.getAttribute("onlineUsers");
        if (Objects.nonNull(contextUsersObject)) contextUsers = (String) contextUsersObject;
        //String contextUsers = (String) contextUsersObject;
        if (contextUsers != null) {
            contextUsers = contextUsers.concat(", " + email);
            servletContext.setAttribute("onlineUsers", contextUsers);
        } else servletContext.setAttribute("onlineUsers", email);
    }
}
