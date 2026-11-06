<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");

    String missionTitle = (String) request.getAttribute("missionTitle");
    Boolean isCorrect = (Boolean) request.getAttribute("isCorrect");
    Integer pointsEarned = (Integer) request.getAttribute("pointsEarned");
    String selectedAnswer = (String) request.getAttribute("selectedAnswer");
    String correctAnswer = (String) request.getAttribute("correctAnswer");
    Boolean leveledUp = (Boolean) request.getAttribute("leveledUp");
    Integer newLevel = (Integer) request.getAttribute("newLevel");

    if (isCorrect == null) isCorrect = false;
    if (pointsEarned == null) pointsEarned = 0;
    if (leveledUp == null) leveledUp = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mission Result - EcoQuest</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="DashboardServlet" class="nav-brand">
            <span class="brand-leaf">&#127793;</span> EcoQuest
        </a>
        <ul class="nav-links">
            <li><a href="DashboardServlet">My Dashboard</a></li>
            <li><a href="MissionServlet">Challenges</a></li>
            <li><a href="LeaderboardServlet">Leaderboard</a></li>
            <li class="user-badge">&#128100; <%= username %></li>
            <li><a href="LogoutServlet" style="color: #b91c1c;">Sign Out</a></li>
        </ul>
    </nav>

    <div class="container" style="max-width: 650px;">
        <div class="card" style="text-align: center; padding: 3rem 2rem;">
            <% if (isCorrect) { %>
                <div style="font-size: 3.5rem; margin-bottom: 1rem;">&#127881;</div>
                <span class="badge" style="background: #dcfce7; color: #15803d; font-size: 0.85rem; padding: 0.4rem 1rem; margin-bottom: 1rem;">
                    Mission Accomplished
                </span>
                <h1 style="font-size: 2rem; font-weight: 800; color: var(--text-main); margin-bottom: 0.5rem;">Outstanding Work!</h1>
                <p style="color: var(--text-muted); font-size: 1.05rem; margin-bottom: 1.5rem;">
                    Your solution for <strong>"<%= missionTitle != null ? missionTitle : "Sustainability Challenge" %>"</strong> is completely accurate.
                </p>

                <div style="background: var(--bg-subtle); border-radius: var(--radius-lg); padding: 1.5rem; margin-bottom: 2rem; display: inline-flex; align-items: center; gap: 1rem;">
                    <div style="font-size: 2rem;">&#127793;</div>
                    <div style="text-align: left;">
                        <div style="font-size: 0.85rem; color: var(--text-muted); font-weight: 600; text-transform: uppercase;">Points Awarded</div>
                        <div style="font-size: 1.75rem; font-weight: 800; color: var(--primary);">+<%= pointsEarned %> XP</div>
                    </div>
                </div>

                <% if (leveledUp) { %>
                    <div class="alert alert-success" style="justify-content: center; font-size: 1.05rem; font-weight: 700; margin-bottom: 2rem;">
                        <span>&#11088;</span> LEVEL UP! You reached Level <%= newLevel %>!
                    </div>
                <% } %>

            <% } else { %>
                <div style="font-size: 3.5rem; margin-bottom: 1rem;">&#128532;</div>
                <span class="badge" style="background: #fee2e2; color: #b91c1c; font-size: 0.85rem; padding: 0.4rem 1rem; margin-bottom: 1rem;">
                    Incorrect Solution
                </span>
                <h1 style="font-size: 2rem; font-weight: 800; color: var(--text-main); margin-bottom: 0.5rem;">Not Quite Right</h1>
                <p style="color: var(--text-muted); font-size: 1.05rem; margin-bottom: 1.5rem;">
                    You selected Option <strong><%= selectedAnswer %></strong>. The correct sustainable choice was Option <strong><%= correctAnswer %></strong>.
                </p>
                <div style="background: #fff1f2; border: 1px solid #fecdd3; border-radius: var(--radius-md); padding: 1rem; color: #9f1239; margin-bottom: 2rem; font-size: 0.95rem;">
                    No XP was awarded for this attempt. Keep learning eco best practices!
                </div>
            <% } %>

            <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                <a href="MissionServlet" class="btn btn-primary">
                    Continue to Next Challenge &rarr;
                </a>
                <a href="DashboardServlet" class="btn btn-secondary">
                    View My Progress
                </a>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 EcoQuest Sustainability Challenge Platform.</p>
    </footer>

</body>
</html>
