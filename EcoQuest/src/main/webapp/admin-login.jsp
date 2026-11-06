<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Portal - EcoQuest</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="index.html" class="nav-brand">
            <span class="brand-leaf">&#127793;</span> EcoQuest <span style="font-size: 0.8rem; background: var(--bg-subtle); padding: 0.2rem 0.5rem; border-radius: 4px; margin-left: 0.4rem; color: var(--text-muted);">Admin</span>
        </a>
        <ul class="nav-links">
            <li><a href="index.html">Back to Home</a></li>
            <li><a href="login.jsp">User Login</a></li>
        </ul>
    </nav>

    <div class="container">
        <div class="auth-card">
            <div class="auth-header">
                <div style="font-size: 2.2rem; margin-bottom: 0.5rem;">&#128272;</div>
                <h2>Administrator Sign In</h2>
                <p>Manage sustainability missions and system data</p>
            </div>

            <%
                String error = (String) request.getAttribute("error");
                String msg = request.getParameter("msg");
                if (error != null) {
            %>
                <div class="alert alert-danger">
                    <span>&#9888;</span> <%= error %>
                </div>
            <%
                }
                if ("logged_out".equals(msg)) {
            %>
                <div class="alert alert-success">
                    <span>&#10003;</span> Administrator session ended successfully.
                </div>
            <%
                }
            %>

            <form action="AdminLoginServlet" method="POST">
                <div class="form-group">
                    <label class="form-label" for="username">Admin Username</label>
                    <input type="text" id="username" name="username" class="form-control" placeholder="Default: admin" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Admin Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Default: admin123" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 1rem;">
                    Access Dashboard
                </button>
            </form>

            <div style="margin-top: 1.5rem; padding: 0.75rem; background: var(--bg-subtle); border-radius: var(--radius-sm); font-size: 0.82rem; color: var(--text-muted); text-align: center;">
                Default seeded credentials: <strong>admin</strong> / <strong>admin123</strong>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 EcoQuest Sustainability Challenge Platform &bull; Administrative Console</p>
    </footer>

</body>
</html>
