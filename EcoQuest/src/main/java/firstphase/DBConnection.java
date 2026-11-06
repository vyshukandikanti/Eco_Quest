package firstphase;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {

    // Server URL without database name to ensure database can be created if it doesn't exist
    private static final String SERVER_URL = "jdbc:mysql://localhost:3306/?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ecoquest_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "Vyshu@223775";

    private static boolean isInitialized = false;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
            initDatabaseAndTables();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Automatically creates the database, tables, and starter records
     * so you don't have to manually write queries in CMD or Workbench!
     */
    private static synchronized void initDatabaseAndTables() {
        if (isInitialized) {
            return;
        }

        // Step 1: Create database if it does not exist
        try (Connection serverConn = DriverManager.getConnection(SERVER_URL, USERNAME, PASSWORD);
             Statement stmt = serverConn.createStatement()) {

            stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS ecoquest_db");

        } catch (SQLException e) {
            System.err.println("Could not connect to MySQL server root: " + e.getMessage());
        }

        // Step 2: Create all required tables inside ecoquest_db
        try (Connection dbConn = DriverManager.getConnection(DB_URL, USERNAME, PASSWORD);
             Statement stmt = dbConn.createStatement()) {

            // Table 1: admins
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS admins (" +
                "    id INT AUTO_INCREMENT PRIMARY KEY," +
                "    username VARCHAR(50) NOT NULL UNIQUE," +
                "    password VARCHAR(255) NOT NULL" +
                ")"
            );

            // Table 2: users
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS users (" +
                "    id INT AUTO_INCREMENT PRIMARY KEY," +
                "    username VARCHAR(50) NOT NULL UNIQUE," +
                "    email VARCHAR(100) NOT NULL UNIQUE," +
                "    password VARCHAR(255) NOT NULL," +
                "    total_xp INT DEFAULT 0," +
                "    player_level INT DEFAULT 1," +
                "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")"
            );

            // Table 3: missions
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS missions (" +
                "    id INT AUTO_INCREMENT PRIMARY KEY," +
                "    title VARCHAR(100) NOT NULL," +
                "    description TEXT NOT NULL," +
                "    category VARCHAR(30) NOT NULL," +
                "    difficulty VARCHAR(20) NOT NULL," +
                "    option_a VARCHAR(255) NOT NULL," +
                "    option_b VARCHAR(255) NOT NULL," +
                "    option_c VARCHAR(255) NOT NULL," +
                "    option_d VARCHAR(255) NOT NULL," +
                "    correct_answer VARCHAR(255) NOT NULL," +
                "    xp_reward INT DEFAULT 50," +
                "    created_by INT," +
                "    FOREIGN KEY (created_by) REFERENCES admins(id) ON DELETE SET NULL" +
                ")"
            );

            // Table 4: mission_submissions
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS mission_submissions (" +
                "    id INT AUTO_INCREMENT PRIMARY KEY," +
                "    user_id INT NOT NULL," +
                "    mission_id INT NOT NULL," +
                "    answer VARCHAR(255) NOT NULL," +
                "    is_correct BOOLEAN DEFAULT FALSE," +
                "    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE," +
                "    FOREIGN KEY (mission_id) REFERENCES missions(id) ON DELETE CASCADE," +
                "    UNIQUE KEY unique_user_mission (user_id, mission_id)" +
                ")"
            );

            // Seed default admin if missing
            try (ResultSet rs = stmt.executeQuery("SELECT id FROM admins WHERE username = 'admin'")) {
                if (!rs.next()) {
                    stmt.executeUpdate("INSERT INTO admins (username, password) VALUES ('admin', 'admin123')");
                }
            }

            // Seed initial missions if empty
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM missions")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    stmt.executeUpdate(
                        "INSERT INTO missions (title, description, category, difficulty, option_a, option_b, option_c, option_d, correct_answer, xp_reward, created_by) VALUES " +
                        "('Single-Use Plastic Reduction', 'Which of the following actions eliminates the greatest amount of persistent household plastic waste per year?', 'Waste Management', 'Easy', 'Using single-use plastic straws', 'Carrying a reusable stainless-steel water bottle and canvas tote', 'Burning plastic containers in backyard', 'Throwing plastic bags into normal trash bins', 'B', 50, 1)," +
                        "('Vampire Power Audit', 'What is vampire power (standby power) and how can a household eliminate it most effectively?', 'Energy Conservation', 'Medium', 'Power drawn by electronic devices even when turned off; plug them into smart power strips', 'Power from solar panels at night', 'Electricity used exclusively by refrigerators', 'Battery drainage on old smartphones', 'A', 100, 1)," +
                        "('Urban Composting Ratio', 'When setting up an aerobic backyard compost bin, what is the ideal ratio of Carbon (Browns) to Nitrogen (Greens)?', 'Eco Living', 'Hard', '1 part brown to 10 parts green', 'Approximately 2 to 3 parts brown (dry leaves, cardboard) to 1 part green (food scraps)', 'Equal parts chemical fertilizer and plastic pellets', '100% green organic matter only', 'B', 150, 1)," +
                        "('Household Water Conservation', 'A leaky toilet flap can silently waste up to how many gallons of potable water each day?', 'Water Conservation', 'Easy', 'Less than 1 gallon', 'About 5 gallons', 'Up to 200 gallons', '0 gallons', 'C', 50, 1)," +
                        "('LED Lighting Efficiency', 'Compared to traditional incandescent light bulbs, approximately how much less energy does an ENERGY STAR certified LED bulb consume?', 'Energy Conservation', 'Medium', 'Around 10% less', 'Between 75% to 80% less', 'Same amount', '200% more', 'B', 100, 1)"
                    );
                }
            }

            isInitialized = true;
            System.out.println("EcoQuest Database & Tables verified and initialized successfully.");

        } catch (SQLException e) {
            System.err.println("Database auto-initialization error: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        if (!isInitialized) {
            initDatabaseAndTables();
        }
        return DriverManager.getConnection(DB_URL, USERNAME, PASSWORD);
    }
}
