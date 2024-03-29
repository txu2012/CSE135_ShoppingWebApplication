<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.PrintWriter" import="java.sql.*" import="java.util.*" import="javax.servlet.annotation.WebServlet" import="CSE135.SQL_Tables"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Confirmation</title>
		<h3>Confirmation Page</h3>
		<%
			
			Connection connection = SQL_Tables.connect();
			String purchaseDate = (String)session.getAttribute("purchaseDate");
			String username = (String)session.getAttribute("user");
			
			Object newMsg = session.getAttribute("msg");
			if(newMsg != null){
				PrintWriter writer = response.getWriter();
				out.println(session.getAttribute("msg"));
			}
			else{
		%>
		<script type = "text/javascript">
				alert("No users logged in");
				window.location = "login.jsp";
		</script>
	</head>
	<body>
	<% 
			}
			
			String prevLink = request.getParameter("prevLink");

			System.out.println(prevLink);
			if(prevLink == null || prevLink.equals("") || !prevLink.equals("buy_shopping_cart")){
			%>
				<script type="text/javascript"> 
					alert("Invalid request");
					window.location = "product_browsing.jsp";
				</script>
			<%
			}
				
			float totalPrice = 0;
			PreparedStatement pstmt = connection.prepareStatement("SELECT * FROM purchased WHERE purchasedUser = '" + username + "' AND purchasedDate = '" + purchaseDate + "';");
			ResultSet results = pstmt.executeQuery();
	%>
		<table border="1">
			<tr>
				<th>Product Name</th>
				<th>Product Price</th>
				<th>Product Amount</th>
			</tr>
			
			<%
				while(results.next()) {
					int amount = results.getInt("purchasedAmount");
					float currentPrice = results.getFloat("purchasedPrice");
					totalPrice = totalPrice + (currentPrice * (float)amount);
			%>
				<tr>
					<td><%= results.getString("purchasedName") %></td>
					<td><%= results.getFloat("purchasedPrice") %></td>
					<td><%= results.getInt("purchasedAmount") %></td>
				</tr>
			<% } %>
		</table>
		<p>Total Price: <%= totalPrice %></p>
		
		<%
			Object userRole = session.getAttribute("roleType");
			if(userRole != null && userRole.equals("Owner")){
		%>		
				<ul>
					<li><a href="index.jsp">Home</a></li>
					<li><a href="category.jsp">Category</a></li>
					<li><a href="product_browsing.jsp">Product Browsing</a></li>
					<li><a href="products.jsp">Products</a></li>		
				</ul>
		<%	
			}
			else{
		%>
				<ul>
					<li><a href="product_browsing.jsp">Product Browsing</a></li>	
				</ul>
		<% } %>
	</body>
</html>