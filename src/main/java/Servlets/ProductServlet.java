package Servlets;

import java.io.File;

import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/ProductServlet")
@MultipartConfig(
    location = "C:\\Users\\user\\jee\\JEE\\src\\main\\webapp\\uploads",
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String IMAGE_UPLOAD_DIR = "C:\\Users\\user\\jee\\JEE\\src\\main\\webapp\\uploads";
    

    public ProductServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("list".equals(action)) {
            displayProducts(request, response);
        } else if ("delete".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    int productId = Integer.parseInt(idParam);
                    deleteProductById(productId, response);
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID produit invalide.");
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID produit manquant.");
            }
        } else {
            response.getWriter().append("Action invalide.");
        }
    }

    private void displayProducts(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String url = "jdbc:postgresql://localhost:5432/ecommerce";
        String username = "postgres";
        String password = "123456";

        try (Connection conn = DriverManager.getConnection(url, username, password)) {
            Class.forName("org.postgresql.Driver");
            String sql = "SELECT * FROM public.products";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            StringBuilder productsHtml = new StringBuilder("<h2>Liste des produits</h2><ul>");
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("nom");
                String description = rs.getString("description");
                double price = rs.getDouble("prix");
                int stock = rs.getInt("stock");
                String image = rs.getString("image");

                productsHtml.append("<li>")
                        .append("<strong>Nom :</strong> ").append(name).append("<br>")
                        .append("<strong>Description :</strong> ").append(description).append("<br>")
                        .append("<strong>Prix :</strong> ").append(price).append("<br>")
                        .append("<strong>Stock :</strong> ").append(stock).append("<br>")
                        .append("<img src='").append(image).append("' width='100'><br>")
                        .append("<a href='ProductServlet?action=delete&id=").append(id).append("'>Supprimer</a>")
                        .append("</li>");
            }
            productsHtml.append("</ul>");
            response.getWriter().println(productsHtml.toString());
        } catch (SQLException | ClassNotFoundException e) {
            response.getWriter().write("Erreur lors de la récupération des produits : " + e.getMessage());
        }
    }

    private void deleteProductById(int productId, HttpServletResponse response) throws IOException {
        String url = "jdbc:postgresql://localhost:5432/ecommerce";
        String username = "postgres";
        String password = "123456";

        try (Connection conn = DriverManager.getConnection(url, username, password)) {
            Class.forName("org.postgresql.Driver");
            String sql = "DELETE FROM public.products WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("ProductServlet?action=list");
            } else {
                response.getWriter().write("Produit introuvable.");
            }
        } catch (SQLException | ClassNotFoundException e) {
            response.getWriter().write("Erreur SQL : " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String name = request.getParameter("name");
    	String description = request.getParameter("description");
    	String priceParam = request.getParameter("price");
    	String stockParam = request.getParameter("stock");
    	String categoryIdParam = request.getParameter("category_id");
    	
    	System.out.println("Name: " + name);
    	System.out.println("Description: " + description);
    	System.out.println("Price: " + priceParam);
    	System.out.println("Stock: " + stockParam);
    	System.out.println("Category ID: " + categoryIdParam);

        // Check if the fields are not null
        if (name == null || description == null || priceParam == null || stockParam == null || categoryIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "All fields are required.");
            return;
        }

        double price = 0;
        int stock = 0;
        int categoryId = 0;

        try {
            // Parse the numerical fields
            price = Double.parseDouble(priceParam.trim());
            stock = Integer.parseInt(stockParam.trim());
            categoryId = Integer.parseInt(categoryIdParam.trim());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid numeric values for price, stock, or category.");
            return;
        }

        // Handle file upload
        Part imagePart = request.getPart("image");
        String imagePath = null;

        if (imagePart != null && imagePart.getSize() > 0) {
            System.out.println("Image uploaded: " + imagePart.getSubmittedFileName());

            // Define the directory to save uploaded images
            File uploadDir = new File(IMAGE_UPLOAD_DIR);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
          

            // Get the file name
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            File imageFile = new File(uploadDir, fileName);
            imagePart.write(imageFile.getAbsolutePath());
            imagePath = "uploads/" + fileName;
            System.out.println("Saving file to: " + imageFile.getAbsolutePath());

        }
        else {
        	 System.out.println("No image uploaded.");
        }

        // Now insert the product into the database
        try (Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/ecommerce", "postgres", "123456")) {
            Class.forName("org.postgresql.Driver");
            String sql = "INSERT INTO public.products (nom, description, prix, image, stock, categorie_id) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, price);
            ps.setString(4, imagePath);
            ps.setInt(5, stock);
            ps.setInt(6, categoryId);

            if (ps.executeUpdate() > 0) {
            	RequestDispatcher dispatcher = request.getRequestDispatcher("productlist.jsp");
                dispatcher.forward(request, response);            
                } 
            else {
                response.getWriter().println("Erreur lors de l'ajout du produit.");
            }
        } catch (SQLException | ClassNotFoundException e) {
            response.getWriter().write("Erreur SQL : " + e.getMessage());
        }
    }
}
