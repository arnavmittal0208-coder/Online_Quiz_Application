<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.User" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Enrollment & User Accounts - Admin Portal");
%>
<jsp:include page="header.jsp" />

<div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 1rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
    <div>
        <h1 style="font-size: 1.35rem; font-weight: 700; color: var(--dark); letter-spacing: -0.2px;">
            Enrollment & User Directory
        </h1>
        <p style="color: var(--gray); font-size: 0.82rem; margin-top: 0.15rem;">
            Registered student and faculty administrator accounts stored in <code>users.xml</code>.
        </p>
    </div>
</div>

<div class="card" style="padding: 0; overflow: hidden;">
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th style="width: 60px;">ID</th>
                    <th>Full Name</th>
                    <th>Username</th>
                    <th>Academic Email</th>
                    <th>Institutional Role</th>
                    <th>Registered Date</th>
                    <th style="text-align: right;">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<User> users = (List<User>) request.getAttribute("users");
                    if (users != null && !users.isEmpty()) {
                        for (User u : users) {
                %>
                <tr>
                    <td>#<%= u.getId() %></td>
                    <td><strong><%= u.getFullName() %></strong></td>
                    <td><code><%= u.getUsername() %></code></td>
                    <td><%= u.getEmail() %></td>
                    <td>
                        <% if (u.isAdmin()) { %>
                            <span class="badge badge-primary">Faculty Admin</span>
                        <% } else { %>
                            <span class="badge badge-success">Enrolled Student</span>
                        <% } %>
                    </td>
                    <td><%= u.getCreatedAt() %></td>
                    <td style="text-align: right;">
                        <% if (!u.isAdmin()) { %>
                            <a href="<%= request.getContextPath() %>/admin/user/delete?id=<%= u.getId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Remove account for <%= u.getUsername() %>?');">Delete</a>
                        <% } else { %>
                            <span style="font-size: 0.78rem; color: var(--gray);">Protected</span>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" style="text-align: center; color: var(--gray); padding: 1.5rem;">No user accounts found.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="footer.jsp" />
