<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestion des Commandes</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
</head>
<body>
    <div class="container py-5">
        <h1 class="mb-4">Liste des Commandes</h1>
        <div class="row">
            <% 
                String url = "jdbc:postgresql://localhost:5432/ecommerce";
                String username = "postgres";
                String password = "admin123";

                try {
                    Class.forName("org.postgresql.Driver");
                    Connection conn = DriverManager.getConnection(url, username, password);
                    String sql = "SELECT id, utilisateur_id, date, statut FROM orders";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
            %>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>ID Commande</th>
                        <th>ID Utilisateur</th>
                        <th>Date</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% do { %>
                        <tr>
                            <td><%= rs.getInt("id") %></td>
                            <td><%= rs.getInt("utilisateur_id") %></td>
                            <td><%= rs.getDate("date") %></td>
                            <td><%= rs.getString("statut") %></td>
                            <td>
                            <a href="details_commande.jsp?id=<%= rs.getInt("id") %>&statut=<%= rs.getString("statut") %>" class="btn btn-info btn-sm">Voir Détails</a>
                            </td>
                        </tr>
                    <% } while (rs.next()); %>
                </tbody>
            </table>
            <% 
                    } else {
                        out.println("<p>Aucune commande trouvée.</p>");
                    }
                    rs.close();
                    ps.close();
                    conn.close();
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                    out.print("<p class='text-danger'>Erreur lors de la récupération des commandes.</p>");
                }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
