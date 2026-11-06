<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="firstphase.LeaderboardUser" %>
<%
    List<LeaderboardUser> leaderboard = (List<LeaderboardUser>) request.getAttribute("leaderboard");
    String currentUsername = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Global Leaderboard - EcoQuest</title>
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
            <li><a href="LeaderboardServlet" class="active">Leaderboard</a></li>
            <% if (currentUsername != null) { %>
                <li><a href="DashboardServlet">My Dashboard</a></li>
                <li class="user-badge">&#128100; <%= currentUsername %></li>
                <li><a href="LogoutServlet" style="color: #b91c1c;">Sign Out</a></li>
            <% } else { %>
                <li><a href="login.jsp">Log In</a></li>
                <li><a href="register.jsp" class="btn-nav-primary">Join Free</a></li>
            <% } %>
        </ul>
    </nav>

    <div class="container">
        <div style="text-align: center; margin-bottom: 3rem;">
            <div class="hero-pill">&#127942; Top Environmental Champions</div>
            <h1 style="font-size: 2.5rem; font-weight: 800; color: var(--text-main); margin-bottom: 0.5rem;">Global Eco-Warrior Leaderboard</h1>
            <p style="color: var(--text-muted); font-size: 1rem; max-width: 600px; margin: 0 auto;">
                Live community rankings based on total verified Eco-Points (EP) and completed conservation missions.
            </p>
        </div>

        <div class="table-responsive">
            <table class="custom-table">
                <thead>
                    <tr>
                        <th style="width: 80px; text-align: center;">Rank</th>
                        <th>Eco-Warrior</th>
                        <th>Level Tier</th>
                        <th>Missions Solved</th>
                        <th style="text-align: right;">Total Eco-Points</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (leaderboard != null && !leaderboard.isEmpty()) {
                            for (LeaderboardUser player : leaderboard) {
                                String rankClass = "rank-normal";
                                String medalIcon = "";
                                if (player.getRank() == 1) {
                                    rankClass = "podium-rank rank-1";
                                    medalIcon = "&#129351; ";
                                } else if (player.getRank() == 2) {
                                    rankClass = "podium-rank rank-2";
                                    medalIcon = "&#129352; ";
                                } else if (player.getRank() == 3) {
                                    rankClass = "podium-rank rank-3";
                                    medalIcon = "&#129353; ";
                                }

                                boolean isCurrentUser = currentUsername != null && currentUsername.equalsIgnoreCase(player.getUsername());
                    %>
                        <tr style="<%= isCurrentUser ? "background-color: #ecfdf5; font-weight: 600;" : "" %>">
                            <td style="text-align: center;">
                                <span class="<%= rankClass %>">
                                    <%= player.getRank() %>
                                </span>
                            </td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 0.5rem;">
                                    <span><%= medalIcon %></span>
                                    <strong style="color: var(--text-main);"><%= player.getUsername() %></strong>
                                    <% if (isCurrentUser) { %>
                                        <span class="badge" style="background: var(--primary); color: #fff; font-size: 0.7rem;">YOU</span>
                                    <% } %>
                                </div>
                            </td>
                            <td>
                                <span class="badge" style="background: var(--bg-subtle); color: var(--text-muted); border: 1px solid var(--border-color);">
                                    Level <%= player.getLevel() %>
                                </span>
                            </td>
                            <td style="color: var(--text-muted); font-weight: 600;">
                                <%= player.getCompletedMissions() %> completed
                            </td>
                            <td style="text-align: right;">
                                <span style="font-size: 1.15rem; font-weight: 800; color: var(--primary);">
                                    <%= player.getEcoPoints() %> <span style="font-size: 0.8rem; font-weight: 600;">EP</span>
                                </span>
                            </td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 3rem; color: var(--text-muted);">
                                No participants on the leaderboard yet. Be the first to register and complete a mission!
                            </td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 EcoQuest Sustainability Challenge Platform &bull; Real-time Leaderboard</p>
    </footer>

</body>
</html>
