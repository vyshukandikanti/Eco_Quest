<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="firstphase.Mission" %>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if (adminId == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    List<Mission> missionsList = (List<Mission>) request.getAttribute("missionsList");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Missions - EcoQuest Admin</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="admin-dashboard.jsp" class="nav-brand">
            <span class="brand-leaf">&#127793;</span> EcoQuest Admin
        </a>
        <ul class="nav-links">
            <li><a href="admin-dashboard.jsp">Dashboard</a></li>
            <li><a href="ViewMissionsServlet" class="active">All Missions</a></li>
            <li><a href="add-mission.jsp">+ New Mission</a></li>
            <li><a href="AdminLogoutServlet" style="color: #b91c1c;">Sign Out</a></li>
        </ul>
    </nav>

    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
            <div>
                <h1 style="font-size: 2rem; font-weight: 800; color: var(--text-main);">Mission Management</h1>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Review all active sustainability challenges stored in MySQL database</p>
            </div>
            <a href="add-mission.jsp" class="btn btn-primary">
                + Create New Mission
            </a>
        </div>

        <%
            if ("created".equals(msg)) {
        %>
            <div class="alert alert-success">
                <span>&#10003;</span> New sustainability mission successfully created and published!
            </div>
        <%
            }
        %>

        <div class="table-responsive">
            <table class="custom-table">
                <thead>
                    <tr>
                        <th style="width: 50px;">#</th>
                        <th>Title & Description</th>
                        <th>Category</th>
                        <th>Difficulty</th>
                        <th>Answer Key</th>
                        <th>Reward</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (missionsList != null && !missionsList.isEmpty()) {
                            for (Mission m : missionsList) {
                                String diffClass = "badge-easy";
                                if ("Medium".equalsIgnoreCase(m.getDifficulty())) diffClass = "badge-medium";
                                if ("Hard".equalsIgnoreCase(m.getDifficulty())) diffClass = "badge-hard";
                    %>
                        <tr>
                            <td style="font-weight: 700; color: var(--text-muted);"><%= m.getId() %></td>
                            <td>
                                <div style="font-weight: 700; color: var(--text-main); font-size: 1rem;"><%= m.getTitle() %></div>
                                <div style="color: var(--text-muted); font-size: 0.85rem; margin-top: 0.2rem;"><%= m.getDescription() %></div>
                            </td>
                            <td>
                                <span class="badge" style="background: var(--bg-subtle); color: var(--text-main); border: 1px solid var(--border-color);"><%= m.getCategory() %></span>
                            </td>
                            <td>
                                <span class="badge <%= diffClass %>"><%= m.getDifficulty() %></span>
                            </td>
                            <td>
                                <span style="font-weight: 800; background: #ecfdf5; color: #047857; padding: 0.25rem 0.6rem; border-radius: 6px; border: 1px solid #a7f3d0;">
                                    Option <%= m.getCorrectAnswer() %>
                                </span>
                            </td>
                            <td>
                                <span class="badge badge-points">+<%= m.getXpReward() %> XP</span>
                            </td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 3rem; color: var(--text-muted);">
                                No missions found in database. Click <strong>+ Create New Mission</strong> to add one.
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
        <p>&copy; 2026 EcoQuest Sustainability Challenge Platform &bull; Admin Console</p>
    </footer>

</body>
</html>
