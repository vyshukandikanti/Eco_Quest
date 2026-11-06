<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) request.getAttribute("username");
    if (username == null) username = (String) session.getAttribute("username");

    Integer ecoPoints = (Integer) request.getAttribute("ecoPoints");
    if (ecoPoints == null) ecoPoints = 0;

    Integer level = (Integer) request.getAttribute("level");
    if (level == null) level = 1;

    Integer completedMissions = (Integer) request.getAttribute("completedMissions");
    if (completedMissions == null) completedMissions = 0;

    Integer totalAttempted = (Integer) request.getAttribute("totalAttempted");
    if (totalAttempted == null) totalAttempted = 0;

    Integer pointsForNextLevel = (Integer) request.getAttribute("pointsForNextLevel");
    if (pointsForNextLevel == null) pointsForNextLevel = 100;

    Integer progressPercent = (Integer) request.getAttribute("progressPercent");
    if (progressPercent == null) progressPercent = 0;

    String rankTitle = "Seedling Eco-Warrior";
    if (level == 2) rankTitle = "Sprout Environmentalist";
    else if (level == 3) rankTitle = "Eco-Guardian";
    else if (level >= 4) rankTitle = "Earth Champion";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eco Dashboard - <%= username %></title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="DashboardServlet" class="nav-brand">
            <span class="brand-leaf">&#127793;</span> EcoQuest
        </a>
        <ul class="nav-links">
            <li><a href="DashboardServlet" class="active">My Dashboard</a></li>
            <li><a href="MissionServlet">Challenges</a></li>
            <li><a href="LeaderboardServlet">Leaderboard</a></li>
            <li class="user-badge">&#128100; <%= username %> &bull; Lv.<%= level %></li>
            <li><a href="LogoutServlet" style="color: #b91c1c;">Sign Out</a></li>
        </ul>
    </nav>

    <div class="container">
        <div style="margin-bottom: 2rem;">
            <span class="badge" style="background: var(--primary-light); color: var(--primary); margin-bottom: 0.5rem;"><%= rankTitle %></span>
            <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--text-main);">Welcome, <%= username %>!</h1>
            <p style="color: var(--text-muted); font-size: 1rem;">Track your sustainability progress, level milestones, and daily completed missions.</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-label">Total Eco-Points</span>
                <span class="stat-val" style="color: var(--primary);"><%= ecoPoints %> <span style="font-size: 1.1rem; font-weight: 600;">EP</span></span>
                <span class="stat-sub">Lifetime earned points</span>
            </div>

            <div class="stat-card">
                <span class="stat-label">Current Tier</span>
                <span class="stat-val">Level <%= level %></span>
                <span class="stat-sub"><%= rankTitle %></span>
            </div>

            <div class="stat-card">
                <span class="stat-label">Completed Missions</span>
                <span class="stat-val"><%= completedMissions %></span>
                <span class="stat-sub">Successfully solved out of <%= totalAttempted %> attempted</span>
            </div>
        </div>

        <!-- Level Progress Card -->
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                <div>
                    <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--text-main);">Level <%= level %> Progression</h3>
                    <p style="color: var(--text-muted); font-size: 0.88rem;">Earn <%= (pointsForNextLevel - ecoPoints) > 0 ? (pointsForNextLevel - ecoPoints) : 0 %> more EP to reach Level <%= level + 1 %></p>
                </div>
                <div style="font-size: 1.25rem; font-weight: 800; color: var(--primary);">
                    <%= progressPercent %>%
                </div>
            </div>

            <div class="progress-bar-bg">
                <div class="progress-bar-fill" style="width: <%= progressPercent %>%;"></div>
            </div>
        </div>

        <!-- Action Grid -->
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
            <div class="card card-hover" style="display: flex; flex-direction: column; justify-content: space-between;">
                <div>
                    <div style="font-size: 2rem; margin-bottom: 0.8rem;">&#127793;</div>
                    <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 0.4rem;">Sustainability Missions</h3>
                    <p style="color: var(--text-muted); font-size: 0.9rem;">
                        Tackle real-world conservation questions across Energy, Waste, and Water to earn EP.
                    </p>
                </div>
                <a href="MissionServlet" class="btn btn-primary" style="margin-top: 1.5rem; align-self: flex-start;">
                    Browse Available Missions &rarr;
                </a>
            </div>

            <div class="card card-hover" style="display: flex; flex-direction: column; justify-content: space-between;">
                <div>
                    <div style="font-size: 2rem; margin-bottom: 0.8rem;">&#127942;</div>
                    <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 0.4rem;">Community Leaderboard</h3>
                    <p style="color: var(--text-muted); font-size: 0.9rem;">
                        See how your Eco-Points stack up against other eco-warriors in the global rankings.
                    </p>
                </div>
                <a href="LeaderboardServlet" class="btn btn-secondary" style="margin-top: 1.5rem; align-self: flex-start;">
                    View Live Standings &rarr;
                </a>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 EcoQuest Sustainability Challenge Platform.</p>
    </footer>

</body>
</html>
