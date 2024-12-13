package Servlets;

import java.io.IOException;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.RequestDispatcher;

/**
 * Servlet implementation class SupprimerProduitServlet
 */
@WebServlet("/SupprimerProduitServlet")
public class SupprimerProduitServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int produitId = Integer.parseInt(request.getParameter("id"));

        try (Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/ecommerce", "postgres", "123456")) {
            String sql = "DELETE FROM products WHERE id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setInt(1, produitId);
                stmt.executeUpdate();
            }
            RequestDispatcher dispatcher = (RequestDispatcher) request.getRequestDispatcher("productlist.jsp");
            dispatcher.forward(request, response);        
            }
        catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Erreur lors de la suppression du produit : " + e.getMessage());
        }
    }
}
