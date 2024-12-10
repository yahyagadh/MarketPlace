package Servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

import jakarta.servlet.annotation.WebServlet;

import java.nio.file.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
@WebServlet("/AjouterProduitServlet")
public class AjouterProduitServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les champs du formulaire
        String nom = request.getParameter("nom");
        String description = request.getParameter("description");
        double prix = Double.parseDouble(request.getParameter("prix"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String categorieId = request.getParameter("categorie_id");
        
        // Récupérer l'image (fichier) téléchargée
        Part imagePart = request.getPart("image"); // "image" est le nom du champ <input type="file" />

        // Vérifier si une image a été téléchargée
        if (imagePart != null) {
            // Récupérer le nom du fichier
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();

            // Définir le chemin où l'image sera enregistrée
            String uploadDir = getServletContext().getRealPath("/uploads");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdir(); // Créer le dossier si il n'existe pas
            }

            // Créer un chemin complet pour enregistrer le fichier
            File file = new File(uploadDir + File.separator + fileName);

            // Enregistrer le fichier sur le serveur
            try (InputStream inputStream = imagePart.getInputStream();
                 OutputStream outputStream = new FileOutputStream(file)) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }

            // Le chemin de l'image sera enregistré dans la base de données
            String imagePath = "/uploads/" + fileName;

            // Insérer le produit dans la base de données (exemple de code)
            try (Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/ecommerce", "postgres", "123456")) {
                String sql = "INSERT INTO products (nom, description, prix, stock, categorie_id, image) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, nom);
                    ps.setString(2, description);
                    ps.setDouble(3, prix);
                    ps.setInt(4, stock);
                    ps.setInt(5, Integer.parseInt(categorieId));
                    ps.setString(6, imagePath); // Stocker le chemin relatif de l'image
                    ps.executeUpdate();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Rediriger ou répondre après l'upload
        response.sendRedirect("gestionProduits.jsp");
    }
}
