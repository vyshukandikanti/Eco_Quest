<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="firstphase.Mission" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
    List<Mission> missionsList = (List<Mission>) request.getAttribute("missionsList");
    Set<Integer> attemptedMissionIds = (Set<Integer>) request.getAttribute("attemptedMissionIds");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (selectedCategory == null) selectedCategory = "All";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sustainability Missions - EcoQuest</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="DashboardServlet" class="nav-brand">
            <span class="brand-leaf">&#127793;</span> EcoQuest
        </a>
        <ul class="nav-links">
            <li><a href="DashboardServlet">My Dashboard</a></li>
            <li><a href="MissionServlet" class="active">Challenges</a></li>
            <li><a href="LeaderboardServlet">Leaderboard</a></li>
            <li class="user-badge">&#128100; <%= username %></li>
            <li><a href="LogoutServlet" style="color: #b91c1c;">Sign Out</a></li>
        </ul>
    </nav>

    <div class="container">
        <div style="margin-bottom: 2rem;">
            <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--text-main);">Environmental Challenges</h1>
            <p style="color: var(--text-muted); font-size: 1rem;">Select a category, examine the environmental scenario, and choose the correct sustainable action.</p>
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

        <!-- Filter bar -->
        <div class="category-filter-bar">
            <a href="MissionServlet?category=All" class="filter-btn <%= "All".equals(selectedCategory) ? "active" : "" %>">All Categories</a>
            <a href="MissionServlet?category=Waste Management" class="filter-btn <%= "Waste Management".equals(selectedCategory) ? "active" : "" %>">Waste Management</a>
            <a href="MissionServlet?category=Energy Conservation" class="filter-btn <%= "Energy Conservation".equals(selectedCategory) ? "active" : "" %>">Energy Conservation</a>
            <a href="MissionServlet?category=Water Conservation" class="filter-btn <%= "Water Conservation".equals(selectedCategory) ? "active" : "" %>">Water Conservation</a>
            <a href="MissionServlet?category=Eco Living" class="filter-btn <%= "Eco Living".equals(selectedCategory) ? "active" : "" %>">Eco Living</a>
        </div>

        <!-- Missions List -->
        <%
            if (missionsList != null && !missionsList.isEmpty()) {
                for (Mission m : missionsList) {
                    boolean isAttempted = attemptedMissionIds != null && attemptedMissionIds.contains(m.getId());

                    String diffClass = "badge-easy";
                    if ("Medium".equalsIgnoreCase(m.getDifficulty())) diffClass = "badge-medium";
                    if ("Hard".equalsIgnoreCase(m.getDifficulty())) diffClass = "badge-hard";
        %>
            <div class="mission-card <%= isAttempted ? "completed" : "" %>">
                <div class="mission-header">
                    <div>
                        <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.4rem;">
                            <span class="badge" style="background: var(--bg-subtle); color: var(--text-muted);"><%= m.getCategory() %></span>
                            <span class="badge <%= diffClass %>"><%= m.getDifficulty() %></span>
                            <span class="badge badge-points">+<%= m.getXpReward() %> XP</span>
                        </div>
                        <h3 class="mission-title"><%= m.getTitle() %></h3>
                    </div>

                    <% if (isAttempted) { %>
                        <span class="badge" style="background: #e2e8f0; color: #475569; padding: 0.4rem 0.8rem;">
                            &#10003; Attempted
                        </span>
                    <% } %>
                </div>

                <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 1.25rem;">
                    <%= m.getDescription() %>
                </p>

                <% if (!isAttempted) { %>
                    <form action="SubmitAnswerServlet" method="POST">
                        <input type="hidden" name="missionId" value="<%= m.getId() %>">

                        <div class="mission-options">
                            <label class="option-label">
                                <input type="radio" name="selectedAnswer" value="A" required>
                                <span><strong>A:</strong> <%= m.getOptionA() %></span>
                            </label>

                            <label class="option-label">
                                <input type="radio" name="selectedAnswer" value="B">
                                <span><strong>B:</strong> <%= m.getOptionB() %></span>
                            </label>

                            <label class="option-label">
                                <input type="radio" name="selectedAnswer" value="C">
                                <span><strong>C:</strong> <%= m.getOptionC() %></span>
                            </label>

                            <label class="option-label">
                                <input type="radio" name="selectedAnswer" value="D">
                                <span><strong>D:</strong> <%= m.getOptionD() %></span>
                            </label>
                        </div>

                        <div style="display: flex; justify-content: flex-end;">
                            <button type="submit" class="btn btn-primary">
                                Submit Solution &rarr;
                            </button>
                        </div>
                    </form>
                <% } else { %>
                    <div style="font-size: 0.9rem; color: var(--text-light); font-style: italic;">
                        You have already completed your one attempt for this mission.
                    </div>
                <% } %>
            </div>
        <%
                }
            } else {
        %>
            <div class="card" style="text-align: center; padding: 3rem;">
                <p style="color: var(--text-muted); font-size: 1.05rem;">No missions found in this category.</p>
                <a href="MissionServlet?category=All" class="btn btn-secondary" style="margin-top: 1rem;">View All Missions</a>
            </div>
        <%
            }
        %>
    </div>

    <footer class="footer">
        <p>&copy; 2026 EcoQuest Sustainability Challenge Platform.</p>
    </footer>

</body>
</html>
