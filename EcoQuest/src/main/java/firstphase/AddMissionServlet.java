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
import java.sql.SQLException;

@WebServlet("/AddMissionServlet")
public class AddMissionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        request.getRequestDispatcher("add-mission.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctAnswer = request.getParameter("correctAnswer");
        String xpRewardStr = request.getParameter("xpReward");

        if (title == null || title.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            category == null || category.trim().isEmpty() ||
            difficulty == null || difficulty.trim().isEmpty() ||
            optionA == null || optionA.trim().isEmpty() ||
            optionB == null || optionB.trim().isEmpty() ||
            optionC == null || optionC.trim().isEmpty() ||
            optionD == null || optionD.trim().isEmpty() ||
            correctAnswer == null || correctAnswer.trim().isEmpty() ||
            xpRewardStr == null || xpRewardStr.trim().isEmpty()) {

            request.setAttribute("error", "All fields are required to create a mission.");
            request.getRequestDispatcher("add-mission.jsp").forward(request, response);
            return;
        }

        int xpReward = 50;
        try {
            xpReward = Integer.parseInt(xpRewardStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "XP reward must be a valid number.");
            request.getRequestDispatcher("add-mission.jsp").forward(request, response);
            return;
        }

        String sql = "INSERT INTO missions (title, description, category, difficulty, option_a, option_b, option_c, option_d, correct_answer, xp_reward, created_by) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title.trim());
            ps.setString(2, description.trim());
            ps.setString(3, category.trim());
            ps.setString(4, difficulty.trim());
            ps.setString(5, optionA.trim());
            ps.setString(6, optionB.trim());
            ps.setString(7, optionC.trim());
            ps.setString(8, optionD.trim());
            ps.setString(9, correctAnswer.trim());
            ps.setInt(10, xpReward);
            ps.setInt(11, adminId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("ViewMissionsServlet?msg=created");
            } else {
                request.setAttribute("error", "Failed to add mission.");
                request.getRequestDispatcher("add-mission.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("add-mission.jsp").forward(request, response);
        }
    }
}
