<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestion des utilisateurs</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
</head>
<body>
    <div class="container py-5">
        <h1 class="mb-4">Gestion des utilisateurs</h1>
        <div class="row">
            <% 
                String url = "jdbc:postgresql://localhost:5432/ecommerce";
                String username = "postgres";
                String password = "123456";

                try {
                    Class.forName("org.postgresql.Driver");
                    Connection conn = DriverManager.getConnection(url, username, password);

                    // Correction du nom de la table
                    String sql = "SELECT id, nom, email, mot_de_passe, role FROM utilisateurs";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
            %>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Email</th>
                        <th>Mot de Passe</th>
                        <th>Rôle</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% do { %>
                        <tr>
                            <td><%= rs.getInt("id") %></td>
                            <td><%= rs.getString("nom") %></td>
                            <td><%= rs.getString("email") %></td>
                            <td><%= rs.getString("mot_de_passe") %></td>
                            <td><%= rs.getString("role") %></td>
                            <td>
                                <a href="UserServlet?action=delete&id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm">Supprimer</a>
                            </td>
                        </tr>
                    <% } while (rs.next()); %>
                </tbody>
            </table>
            <% 
                    } else {
                        out.println("<p>Aucun utilisateur trouvé.</p>");
                    }
                    rs.close();
                    ps.close();
                    conn.close();
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                    out.print("<p class='text-danger'>Erreur lors de la récupération des utilisateurs : " + e.getMessage() + "</p>");
                }
            %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
