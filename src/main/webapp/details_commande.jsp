<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Détails de la Commande</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
</head>
<body>
    <div class="container py-5">
        <h1 class="mb-4">Détails de la Commande</h1>
        <div class="row">
            <% 
                String url = "jdbc:postgresql://localhost:5432/ecommerce";
                String username = "postgres";
                String password = "123456";
                String orderId = request.getParameter("id");
                String statut = request.getParameter("statut"); // Récupérer le statut depuis l'URL

                if (orderId == null || orderId.isEmpty()) {
                    out.print("<p class='text-danger'>ID de commande manquant.</p>");
                } else {
                    try {
                        Class.forName("org.postgresql.Driver");
                        Connection conn = DriverManager.getConnection(url, username, password);

                        // Récupérer les détails de la commande
                        String sql = "SELECT o.id, o.utilisateur_id, o.date, o.statut, od.produit_id, od.quantite, od.prix_total, p.nom " +
                                     "FROM orders o " +
                                     "INNER JOIN order_details od ON o.id = od.commande_id " +
                                     "INNER JOIN products p ON od.produit_id = p.id " +
                                     "WHERE o.id = ?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(orderId));
                        ResultSet rs = ps.executeQuery();

                        if (rs.next()) {
            %>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>ID Produit</th>
                        <th>Nom Produit</th>
                        <th>Quantité</th>
                        <th>Prix Total</th>
                    </tr>
                </thead>
                <tbody>
                    <% do { %>
                        <tr>
                            <td><%= rs.getInt("produit_id") %></td>
                            <td><%= rs.getString("nom") %></td>
                            <td><%= rs.getInt("quantite") %></td>
                            <td><%= rs.getDouble("prix_total") %> €</td>
                        </tr>
                    <% } while (rs.next()); %>
                </tbody>
            </table>

            <h4>Statut de la commande : <%= statut %></h4> <!-- Afficher le statut passé via l'URL -->

            <div class="mt-4">
                <% if ("en cours".equals(statut)) { %>
                    <a href="CommandeServlet?action=deliver&id=<%= orderId %>" class="btn btn-primary">Marquer comme Livrée</a>
                <% } else { %>
                    <p>Commande déjà traitée.</p>
                <% } %>
            </div>
            <% 
                        } else {
                            out.println("<p>Commande non trouvée.</p>");
                        }
                        rs.close();
                        ps.close();
                        conn.close();
                    } catch (SQLException | ClassNotFoundException e) {
                        e.printStackTrace();
                        out.print("<p class='text-danger'>Erreur lors de la récupération des détails de la commande : " + e.getMessage() + "</p>");
                    }
                }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
