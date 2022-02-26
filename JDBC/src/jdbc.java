package JDBC.src;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class jdbc{
    public static void main(String[] args){


        String connectionUrl ="jdbc:sqlserver://localhost:1433;databaseName=caso1;user=sa2;password=pass";

        try (Connection connection = DriverManager.getConnection(connectionUrl);) {
            // Code here.
        }
        // Handle any errors that may have occurred.
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
    }
