package firstphase;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/LeaderboardServlet")
public class LeaderboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<LeaderboardUser> leaderboard = new ArrayList<>();

        String sql = "SELECT u.id, u.username, u.player_level, u.total_xp, "
                   + "COUNT(CASE WHEN ms.is_correct = 1 THEN 1 END) AS completed_count "
                   + "FROM users u "
                   + "LEFT JOIN mission_submissions ms ON u.id = ms.user_id "
                   + "GROUP BY u.id, u.username, u.player_level, u.total_xp "
                   + "ORDER BY u.total_xp DESC, completed_count DESC, u.id ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            int currentRank = 1;
            while (rs.next()) {
                LeaderboardUser player = new LeaderboardUser();
                player.setRank(currentRank++);
                player.setUsername(rs.getString("username"));
                player.setLevel(rs.getInt("player_level"));
                player.setEcoPoints(rs.getInt("total_xp"));
                player.setCompletedMissions(rs.getInt("completed_count"));

                leaderboard.add(player);
            }

            request.setAttribute("leaderboard", leaderboard);
            request.getRequestDispatcher("leaderboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error loading leaderboard: " + e.getMessage());
            request.getRequestDispatcher("index.html").forward(request, response);
        }
    }
}
