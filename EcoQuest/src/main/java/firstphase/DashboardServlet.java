package firstphase;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String userSql = "SELECT username, total_xp, player_level FROM users WHERE id = ?";
        String completedSql = "SELECT COUNT(*) FROM mission_submissions WHERE user_id = ? AND is_correct = 1";
        String totalSubmissionsSql = "SELECT COUNT(*) FROM mission_submissions WHERE user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement userPs = con.prepareStatement(userSql);
             PreparedStatement completedPs = con.prepareStatement(completedSql);
             PreparedStatement totalPs = con.prepareStatement(totalSubmissionsSql)) {

            userPs.setInt(1, userId);
            String username = "";
            int totalXp = 0;
            int playerLevel = 1;

            try (ResultSet rs = userPs.executeQuery()) {
                if (rs.next()) {
                    username = rs.getString("username");
                    totalXp = rs.getInt("total_xp");
                    playerLevel = rs.getInt("player_level");
                }
            }

            int completedMissions = 0;
            completedPs.setInt(1, userId);
            try (ResultSet rs = completedPs.executeQuery()) {
                if (rs.next()) {
                    completedMissions = rs.getInt(1);
                }
            }

            int totalAttempted = 0;
            totalPs.setInt(1, userId);
            try (ResultSet rs = totalPs.executeQuery()) {
                if (rs.next()) {
                    totalAttempted = rs.getInt(1);
                }
            }

            // Progression calculation
            int pointsForNextLevel = playerLevel * 100;
            int currentLevelFloor = (playerLevel - 1) * 100;
            int progressPercent = 0;
            if (pointsForNextLevel > currentLevelFloor) {
                progressPercent = (int) (((double) (totalXp - currentLevelFloor) / (pointsForNextLevel - currentLevelFloor)) * 100);
                if (progressPercent > 100) progressPercent = 100;
                if (progressPercent < 0) progressPercent = 0;
            }

            session.setAttribute("username", username);
            session.setAttribute("ecoPoints", totalXp);
            session.setAttribute("level", playerLevel);

            request.setAttribute("username", username);
            request.setAttribute("ecoPoints", totalXp);
            request.setAttribute("level", playerLevel);
            request.setAttribute("completedMissions", completedMissions);
            request.setAttribute("totalAttempted", totalAttempted);
            request.setAttribute("pointsForNextLevel", pointsForNextLevel);
            request.setAttribute("progressPercent", progressPercent);

            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
