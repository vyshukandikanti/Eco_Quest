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

@WebServlet("/SubmitAnswerServlet")
public class SubmitAnswerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String missionIdStr = request.getParameter("missionId");
        String selectedAnswer = request.getParameter("selectedAnswer");

        if (missionIdStr == null || selectedAnswer == null || selectedAnswer.trim().isEmpty()) {
            request.setAttribute("error", "Please select an answer choice before submitting.");
            response.sendRedirect("MissionServlet");
            return;
        }

        int missionId = Integer.parseInt(missionIdStr);
        selectedAnswer = selectedAnswer.trim();

        String checkAttemptSql = "SELECT id FROM mission_submissions WHERE user_id = ? AND mission_id = ?";
        String missionSql = "SELECT title, correct_answer, xp_reward FROM missions WHERE id = ?";
        String insertSubmissionSql = "INSERT INTO mission_submissions (user_id, mission_id, answer, is_correct) VALUES (?, ?, ?, ?)";
        String getUserSql = "SELECT total_xp, player_level FROM users WHERE id = ? FOR UPDATE";
        String updateUserSql = "UPDATE users SET total_xp = ?, player_level = ? WHERE id = ?";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Check one-attempt rule
            try (PreparedStatement checkPs = con.prepareStatement(checkAttemptSql)) {
                checkPs.setInt(1, userId);
                checkPs.setInt(2, missionId);
                try (ResultSet checkRs = checkPs.executeQuery()) {
                    if (checkRs.next()) {
                        con.rollback();
                        request.setAttribute("error", "You have already completed or attempted this mission.");
                        request.getRequestDispatcher("MissionServlet").forward(request, response);
                        return;
                    }
                }
            }

            // 2. Fetch mission details & correct answer
            String missionTitle = "";
            String correctAnswer = "";
            int xpReward = 0;
            try (PreparedStatement mPs = con.prepareStatement(missionSql)) {
                mPs.setInt(1, missionId);
                try (ResultSet rs = mPs.executeQuery()) {
                    if (rs.next()) {
                        missionTitle = rs.getString("title");
                        correctAnswer = rs.getString("correct_answer");
                        xpReward = rs.getInt("xp_reward");
                    } else {
                        con.rollback();
                        response.sendRedirect("MissionServlet");
                        return;
                    }
                }
            }

            boolean isCorrect = selectedAnswer.equalsIgnoreCase(correctAnswer.trim());
            int pointsEarned = isCorrect ? xpReward : 0;

            // 3. Record submission
            try (PreparedStatement insPs = con.prepareStatement(insertSubmissionSql)) {
                insPs.setInt(1, userId);
                insPs.setInt(2, missionId);
                insPs.setString(3, selectedAnswer);
                insPs.setBoolean(4, isCorrect);
                insPs.executeUpdate();
            }

            // 4. Update user points & calculate level if correct
            int currentPoints = 0;
            int currentLevel = 1;
            int newPoints = 0;
            int newLevel = 1;

            if (isCorrect) {
                try (PreparedStatement userPs = con.prepareStatement(getUserSql)) {
                    userPs.setInt(1, userId);
                    try (ResultSet uRs = userPs.executeQuery()) {
                        if (uRs.next()) {
                            currentPoints = uRs.getInt("total_xp");
                            currentLevel = uRs.getInt("player_level");
                        }
                    }
                }

                newPoints = currentPoints + pointsEarned;
                newLevel = (newPoints / 100) + 1;

                try (PreparedStatement upPs = con.prepareStatement(updateUserSql)) {
                    upPs.setInt(1, newPoints);
                    upPs.setInt(2, newLevel);
                    upPs.setInt(3, userId);
                    upPs.executeUpdate();
                }

                session.setAttribute("ecoPoints", newPoints);
                session.setAttribute("level", newLevel);
            }

            con.commit();

            // 5. Forward feedback to mission-result.jsp
            request.setAttribute("missionTitle", missionTitle);
            request.setAttribute("isCorrect", isCorrect);
            request.setAttribute("pointsEarned", pointsEarned);
            request.setAttribute("selectedAnswer", selectedAnswer);
            request.setAttribute("correctAnswer", correctAnswer);
            request.setAttribute("leveledUp", newLevel > currentLevel && isCorrect);
            request.setAttribute("newLevel", newLevel);

            request.getRequestDispatcher("mission-result.jsp").forward(request, response);

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            request.setAttribute("error", "Transaction failed during evaluation: " + e.getMessage());
            request.getRequestDispatcher("MissionServlet").forward(request, response);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
