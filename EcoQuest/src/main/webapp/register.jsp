<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - EcoQuest</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="index.html" class="nav-brand">
            <span class="brand-leaf">&#127793;</span> EcoQuest
        </a>
        <ul class="nav-links">
            <li><a href="index.html">Home</a></li>
            <li><a href="MissionServlet">Challenges</a></li>
            <li><a href="LeaderboardServlet">Leaderboard</a></li>
            <li><a href="login.jsp">Log In</a></li>
            <li><a href="admin-login.jsp">Admin</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="auth-card">
            <div class="auth-header">
                <h2>Create Your Account</h2>
                <p>Join the movement and start earning Eco-Points today</p>
            </div>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="alert alert-danger">
                    <span>&#9888;</span> <%= error %>
                </div>
            <%
                }
            %>

            <form action="RegisterServlet" method="POST">
                <div class="form-group">
                    <label class="form-label" for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control" placeholder="e.g. green_warrior" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="name@example.com" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 1rem;">
                    Register Account
                </button>
            </form>

            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.9rem; color: var(--text-muted);">
                Already have an account? <a href="login.jsp" style="color: var(--primary); font-weight: 600; text-decoration: none;">Log In here</a>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 EcoQuest Sustainability Challenge Platform.</p>
    </footer>

</body>
</html>
