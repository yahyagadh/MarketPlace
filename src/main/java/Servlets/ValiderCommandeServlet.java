package Servlets;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

@WebServlet("/ValiderCommandeServlet")
public class ValiderCommandeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Vérifier si l'utilisateur est connecté
        Integer utilisateurId = (Integer) session.getAttribute("utilisateurId");
        if (utilisateurId == null) {
            // Rediriger vers la page de connexion si non connecté
            response.sendRedirect("Connexion.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        List<String[]> panier = (List<String[]>) session.getAttribute("panier");

        if (panier == null || panier.isEmpty()) {
            request.setAttribute("message", "Votre panier est vide !");
            request.getRequestDispatcher("panier.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/ecommerce", "postgres", "123456")) {
            request.getRequestDispatcher("recapitulatif_commande.jsp").forward(request, response);

            conn.setAutoCommit(false);

            // 1. Insérer la commande dans la table `orders`
            String insertOrderSQL = "INSERT INTO orders (utilisateur_id, statut) VALUES (?, 'en cours') RETURNING id";
            int commandeId;

            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL)) {
                psOrder.setInt(1, utilisateurId);
                ResultSet rs = psOrder.executeQuery();
                if (rs.next()) {
                    commandeId = rs.getInt(1);
                } else {
                    conn.rollback();
                    throw new SQLException("Erreur lors de la création de la commande.");
                }
            }

            // 2. Insérer les produits du panier dans `order_details`
            String insertDetailSQL = "INSERT INTO order_details (commande_id, produit_id, quantite, prix_total) VALUES (?, ?, ?, ?)";

            try (PreparedStatement psDetail = conn.prepareStatement(insertDetailSQL)) {
                for (String[] produit : panier) {
                    int produitId = Integer.parseInt(produit[0]);
                    int quantite = Integer.parseInt(produit[3]);
                    double prixTotal = Double.parseDouble(produit[2].replace(",", ".")) * quantite;

                    psDetail.setInt(1, commandeId);
                    psDetail.setInt(2, produitId);
                    psDetail.setInt(3, quantite);
                    psDetail.setDouble(4, prixTotal);
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }

            // 3. Vider le panier
            session.setAttribute("panier", new ArrayList<String[]>());

            // Commit de la transaction
            conn.commit();
            request.setAttribute("message", "Commande validée avec succès !");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Erreur lors de la validation de la commande.");
        }

        // Rediriger vers la page panier
    }
}
