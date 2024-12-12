package util;

import java.sql.Connection;

import java.sql.DriverManager;
import java.sql.SQLException;

public class DataBaseHelper {
    private static final String URL = "jdbc:postgresql://localhost:5432/ecommerce";
    private static final String USER = "postgres";
    private static final String PASSWORD = "admin123";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        }
    }
}

