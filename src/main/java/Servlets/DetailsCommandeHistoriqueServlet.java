package Servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class DetailsCommandeHistoriqueServlet
 */
@WebServlet("/DetailsCommandeHistoriqueServlet")
public class DetailsCommandeHistoriqueServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String commandeIdParam = request.getParameter("id");
        String message = null;

        if (commandeIdParam == null || commandeIdParam.isEmpty()) {
            message = "Erreur : l'ID de commande est manquant ou invalide.";
            request.setAttribute("message", message);
            RequestDispatcher dispatcher = request.getRequestDispatcher("historique.jsp");
            dispatcher.forward(request, response);
            return;
        }

        int commandeId;
        try {
            commandeId = Integer.parseInt(commandeIdParam); // Convertir en entier
        } catch (NumberFormatException e) {
            message = "Erreur : l'ID de commande doit être un entier valide.";
            request.setAttribute("message", message);
            RequestDispatcher dispatcher = request.getRequestDispatcher("historique.jsp");
            dispatcher.forward(request, response);
            return;
        }

        Map<String, String> commande = new HashMap<>();
        List<Map<String, String>> produits = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/ecommerce", "postgres", "123456")) {

            // Récupérer les informations de la commande
            String commandeSql = "SELECT id, date, statut FROM orders WHERE id = ?";
            try (PreparedStatement psCommande = connection.prepareStatement(commandeSql)) {
                psCommande.setInt(1, commandeId);
                try (ResultSet rsCommande = psCommande.executeQuery()) {
                    if (rsCommande.next()) {
                        commande.put("id", rsCommande.getString("id"));
                        commande.put("date", rsCommande.getString("date"));
                        commande.put("statut", rsCommande.getString("statut"));
                    } else {
                        message = "Erreur : aucune commande trouvée pour l'ID " + commandeId + ".";
                        request.setAttribute("message", message);
                        RequestDispatcher dispatcher = request.getRequestDispatcher("historique.jsp");
                        dispatcher.forward(request, response);
                        return;
                    }
                }
            }

            // Récupérer les produits associés
            String produitSql = "SELECT p.nom, od.prix_total / od.quantite AS prix_unitaire, od.quantite, od.prix_total " +
                                "FROM order_details od JOIN products p ON od.produit_id = p.id WHERE od.commande_id = ?";
            try (PreparedStatement psProduits = connection.prepareStatement(produitSql)) {
                psProduits.setInt(1, commandeId);
                try (ResultSet rsProduits = psProduits.executeQuery()) {
                    while (rsProduits.next()) {
                        Map<String, String> produit = new HashMap<>();
                        produit.put("nom", rsProduits.getString("nom"));
                        produit.put("prix_unitaire", rsProduits.getString("prix_unitaire"));
                        produit.put("quantite", rsProduits.getString("quantite"));
                        produit.put("prix_total", rsProduits.getString("prix_total"));
                        produits.add(produit);
                    }
                }
            }

            message = "Commande et détails récupérés avec succès.";
        } catch (Exception e) {
            e.printStackTrace();
            message = "Erreur lors de la récupération des données : " + e.getMessage();
        }

        request.setAttribute("commande", commande);
        request.setAttribute("produits", produits);
        request.setAttribute("message", message);
        RequestDispatcher dispatcher = request.getRequestDispatcher("details_commande_historique.jsp");
        dispatcher.forward(request, response);
    }
}
