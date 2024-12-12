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

@WebServlet("/CommandeServlet")
public class CommandeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null) {
            int orderId = Integer.parseInt(request.getParameter("id"));
            String message = "";  // Message à afficher après action
            boolean success = false;

            try {
                // Connexion à la base de données
                String url = "jdbc:postgresql://localhost:5432/ecommerce";
                String username = "postgres";
                String password = "admin123";
                Connection conn = DriverManager.getConnection(url, username, password);
                System.out.println("Connexion réussie à la base de données.");

                if ("deliver".equals(action)) {
                    // Vérifier l'état actuel de la commande
                    String checkStatusSQL = "SELECT statut FROM orders WHERE id = ?";
                    PreparedStatement psCheck = conn.prepareStatement(checkStatusSQL);
                    psCheck.setInt(1, orderId);
                    ResultSet rsCheck = psCheck.executeQuery();

                    if (rsCheck.next()) {
                        String currentStatus = rsCheck.getString("statut");
                        System.out.println("Statut actuel : " + currentStatus);

                        if ("en cours".equals(currentStatus)) {
                            // 1. Mettre à jour le statut de la commande
                            String updateOrderSQL = "UPDATE public.orders SET statut = 'livré' WHERE id = ?";
                            PreparedStatement psUpdateOrder = conn.prepareStatement(updateOrderSQL);
                            psUpdateOrder.setInt(1, orderId);
                            int rowsAffected = psUpdateOrder.executeUpdate();
                            psUpdateOrder.close();

                            if (rowsAffected > 0) {
                                // 2. Récupérer les produits et quantités associés à la commande
                                String getOrderItemsSQL = "SELECT produit_id, quantite FROM order_details WHERE commande_id = ?";
                                PreparedStatement psGetOrderItems = conn.prepareStatement(getOrderItemsSQL);
                                psGetOrderItems.setInt(1, orderId);
                                ResultSet rsOrderItems = psGetOrderItems.executeQuery();

                                while (rsOrderItems.next()) {
                                    int productId = rsOrderItems.getInt("produit_id");
                                    int quantity = rsOrderItems.getInt("quantite");

                                    // 3. Mettre à jour le stock du produit
                                    String updateStockSQL = "UPDATE products SET stock = stock - ? WHERE id = ?";
                                    PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSQL);
                                    psUpdateStock.setInt(1, quantity);
                                    psUpdateStock.setInt(2, productId);

                                    int stockUpdated = psUpdateStock.executeUpdate();
                                    psUpdateStock.close();

                                    if (stockUpdated > 0) {
                                        System.out.println("Stock mis à jour pour le produit ID : " + productId);
                                    } else {
                                        System.out.println("Erreur : impossible de mettre à jour le stock pour le produit ID : " + productId);
                                    }
                                }

                                rsOrderItems.close();
                                psGetOrderItems.close();

                                message = "Commande marquée comme livrée, et stock mis à jour.";
                                success = true;
                            } else {
                                message = "Erreur : la commande n'a pas pu être mise à jour.";
                            }
                        } else {
                            message = "Erreur : la commande est déjà livrée.";
                        }
                    } else {
                        message = "Erreur : commande non trouvée.";
                    }
                    rsCheck.close();
                    psCheck.close();
                }

                conn.close();
            } catch (SQLException e) {
                System.out.println("Erreur SQL : " + e.getMessage());
                e.printStackTrace();
                message = "Erreur lors du traitement de la commande : " + e.getMessage();
                success = false;
            }

            // Rediriger avec le message
            response.sendRedirect("commandes.jsp?message=" + message + "&success=" + success);
        }
    }
}
