<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if (adminId == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    String adminUsername = (String) session.getAttribute("adminUsername");
    String adminFullName = (String) session.getAttribute("adminFullName");
    String adminRole = (String) session.getAttribute("adminRole");
    String appName = (String) application.getAttribute("appName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - EcoQuest</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="admin-dashboard.jsp" class="nav-brand">
            <span class="brand-leaf">&#127793;</span> EcoQuest Admin
        </a>
        <ul class="nav-links">
            <li><a href="admin-dashboard.jsp" class="active">Overview</a></li>
            <li><a href="ViewMissionsServlet">Manage Missions</a></li>
            <li><a href="add-mission.jsp">New Mission</a></li>
            <li><a href="LeaderboardServlet" target="_blank">Live Standings</a></li>
            <li class="user-badge">&#128100; <%= adminUsername %></li>
            <li><a href="AdminLogoutServlet" style="color: #b91c1c;">Sign Out</a></li>
        </ul>
    </nav>

    <div class="container">
        <div style="margin-bottom: 2rem;">
            <span class="badge" style="background: var(--primary-light); color: var(--primary); margin-bottom: 0.5rem;"><%= adminRole != null ? adminRole : "Administrator" %></span>
            <h1 style="font-size: 2rem; font-weight: 800; color: var(--text-main);">Welcome, <%= adminFullName != null ? adminFullName : adminUsername %></h1>
            <p style="color: var(--text-muted);"><%= appName != null ? appName : "EcoQuest Platform" %> Management Center</p>
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

        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-label">Administrative Actions</span>
                <span class="stat-val" style="font-size: 1.5rem; margin-top: 0.5rem;">Mission Creator</span>
                <span class="stat-sub">Deploy new sustainability questions</span>
                <a href="add-mission.jsp" class="btn btn-primary" style="margin-top: 1rem; font-size: 0.88rem; padding: 0.5rem 1rem;">
                    + Create Mission
                </a>
            </div>

            <div class="stat-card">
                <span class="stat-label">Mission Inventory</span>
                <span class="stat-val" style="font-size: 1.5rem; margin-top: 0.5rem;">Repository</span>
                <span class="stat-sub">Review active categories & answers</span>
                <a href="ViewMissionsServlet" class="btn btn-secondary" style="margin-top: 1rem; font-size: 0.88rem; padding: 0.5rem 1rem;">
                    View All Missions &rarr;
                </a>
            </div>

            <div class="stat-card">
                <span class="stat-label">Public Standings</span>
                <span class="stat-val" style="font-size: 1.5rem; margin-top: 0.5rem;">Leaderboard</span>
                <span class="stat-sub">Monitor participant eco-score ranks</span>
                <a href="LeaderboardServlet" class="btn btn-secondary" style="margin-top: 1rem; font-size: 0.88rem; padding: 0.5rem 1rem;">
                    Inspect Leaderboard &rarr;
                </a>
            </div>
        </div>

        <div class="card">
            <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.75rem;">System Specifications & Security Policies</h3>
            <ul style="color: var(--text-muted); font-size: 0.92rem; padding-left: 1.5rem; line-height: 1.8;">
                <li><strong>One-Attempt Rule:</strong> Participants are strictly restricted to a single attempt per mission to safeguard points integrity.</li>
                <li><strong>Transaction Safety:</strong> Point rewards and level upgrades execute within atomic JDBC SQL transactions.</li>
                <li><strong>Isolated Admin Session:</strong> User credentials cannot view administrative controls or add questions.</li>
            </ul>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 EcoQuest Sustainability Challenge Platform &bull; Admin Console</p>
    </footer>

</body>
</html>
