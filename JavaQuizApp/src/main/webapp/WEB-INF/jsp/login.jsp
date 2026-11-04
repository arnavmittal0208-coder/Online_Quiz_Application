<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - SkillForge LMS</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .auth-container {
            max-width: 380px;
            margin: 3.5rem auto;
            background: var(--white);
            padding: 1.75rem 2rem;
            border-radius: var(--radius-sm);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
        }
        .auth-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }
        .auth-header h2 {
            font-size: 1.35rem;
            color: var(--dark);
            margin-bottom: 0.25rem;
            font-weight: 700;
        }
        .auth-header p {
            color: var(--gray);
            font-size: 0.82rem;
        }
        .demo-box {
            background: var(--gray-light);
            border: 1px solid var(--border);
            border-radius: var(--radius-xs);
            padding: 0.75rem;
            margin-top: 1.25rem;
            font-size: 0.76rem;
        }
        .demo-box strong {
            display: block;
            margin-bottom: 0.3rem;
            color: var(--dark);
        }
        .demo-box code {
            background: #e2e8f0;
            padding: 1px 5px;
            border-radius: 3px;
            font-family: monospace;
        }
    </style>
</head>
<body>

    <div class="auth-container">
        <div class="auth-header">
            <div style="width: 36px; height: 36px; background: var(--primary); color: white; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; font-size: 1.1rem; margin-bottom: 0.5rem;">Q</div>
            <h2>SkillForge LMS</h2>
            <p>Institutional Examination & Quiz Portal</p>
        </div>

        <% String error = (String) request.getAttribute("error");
           if (error == null) error = request.getParameter("error");
           if (error != null && !error.isEmpty()) { %>
            <div class="alert alert-danger" style="padding: 0.5rem 0.75rem; font-size: 0.8rem;"><%= error %></div>
        <% } %>

        <% String msg = request.getParameter("msg");
           if (msg != null && !msg.isEmpty()) { %>
            <div class="alert alert-success" style="padding: 0.5rem 0.75rem; font-size: 0.8rem;"><%= msg %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control" placeholder="Enter username" required autofocus>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Enter password" required>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 0.35rem;">Sign In to Portal</button>
        </form>

        <p style="text-align: center; margin-top: 1.15rem; font-size: 0.82rem; color: var(--gray);">
            New student? <a href="<%= request.getContextPath() %>/register" style="color: var(--primary); font-weight: 600; text-decoration: none;">Enroll Here</a>
        </p>

        <div class="demo-box">
            <strong>Pre-configured Accounts:</strong>
            <div>Instructor: <code>admin</code> / <code>admin123</code></div>
            <div style="margin-top: 2px;">Student: <code>student1</code> / <code>student123</code></div>
        </div>
    </div>

</body>
</html>
