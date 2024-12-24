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
    <style>
        body {
            background-color: #f8f9fa;
        }

        .logout {
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
            padding: 8px 15px;
            border: 2px solid #007bff;
            border-radius: 5px;
            transition: background-color 0.3s ease, color 0.3s ease;
            background-color: white;
            position: absolute;
            top: 20px;
            right: 20px;
        }

        .logout:hover {
            background-color: #007bff;
            color: white;
        }

        .sidebar {
            width: 250px;
            background-color: #007bff;
            color: white;
            display: flex;
            flex-direction: column;
            padding: 20px 0;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            font-family: 'Arial', sans-serif;
        }

        .sidebar a {
            text-decoration: none;
            color: white;
            padding: 15px 20px;
            font-size: 1.2rem;
            font-weight: bold;
            display: block;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .sidebar a:hover {
            background-color: #0056b3;
            transform: translateX(10px);
        }

        .sidebar h2 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: bold;
            font-size: 1.5rem;
        }

        .table-container {
            margin-left: 270px;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .table {
            margin-top: 20px;
            text-align: center;
        }

        .table th, .table td {
            vertical-align: middle;
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .no-data {
            font-size: 1.2rem;
            text-align: center;
            color: #666;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>Navigation</h2>
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="productlist.jsp">Produits</a>
        <a href="commandes.jsp">Commandes</a>
        <a href="user_list.jsp">Utilisateurs</a>
    </div>

    <a href="LogoutServlet" class="logout">Se Déconnecter</a>

    <div class="container d-flex align-items-center justify-content-center min-vh-100 py-5">
        <div class="table-container w-100" style="max-width: 900px;">
            <h1 class="text-center mb-4">Détails de la Commande</h1>
            <div class="row">
                <% 
                    String url = "jdbc:postgresql://localhost:5432/ecommerce";
                    String username = "postgres";
                    String password = "123456";
                    String orderId = request.getParameter("id");
                    String statut = request.getParameter("statut"); // Retrieve status from the URL

                    if (orderId == null || orderId.isEmpty()) {
                        out.print("<p class='text-danger'>ID de commande manquant.</p>");
                    } else {
                        try {
                            Class.forName("org.postgresql.Driver");
                            Connection conn = DriverManager.getConnection(url, username, password);

                            // Query for order details
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
                <table class="table table-striped table-hover">
                    <thead class="table-primary">
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

                <h4 class="mt-4">Statut de la commande : <span class="text-primary"><%= statut %></span></h4>

                <div class="mt-4">
                    <% if ("en cours".equals(statut)) { %>
                        <a href="CommandeServlet?action=deliver&id=<%= orderId %>" class="btn btn-primary">Marquer comme Livrée</a>
                    <% } else { %>
                        <p>Commande déjà traitée.</p>
                    <% } %>
                </div>
                <% 
                            } else {
                                out.println("<p class='no-data'>Commande non trouvée.</p>");
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
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
