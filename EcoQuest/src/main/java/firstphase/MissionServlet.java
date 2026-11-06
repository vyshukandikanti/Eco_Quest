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
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/MissionServlet")
public class MissionServlet extends HttpServlet {

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
        String categoryFilter = request.getParameter("category");

        List<Mission> missionsList = new ArrayList<>();
        Set<Integer> attemptedMissionIds = new HashSet<>();

        String submissionsSql = "SELECT mission_id FROM mission_submissions WHERE user_id = ?";
        String missionsSql = "SELECT id, title, description, category, difficulty, option_a, option_b, option_c, option_d, xp_reward FROM missions ";

        if (categoryFilter != null && !categoryFilter.trim().isEmpty() && !categoryFilter.equalsIgnoreCase("All")) {
            missionsSql += "WHERE category = ? ORDER BY difficulty ASC, id ASC";
        } else {
            missionsSql += "ORDER BY category ASC, id ASC";
        }

        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement subPs = con.prepareStatement(submissionsSql)) {
                subPs.setInt(1, userId);
                try (ResultSet subRs = subPs.executeQuery()) {
                    while (subRs.next()) {
                        attemptedMissionIds.add(subRs.getInt("mission_id"));
                    }
                }
            }

            try (PreparedStatement mPs = con.prepareStatement(missionsSql)) {
                if (categoryFilter != null && !categoryFilter.trim().isEmpty() && !categoryFilter.equalsIgnoreCase("All")) {
                    mPs.setString(1, categoryFilter.trim());
                }

                try (ResultSet rs = mPs.executeQuery()) {
                    while (rs.next()) {
                        Mission m = new Mission();
                        m.setId(rs.getInt("id"));
                        m.setTitle(rs.getString("title"));
                        m.setDescription(rs.getString("description"));
                        m.setCategory(rs.getString("category"));
                        m.setDifficulty(rs.getString("difficulty"));
                        m.setOptionA(rs.getString("option_a"));
                        m.setOptionB(rs.getString("option_b"));
                        m.setOptionC(rs.getString("option_c"));
                        m.setOptionD(rs.getString("option_d"));
                        m.setXpReward(rs.getInt("xp_reward"));

                        missionsList.add(m);
                    }
                }
            }

            request.setAttribute("missionsList", missionsList);
            request.setAttribute("attemptedMissionIds", attemptedMissionIds);
            request.setAttribute("selectedCategory", categoryFilter != null ? categoryFilter : "All");

            request.getRequestDispatcher("missions.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error loading missions: " + e.getMessage());
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }
}
