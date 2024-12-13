package Servlets;

import jakarta.servlet.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Informations de connexion à la base de données
        String url = "jdbc:postgresql://localhost:5432/ecommerce";
        String username = "postgres";
        String dbPassword = "123456";    

        try {
            // Charger le driver PostgreSQL
            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection(url, username, dbPassword);

            // Requête SQL pour récupérer l'utilisateur
            String sql = "SELECT * FROM utilisateurs WHERE email = ? AND mot_de_passe = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, password);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                // Récupérer l'id et le rôle de l'utilisateur
                int utilisateurId = resultSet.getInt("id");
                String role = resultSet.getString("role");

                // Créer une session
                HttpSession session = request.getSession();
                session.setAttribute("user", email);
                session.setAttribute("utilisateurId", utilisateurId);

                if ("administrateur".equals(role)) {
                    // Redirection vers le dashboard admin
                    response.sendRedirect("adminDashboard.jsp");
                } else {
                    // Redirection vers le dashboard utilisateur
                    response.sendRedirect("userDashboard.jsp");
                }
            } else {
                // Identifiants incorrects
                request.setAttribute("error", "Email ou mot de passe incorrect.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("Connexion.jsp");
                dispatcher.forward(request, response);
            }

            resultSet.close();
            preparedStatement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur de serveur.");
        }
    }
}
