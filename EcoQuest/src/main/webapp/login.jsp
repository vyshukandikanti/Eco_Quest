<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.Cookie" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log In - EcoQuest</title>
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
            <li><a href="admin-login.jsp">Admin Portal</a></li>
            <li><a href="register.jsp" class="btn-nav-primary">Join Free</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="auth-card">
            <div class="auth-header">
                <h2>Welcome Back</h2>
                <p>Sign in to resume your sustainability quests</p>
            </div>

            <%
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
                String msg = request.getParameter("msg");

                if (error != null) {
            %>
                <div class="alert alert-danger">
                    <span>&#9888;</span> <%= error %>
                </div>
            <%
                }
                if (success != null) {
            %>
                <div class="alert alert-success">
                    <span>&#10003;</span> <%= success %>
                </div>
            <%
                }
                if ("logged_out".equals(msg)) {
            %>
                <div class="alert alert-success">
                    <span>&#10003;</span> You have been securely logged out.
                </div>
            <%
                }

                // Check for remembered user cookie
                String rememberedUser = "";
                Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (Cookie c : cookies) {
                        if ("lastEcoUser".equals(c.getName())) {
                            rememberedUser = c.getValue();
                            break;
                        }
                    }
                }
            %>

            <form action="LoginServlet" method="POST">
                <div class="form-group">
                    <label class="form-label" for="identifier">Username or Email</label>
                    <input type="text" id="identifier" name="identifier" class="form-control" 
                           value="<%= rememberedUser %>" placeholder="Enter username or email" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 1rem;">
                    Sign In to EcoQuest
                </button>
            </form>

            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.9rem; color: var(--text-muted);">
                Don't have an account yet? <a href="register.jsp" style="color: var(--primary); font-weight: 600; text-decoration: none;">Create one here</a>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 EcoQuest Sustainability Challenge Platform.</p>
    </footer>

</body>
</html>
