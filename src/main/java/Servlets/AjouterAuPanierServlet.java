package Servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.*;

@WebServlet("/AjouterAuPanierServlet")
public class AjouterAuPanierServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("id");
        String nom = request.getParameter("nom");
        String prixStr = request.getParameter("prix");
        String quantiteStr = request.getParameter("quantite");

        if (productId != null && nom != null && prixStr != null && quantiteStr != null) {
            prixStr = prixStr.replace(",", ".");
            try {
                double prix = Double.parseDouble(prixStr);
                int quantiteDemandee = Integer.parseInt(quantiteStr);

                // Vérifier le stock disponible dans la base de données
                String url = "jdbc:postgresql://localhost:5432/ecommerce";
                String username = "postgres";
                String password = "123456";

                try (Connection connection = DriverManager.getConnection(url, username, password)) {
                    String stockQuery = "SELECT stock FROM public.products WHERE id = ?";
                    PreparedStatement ps = connection.prepareStatement(stockQuery);
                    ps.setInt(1, Integer.parseInt(productId));
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        int stockDisponible = rs.getInt("stock");

                        if (quantiteDemandee > stockDisponible) {
                            // Si la quantité demandée dépasse le stock
                            request.setAttribute("message", "La quantité désirée dépasse le stock disponible.");
                            RequestDispatcher dispatcher = request.getRequestDispatcher("details_produit.jsp");
                            dispatcher.forward(request, response);
                            return;
                        }
                    } else {
                        request.setAttribute("message", "Produit non trouvé.");
                        RequestDispatcher dispatcher = request.getRequestDispatcher("details_produit.jsp");
                        dispatcher.forward(request, response);
                        return;
                    }
                }

                // Récupérer le panier depuis la session
                HttpSession session = request.getSession();
                List<String[]> panier = (List<String[]>) session.getAttribute("panier");
                if (panier == null) {
                    panier = new ArrayList<>();
                }

                // Vérifier si le produit est déjà dans le panier
                boolean produitExiste = false;
                for (String[] produit : panier) {
                    if (produit[0].equals(productId)) {
                        int existingQuantity = Integer.parseInt(produit[3]);
                        produit[3] = String.valueOf(existingQuantity + quantiteDemandee);
                        produitExiste = true;
                        break;
                    }
                }

                // Si le produit n'existe pas, on l'ajoute au panier
                if (!produitExiste) {
                    panier.add(new String[]{productId, nom, String.format("%.2f", prix), String.valueOf(quantiteDemandee)});
                }

                // Mettre à jour le panier dans la session
                session.setAttribute("panier", panier);

            } catch (NumberFormatException | SQLException e) {
                e.printStackTrace();
                response.sendRedirect("errorPage.jsp");
                return;
            }
        }

        // Rediriger vers la page du panier
        response.sendRedirect("userDashboard.jsp");
    }
}
