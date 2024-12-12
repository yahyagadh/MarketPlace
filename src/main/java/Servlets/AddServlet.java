package Servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/AddServlet")
public class AddServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AddServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Paramètres de la base de données
        String url = "jdbc:postgresql://localhost:5432/ecommerce";
        String username = "postgres";
        String dbPassword = "admin123";

        // Récupération des données du formulaire
        String pwd = request.getParameter("password");
        String pwd2 = request.getParameter("confirmPassword");
        String nom = request.getParameter("username");
        String email = request.getParameter("email");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Charger le driver PostgreSQL
            Class.forName("org.postgresql.Driver");

            // Établir une connexion à la base de données
            conn = DriverManager.getConnection(url, username, dbPassword);
            String testQuery = "SELECT 1";
            try (PreparedStatement testStmt = conn.prepareStatement(testQuery);
                 ResultSet testRs = testStmt.executeQuery()) {
                if (testRs.next()) {
                    System.out.println("Requête de test réussie. Résultat : " + testRs.getInt(1));
                }
            } catch (SQLException e) {
                System.err.println("Erreur lors de l'exécution de la requête de test : " + e.getMessage());
                e.printStackTrace();
            }

            // Tester la connexion
            if (conn != null && !conn.isClosed()) {
                System.out.println("Connexion à la base de données réussie !");
            } else {
                System.out.println("Échec de la connexion à la base de données !");
            }

            // Vérifier si l'utilisateur existe déjà
            String checkUserSQL = "SELECT * FROM public.utilisateurs WHERE email = ?";
            stmt = conn.prepareStatement(checkUserSQL);
            stmt.setString(1, email);
            rs = stmt.executeQuery();

            if (rs.next()) {
                // L'utilisateur existe déjà
                request.setAttribute("errorMessage", "L'utilisateur existe déjà. Veuillez utiliser un autre email.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/Ajouter.jsp");
                dispatcher.forward(request, response);
            } else {
                // Vérifier si les mots de passe correspondent
                if (pwd.equals(pwd2)) {
                    // Insérer un nouvel utilisateur
                    String insertUserSQL = "INSERT INTO public.utilisateurs (nom, email, mot_de_passe, role) VALUES (?, ?, ?, ?)";
                    stmt = conn.prepareStatement(insertUserSQL);
                    stmt.setString(1, nom);
                    stmt.setString(2, email);
                    stmt.setString(3, pwd);
                    stmt.setString(4, "utilisateur"); // Rôle par défaut
                    stmt.executeUpdate();

                    System.out.println("Nouvel utilisateur ajouté avec succès : " + email);

                    // Rediriger vers la page d'accueil après l'inscription
                    request.setAttribute("email", email);
                    request.setAttribute("username", nom);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/home.jsp");
                    dispatcher.forward(request, response);
                } else {
                    // Les mots de passe ne correspondent pas
                    request.setAttribute("errorMessage", "Les mots de passe ne correspondent pas. Veuillez réessayer.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/Ajouter.jsp");
                    dispatcher.forward(request, response);
                }
            }
        } catch (ClassNotFoundException e) {
            System.err.println("Driver PostgreSQL non trouvé : " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur interne : Driver de base de données non trouvé.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Ajouter.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            System.err.println("Erreur SQL : " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors de l'accès à la base de données : " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Ajouter.jsp");
            dispatcher.forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Erreur lors de la fermeture des ressources : " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
}
