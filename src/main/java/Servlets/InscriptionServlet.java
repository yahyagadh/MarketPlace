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

/**
 * Servlet implementation class InscriptionServlet
 */
@WebServlet(name="InscriptionServlet",value="/InscriptionServlet")
public class InscriptionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InscriptionServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String url = "jdbc:postgresql://localhost:5432/ecommerce";
		String username="postgres";
		String db_password="123456";
		String pwd= request.getParameter("password");
		String pwd2= request.getParameter("confirmPassword");
		String nom=request.getParameter("username");
		String email=request.getParameter("email");
		Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
        	try {
        	    Class.forName("org.postgresql.Driver");
        	} catch (ClassNotFoundException e) {
        	    request.setAttribute("errorMessage", "PostgreSQL JDBC Driver not found.");
        	    RequestDispatcher dispatcher = request.getRequestDispatcher("/inscription.jsp");
        	    dispatcher.forward(request, response);
        	    return; // Stop execution if driver is not found
        	}
        	conn = DriverManager.getConnection(url, username, db_password);
        	if (conn == null) {
        	    request.setAttribute("errorMessage", "Failed to connect to the database.");
        	    RequestDispatcher dispatcher = request.getRequestDispatcher("/inscription.jsp");
        	    dispatcher.forward(request, response);
        	    return; // Stop execution if database connection fails
        	}
            String checkUserSQL = "SELECT * FROM public.utilisateurs WHERE email = ?";
            stmt = conn.prepareStatement(checkUserSQL);
            stmt.setString(1, email);
            rs = stmt.executeQuery();

            if (rs.next()) {
                // User already exists
                request.setAttribute("errorMessage", "User already exists. Please use a different email.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/inscription.jsp");
                dispatcher.forward(request, response);
            } else {
                // Check if passwords match
                if (pwd.equals(pwd2)) {
                    // Insert new user into the database
                    String insertUserSQL = "INSERT INTO public.utilisateurs (nom, email, mot_de_passe, role) VALUES (?, ?, ?, ?)";
                    stmt = conn.prepareStatement(insertUserSQL);
                    stmt.setString(1, nom);
                    stmt.setString(2, email);
                    stmt.setString(3, pwd);
                    stmt.setString(4, "utilisateur"); // Default role is "utilisateur"
                    stmt.executeUpdate();

                    // Redirect to home.jsp after successful registration
                    request.setAttribute("email", email);
                    request.setAttribute("username", nom);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/userDashboard.jsp");
                    dispatcher.forward(request, response);
                } else {
                    // Passwords do not match
                    request.setAttribute("errorMessage", "Passwords do not match. Please re-confirm your password.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/inscription.jsp");
                    dispatcher.forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // In case of errors, forward to registration page with error message
            request.setAttribute("errorMessage", "An error occurred while processing your request.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/inscription.jsp");
            dispatcher.forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
		
	}

}