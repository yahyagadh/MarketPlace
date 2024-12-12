package DAO;

import java.sql.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import Models.Order;
import Models.Product;
public class OrderDAO {
    private Connection connection;

    public OrderDAO(Connection connection) {
        this.connection = connection;
    }

    public void createOrder(Order order) throws SQLException {
        String query = "INSERT INTO orders (utilisateur_id, date, statut) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, order.getUtilisateurId());
            stmt.setTimestamp(2, new Timestamp(order.getDate().getTime()));
            stmt.setString(3, order.getStatut());
            stmt.executeUpdate();
        }
    }

    public Order getOrderById(int id) throws SQLException {
        String query = "SELECT * FROM orders WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToOrder(rs);
            }
        }
        return null;
    }

    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders";
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                orders.add(mapRowToOrder(rs));
            }
        }
        return orders;
    }

    public void updateOrder(Order order) throws SQLException {
        String query = "UPDATE orders SET utilisateur_id = ?, date = ?, statut = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, order.getUtilisateurId());
            stmt.setTimestamp(2, new Timestamp(order.getDate().getTime()));
            stmt.setString(3, order.getStatut());
            stmt.setInt(4, order.getId());
            stmt.executeUpdate();
        }
    }

    public void deleteOrder(int id) throws SQLException {
        String query = "DELETE FROM orders WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private Order mapRowToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUtilisateurId(rs.getInt("utilisateur_id"));
        order.setDate(rs.getTimestamp("date"));
        order.setStatut(rs.getString("statut"));
        return order;
    }
    public Map<Product, Integer> getOrderDetails(int orderId) throws SQLException {
        String query = "SELECT od.produit_id, od.quantite, p.nom, p.description, p.prix " +
                       "FROM order_details od " +
                       "JOIN products p ON od.produit_id = p.id " +
                       "WHERE od.commande_id = ?";
        Map<Product, Integer> orderDetails = new HashMap<>();

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setId(rs.getInt("produit_id"));
                    product.setNom(rs.getString("nom"));
                    product.setDescription(rs.getString("description"));
                    product.setPrix(rs.getDouble("prix"));

                    int quantity = rs.getInt("quantite");
                    orderDetails.put(product, quantity);
                }
            }
        }
        return orderDetails;
    }
    public int createOrder(int utilisateurId, Map<Integer, Integer> cart) throws SQLException {
        String orderQuery = "INSERT INTO orders (utilisateur_id, date, statut) VALUES (?, NOW(), 'en cours')";
        String orderDetailQuery = "INSERT INTO order_details (commande_id, produit_id, quantite, prix_total) VALUES (?, ?, ?, ?)";

        try (PreparedStatement orderStmt = connection.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS)) {
            // Insert the order
            orderStmt.setInt(1, utilisateurId);
            orderStmt.executeUpdate();

            // Get the generated order ID
            ResultSet generatedKeys = orderStmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                int orderId = generatedKeys.getInt(1);

                // Insert order details
                try (PreparedStatement detailStmt = connection.prepareStatement(orderDetailQuery)) {
                    for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                        int productId = entry.getKey();
                        int quantity = entry.getValue();

                        Product product = new ProductDAO(connection).getProductById(productId);
                        double total = product.getPrix() * quantity;

                        detailStmt.setInt(1, orderId);
                        detailStmt.setInt(2, productId);
                        detailStmt.setInt(3, quantity);
                        detailStmt.setDouble(4, total);
                        detailStmt.addBatch();
                    }
                    detailStmt.executeBatch();
                }

                return orderId; // Return the generated order ID
            } else {
                throw new SQLException("Failed to retrieve order ID.");
            }
        }
        }
    public List<Order> getOrderHistory(int userId) throws SQLException {
        String query = "SELECT * FROM orders WHERE utilisateur_id = ? ORDER BY date DESC";
        List<Order> orders = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUtilisateurId(rs.getInt("utilisateur_id"));
                    order.setDate(rs.getDate("date"));
                    order.setStatut(rs.getString("statut"));
                    orders.add(order);
                }
            }
        }
        return orders;
    }


}
