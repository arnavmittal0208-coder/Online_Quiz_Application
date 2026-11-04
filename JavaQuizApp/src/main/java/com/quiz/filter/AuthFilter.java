package com.quiz.filter;

import com.quiz.model.User;
import com.quiz.util.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/student/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();
        User user = session != null ? SessionUtil.getLoggedInUser(session) : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login?error=Please+login+first");
            return;
        }

        // Admin accessing student area or vice versa
        if (uri.contains("/admin/") && !user.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }
        if (uri.contains("/student/") && !user.isStudent()) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        chain.doFilter(request, response);
    }
}

