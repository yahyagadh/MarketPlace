<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title> Registration form </title> 
    <style>
      @import url('https://fonts.googleapis.com/css?family=Poppins:400,500,600,700&display=swap');
      *{
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Poppins', sans-serif;
      }
      body{
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #4070f4;
      }
      .wrapper{
        position: relative;
        max-width: 500px; /* Increased width */
        width: 100%;
        background: #fff;
        padding: 50px; /* Increased padding */
        border-radius: 8px; /* Slightly rounder corners */
        box-shadow: 0 5px 15px rgba(0,0,0,0.2); /* A bit bigger shadow */
      }
      .wrapper h2{
        position: relative;
        font-size: 26px; /* Bigger title */
        font-weight: 600;
        color: #333;
      }
      .wrapper h2::before{
        content: '';
        position: absolute;
        left: 0;
        bottom: 0;
        height: 4px; /* Increased height of the underline */
        width: 35px; /* Slightly bigger underline */
        border-radius: 12px;
        background: #4070f4;
      }
      .wrapper form{
        margin-top: 40px; /* More space before the form */
      }
      .wrapper form .input-box{
        height: 60px; /* Increased input box height */
        margin: 20px 0; /* More space between input boxes */
      }
      form .input-box input{
        height: 100%;
        width: 100%;
        outline: none;
        padding: 0 20px; /* Increased padding */
        font-size: 18px; /* Larger font size */
        font-weight: 400;
        color: #333;
        border: 1.5px solid #C7BEBE;
        border-bottom-width: 3px; /* Thicker bottom border */
        border-radius: 8px; /* Slightly rounder corners */
        transition: all 0.3s ease;
      }
      .input-box input:focus,
      .input-box input:valid{
        border-color: #4070f4;
      }
      form .policy{
        display: flex;
        align-items: center;
      }
      form h3{
        color: #707070;
        font-size: 16px; /* Larger text for the policy */
        font-weight: 500;
        margin-left: 12px; /* Slightly more space */
      }
      .input-box.button input{
        color: #fff;
        letter-spacing: 1px;
        border: none;
        background: #4070f4;
        cursor: pointer;
        font-size: 18px; /* Larger button text */
      }
      .input-box.button input:hover{
        background: #0e4bf1;
      }
      form .text h3{
        color: #333;
        width: 100%;
        text-align: center;
      }
      form .text h3 a{
        color: #4070f4;
        text-decoration: none;
      }
      form .text h3 a:hover{
        text-decoration: underline;
      }
    </style>
    </head>
<body>
<div class="wrapper">
      <h2>Connexion</h2>
      <form action="AdminLoginServlet" method="POST">
        <div class="input-box">
          <input type="email" name="email" placeholder="Enter your email"  value="${email != null ? email : ''}" required>
        </div>
        <div class="input-box">
          <input type="password" name="password" placeholder="Enter your password" required>
        </div>
        <p style="color: red;">
        ${errorMessage != null ? errorMessage : ''}
    </p>
        <div class="input-box button">
          <input type="submit" value="Login">
        </div>
        <div class="text">
          <h3>Don't have an account?<a href="inscription.jsp">Sign up now</a></h3>
        </div>
      </form>
      
    </div>
</body>

</html>