package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:postgresql://localhost:5432/ecommerce";
    private static final String DB_USERNAME = "postgres";
    private static final String DB_PASSWORD = "123456";

    public UserServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("list".equals(action)) {
            displayUsers(request, response);
        } else if ("delete".equals(action)) {
            String userId = request.getParameter("id");
            if (userId != null && !userId.isEmpty()) {
                deleteUser(Integer.parseInt(userId), response);
            }
        } else {
            response.getWriter().write("Invalid action.");
        }
    }

    private void displayUsers(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD)) {
            Class.forName("org.postgresql.Driver");

            String sql = "SELECT id, nom, email, mot_de_passe, role FROM public.utilisateurs";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            StringBuilder userListHtml = new StringBuilder("<h2>Liste des utilisateurs</h2><ul>");
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("nom");
                String email = rs.getString("email");
                String role = rs.getString("role");

                userListHtml.append("<li>")
                        .append("Nom : ").append(name).append("<br>")
                        .append("Email : ").append(email).append("<br>")
                        .append("Rôle : ").append(role).append("<br>")
                        .append("<a href='UserServlet?action=delete&id=").append(id).append("'>Supprimer</a>")
                        .append("</li>");
            }
            userListHtml.append("</ul>");

            response.getWriter().println(userListHtml.toString());

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().write("Erreur lors de la récupération des utilisateurs : " + e.getMessage());
        }
    }

    private void deleteUser(int userId, HttpServletResponse response) throws IOException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD)) {
            Class.forName("org.postgresql.Driver");

            String sql = "DELETE FROM public.utilisateurs WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("UserServlet?action=list");
            } else {
                response.getWriter().write("Erreur : utilisateur introuvable.");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().write("Erreur SQL : " + e.getMessage());
        }
    }
}
