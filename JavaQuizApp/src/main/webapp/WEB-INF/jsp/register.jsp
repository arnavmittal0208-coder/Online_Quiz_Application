<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Enrollment - SkillForge LMS</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .auth-container {
            max-width: 400px;
            margin: 3rem auto;
            background: var(--white);
            padding: 1.75rem 2rem;
            border-radius: var(--radius-sm);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
        }
        .auth-header {
            text-align: center;
            margin-bottom: 1.25rem;
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
    </style>
</head>
<body>

    <div class="auth-container">
        <div class="auth-header">
            <div style="width: 36px; height: 36px; background: var(--primary); color: white; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; font-size: 1.1rem; margin-bottom: 0.5rem;">🎓</div>
            <h2>Student Enrollment</h2>
            <p>Register to access curriculum quizzes and examinations</p>
        </div>

        <% String error = (String) request.getAttribute("error");
           if (error != null && !error.isEmpty()) { %>
            <div class="alert alert-danger" style="padding: 0.5rem 0.75rem; font-size: 0.8rem;"><%= error %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/register" method="post">
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" class="form-control" placeholder="e.g. John Doe" required autofocus>
            </div>

            <div class="form-group">
                <label for="email">Institutional Email</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="name@university.edu" required>
            </div>

            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control" placeholder="Choose a username" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Choose a password" required minlength="4">
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 0.35rem;">Complete Enrollment</button>
        </form>

        <p style="text-align: center; margin-top: 1.15rem; font-size: 0.82rem; color: var(--gray);">
            Already registered? <a href="<%= request.getContextPath() %>/login" style="color: var(--primary); font-weight: 600; text-decoration: none;">Sign In</a>
        </p>
    </div>

</body>
</html>
