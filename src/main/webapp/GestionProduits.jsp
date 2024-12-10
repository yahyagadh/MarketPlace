<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.Iterator" %>
<html>
<head>
    <title>Gestion des Produits</title>
    <style>
        /* Style de la page ici */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #333;
            color: white;
            padding: 20px;
            text-align: center;
            font-size: 24px;
        }

        nav {
            background-color: #444;
            padding: 10px 0;
            text-align: center;
        }

        nav a {
            color: white;
            font-weight: bold;
            margin: 0 15px;
            text-decoration: none;
        }

        nav a:hover {
            color: #007bff;
        }

        div {
            margin: 20px;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #333;
        }

        .product-cards {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: space-between;
        }

        .product-card {
            width: 220px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .product-card:hover {
            transform: translateY(-10px);
        }

        .product-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 8px;
        }

        .product-card h3 {
            font-size: 18px;
            margin: 10px 0;
        }

        .product-card p {
            color: #555;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .product-card .price {
            font-weight: bold;
            font-size: 16px;
            color: #007bff;
        }

        .product-card .actions a {
            color: #007bff;
            text-decoration: none;
            margin: 5px;
        }

        .product-card .actions a:hover {
            text-decoration: underline;
        }

        form {
            margin-top: 20px;
        }

        form input[type="text"],
        form select {
            width: 100%;
            padding: 8px;
            margin: 5px 0 15px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        form input[type="submit"] {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        form input[type="submit"]:hover {
            background-color: #0056b3;
        }

        form label {
            font-weight: bold;
        }
    </style>
</head>
<body>
    <header>
        <h1>Gestion des Produits</h1>
    </header>
    <nav>
        <a href="Dashboard.jsp">Retour au Dashboard</a>
    </nav>
    <div>
        <h2>Connexion à la base de données</h2>
        <%
            // Connexion à la base de données
            String url = "jdbc:postgresql://localhost:5432/ecommerce";
            String user = "postgres";
            String password = "123456";
            Connection connection = null;
            Statement statement = null;
            ResultSet resultSet = null;

            try {
                // Connexion
                Class.forName("org.postgresql.Driver");
                connection = DriverManager.getConnection(url, user, password);

                // Créer un Statement de type scrollable
                statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

                // Vérifier la connexion
                if (connection != null) {
                    out.println("<p>Connexion réussie à la base de données !</p>");
                } else {
                    out.println("<p>Échec de la connexion à la base de données.</p>");
                }

                // Affichage des produits
                String sql = "SELECT p.id, p.nom, p.description, p.prix, p.stock, p.image, c.nom AS categorie FROM products p JOIN categorie c ON p.categorie_id = c.id";
                resultSet = statement.executeQuery(sql);

                // Vérifier s'il y a des produits
                if (!resultSet.next()) {
                    out.println("<p>Aucun produit trouvé.</p>");
                } else {
                    // Affichage des produits sous forme de cartes
                    out.println("<div class='product-cards'>");

                    resultSet.beforeFirst();  // Revenir au début du ResultSet
                    while (resultSet.next()) {
                        out.println("<div class='product-card'>");
                        out.println("<img src='" + resultSet.getString("image") + "' alt='" + resultSet.getString("nom") + "'>");
                        out.println("<h3>" + resultSet.getString("nom") + "</h3>");
                        out.println("<p>" + resultSet.getString("description") + "</p>");
                        out.println("<p class='price'>Prix: " + resultSet.getDouble("prix") + " €</p>");
                        out.println("<p>Stock: " + resultSet.getInt("stock") + "</p>");
                        out.println("<p>Catégorie: " + resultSet.getString("categorie") + "</p>");
                        out.println("<div class='actions'><a href='ModifierProduit.jsp?id=" + resultSet.getInt("id") + "'>Modifier</a> | <a href='SupprimerProduitServlet?id=" + resultSet.getInt("id") + "'>Supprimer</a></div>");
                        out.println("</div>");
                    }
                    out.println("</div>");
                }

            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Erreur de connexion : " + e.getMessage() + "</p>");
            } finally {
                // Fermeture des ressources
                try {
                    if (resultSet != null) resultSet.close();
                    if (statement != null) statement.close();
                    if (connection != null) connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>

    <h2>Ajouter un produit</h2>
    <form action="AjouterProduitServlet" method="POST">
        <label for="nom">Nom:</label><br>
        <input type="text" id="nom" name="nom"><br><br>
        <label for="description">Description:</label><br>
        <input type="text" id="description" name="description"><br><br>
        <label for="prix">Prix:</label><br>
        <input type="text" id="prix" name="prix"><br><br>
        <label for="stock">Stock:</label><br>
        <input type="text" id="stock" name="stock"><br><br>
        <label for="categorie">Catégorie:</label><br>
        <select id="categorie" name="categorie_id">
        <%
            // Connexion à la base de données et récupération des catégories
            Statement categorieStatement = null;
            ResultSet categorieResultSet = null;
            try {
                categorieStatement = connection.createStatement();
                String categorieSql = "SELECT id, nom FROM categorie";
                categorieResultSet = categorieStatement.executeQuery(categorieSql);
                while (categorieResultSet.next()) {
                    out.println("<option value='" + categorieResultSet.getInt("id") + "'>" + categorieResultSet.getString("nom") + "</option>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Erreur lors du chargement des catégories.</p>");
            } finally {
                // Fermeture des ressources
                if (categorieResultSet != null) {
                    try {
                        categorieResultSet.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                if (categorieStatement != null) {
                    try {
                        categorieStatement.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>
        </select><br><br>
        <label for="image">Image:</label><br>
        <input type="text" id="image" name="image"><br><br>
        <input type="submit" value="Ajouter">
    </form>
</div>

</body>
</html>
