package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.*;
/**
 * Servlet implementation class HistoriqueCommandeServlet
 */
@WebServlet("/HistoriqueCommandeServlet")
public class HistoriqueCommandeServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer utilisateurId = (Integer) session.getAttribute("utilisateurId");

        if (utilisateurId == null) {
            response.sendRedirect("Connexion.jsp");
            return;
        }

        List<Map<String, String>> commandes = new ArrayList<>();
        try {
            String url = "jdbc:postgresql://localhost:5432/ecommerce";
            String username = "postgres";
            String password = "123456";

            Connection connection = DriverManager.getConnection(url, username, password);
            String sql = "SELECT id, date, statut FROM orders WHERE utilisateur_id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, utilisateurId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> commande = new HashMap<>();
                commande.put("id", rs.getString("id"));
                commande.put("date", rs.getString("date"));
                commande.put("statut", rs.getString("statut"));
                commandes.add(commande);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("commandes", commandes);
        RequestDispatcher dispatcher = request.getRequestDispatcher("historique.jsp");
        dispatcher.forward(request, response);
    }
}
