package DAO;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;
import Models.Product;
public class ProductDAO {
    private Connection connection;

    public ProductDAO(Connection connection) {
        this.connection = connection;
    }

    public void createProduct(Product product) throws SQLException {
        String query = "INSERT INTO products (nom, description, prix, image, stock) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, product.getNom());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrix());
            stmt.setBlob(4, product.getImage());
            stmt.setInt(5, product.getStock());
            stmt.executeUpdate();
        }
    }

    public Product getProductById(int id) throws SQLException {
        String query = "SELECT * FROM products WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToProduct(rs);
            }
        }
        return null;
    }

    public List<Product> getAllProducts() throws SQLException {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products";
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                products.add(mapRowToProduct(rs));
            }
        }
        return products;
    }

    public void updateProduct(Product product) throws SQLException {
        String query = "UPDATE products SET nom = ?, description = ?, prix = ?, image = ?, stock = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, product.getNom());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrix());
            stmt.setBlob(4, product.getImage());
            stmt.setInt(5, product.getStock());
            stmt.setInt(6, product.getId());
            stmt.executeUpdate();
        }
    }

    public void deleteProduct(int id) throws SQLException {
        String query = "DELETE FROM products WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private Product mapRowToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setNom(rs.getString("nom"));
        product.setDescription(rs.getString("description"));
        product.setPrix(rs.getDouble("prix"));
        product.setImage(rs.getBlob("image"));
        product.setStock(rs.getInt("stock"));
        return product;
    }
}
