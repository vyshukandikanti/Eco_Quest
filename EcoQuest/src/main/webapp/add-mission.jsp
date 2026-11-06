<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Integer adminId = (Integer) session.getAttribute("adminId");
    if (adminId == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Sustainability Mission - EcoQuest Admin</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="admin-dashboard.jsp" class="nav-brand">
            <span class="brand-leaf">&#127793;</span> EcoQuest Admin
        </a>
        <ul class="nav-links">
            <li><a href="admin-dashboard.jsp">Dashboard</a></li>
            <li><a href="ViewMissionsServlet">All Missions</a></li>
            <li><a href="add-mission.jsp" class="active">+ New Mission</a></li>
            <li><a href="AdminLogoutServlet" style="color: #b91c1c;">Sign Out</a></li>
        </ul>
    </nav>

    <div class="container" style="max-width: 800px;">
        <div class="card">
            <div style="margin-bottom: 2rem;">
                <h2 style="font-size: 1.75rem; font-weight: 800; color: var(--text-main);">Add New Sustainability Mission</h2>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Configure the question, options, answer key, and XP reward.</p>
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

            <form action="AddMissionServlet" method="POST">
                <div class="form-group">
                    <label class="form-label" for="title">Mission Title</label>
                    <input type="text" id="title" name="title" class="form-control" placeholder="e.g. Household Water Conservation" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="description">Scenario / Question Description</label>
                    <textarea id="description" name="description" rows="3" class="form-textarea" placeholder="Detail the practical sustainability problem or concept..." required></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="category">Category</label>
                        <select id="category" name="category" class="form-select" required>
                            <option value="Energy Conservation">Energy Conservation</option>
                            <option value="Waste Management">Waste Management</option>
                            <option value="Water Conservation">Water Conservation</option>
                            <option value="Eco Living">Eco Living</option>
                            <option value="Biodiversity">Biodiversity</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="difficulty">Difficulty Level</label>
                        <select id="difficulty" name="difficulty" class="form-select" required>
                            <option value="Easy">Easy (50 XP)</option>
                            <option value="Medium">Medium (100 XP)</option>
                            <option value="Hard">Hard (150 XP)</option>
                        </select>
                    </div>
                </div>

                <div style="margin: 1.5rem 0 1rem; border-top: 1px solid var(--border-color); padding-top: 1.5rem;">
                    <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 1rem;">Answer Choices</h3>

                    <div class="form-group">
                        <label class="form-label" for="optionA">Option A</label>
                        <input type="text" id="optionA" name="optionA" class="form-control" placeholder="Answer option A" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="optionB">Option B</label>
                        <input type="text" id="optionB" name="optionB" class="form-control" placeholder="Answer option B" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="optionC">Option C</label>
                        <input type="text" id="optionC" name="optionC" class="form-control" placeholder="Answer option C" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="optionD">Option D</label>
                        <input type="text" id="optionD" name="optionD" class="form-control" placeholder="Answer option D" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="correctAnswer">Correct Answer</label>
                        <select id="correctAnswer" name="correctAnswer" class="form-select" required>
                            <option value="A">Option A</option>
                            <option value="B">Option B</option>
                            <option value="C">Option C</option>
                            <option value="D">Option D</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="xpReward">XP Reward</label>
                        <input type="number" id="xpReward" name="xpReward" class="form-control" value="50" min="10" step="10" required>
                    </div>
                </div>

                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                    <button type="submit" class="btn btn-primary" style="flex: 1;">
                        &#10004; Save & Publish Mission
                    </button>
                    <a href="admin-dashboard.jsp" class="btn btn-secondary">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 EcoQuest Sustainability Challenge Platform &bull; Admin Console</p>
    </footer>

</body>
</html>
