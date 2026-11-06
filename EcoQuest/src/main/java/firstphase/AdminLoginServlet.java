package firstphase;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
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

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private String adminRoleTitle;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        adminRoleTitle = config.getInitParameter("roleTitle");
        if (adminRoleTitle == null) {
            adminRoleTitle = "Administrator";
        }
        ServletContext context = config.getServletContext();
        if (context.getAttribute("appName") == null) {
            context.setAttribute("appName", "EcoQuest Sustainability Platform");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("admin-login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("error", "Enter username and password");
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
            return;
        }

        String sql = "SELECT id, username FROM admins WHERE username = ? AND password = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("adminId", rs.getInt("id"));
                    session.setAttribute("adminUsername", rs.getString("username"));
                    session.setAttribute("adminFullName", rs.getString("username"));
                    session.setAttribute("adminRole", adminRoleTitle);

                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    request.setAttribute("error", "Invalid admin credentials");
                    request.getRequestDispatcher("admin-login.jsp").forward(request, response);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to connect to the database");
            request.getRequestDispatcher("admin-login.jsp").forward(request, response);
        }
    }
}
