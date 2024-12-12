package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditProductServlet")
public class EditProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public EditProductServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les paramètres de la requête
        String idParam = request.getParameter("id");
        String description = request.getParameter("description");
        String priceParam = request.getParameter("price");
        String stockParam = request.getParameter("stock");

        // Validation des entrées
        if (idParam == null || idParam.isEmpty() || 
            description == null || description.isEmpty() ||
            priceParam == null || priceParam.isEmpty() ||
            stockParam == null || stockParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tous les champs sont obligatoires.");
            return;
        }

        int productId;
        double price;
        int stock;

        try {
            productId = Integer.parseInt(idParam.trim());
            price = Double.parseDouble(priceParam.trim());
            stock = Integer.parseInt(stockParam.trim());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Valeurs numériques invalides.");
            return;
        }

        // Connexion à la base de données
        String url = "jdbc:postgresql://localhost:5432/ecommerce";
        String username = "postgres";
        String password = "admin123";

        try (Connection conn = DriverManager.getConnection(url, username, password)) {
            Class.forName("org.postgresql.Driver");

            // Requête SQL de mise à jour
            String sql = "UPDATE public.products SET description = ?, prix = ?, stock = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, description);
                ps.setDouble(2, price);
                ps.setInt(3, stock);
                ps.setInt(4, productId);

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                	RequestDispatcher dispatcher = request.getRequestDispatcher("productlist.jsp");
                    dispatcher.forward(request, response); // Redirige vers la liste des produits après mise à jour
                } else {
                    response.getWriter().println("Erreur : Produit introuvable ou mise à jour échouée.");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().write("Erreur SQL : " + e.getMessage());
        }
    }
}
