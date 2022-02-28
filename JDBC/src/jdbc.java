package JDBC.src;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class jdbc{

    public static void main(String[] args){

        query2();

        
    }

    public static void consulta1(String canton){

    
        String connectionUrl ="jdbc:sqlserver://localhost:1433;databaseName=Aseni;user=sa2;password=pass;encrypt=true; trustServerCertificate=true;";

        try (Connection conn = DriverManager.getConnection(connectionUrl);) {
            // Code here.
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("spEntregablesPorCanton "+canton);

            while (rs.next()){
                String nomPart=rs.getString("Partido");
                String entr=rs.getString("Descripcion");
                System.out.println(nomPart+"  "+entr);
            }
        }
        // Handle any errors that may have occurred.
        catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void query1(){
        Thread h1= new Thread(()->{
            consulta1("'Turrialba'");
        });
        Thread h2= new Thread(()->{
            consulta1("'Zarcero'");
        });
        Thread h3= new Thread(()->{
            consulta1("'Limon'");
        });
        Thread h4= new Thread(()->{
            consulta1("'Flores'");
        });
        Thread h5= new Thread(()->{
            consulta1("'Palmares'");
        });
        Thread h6= new Thread(()->{
            consulta1("'Hojancha'");
        });
        Thread h7= new Thread(()->{
            consulta1("'Belen'");
        });
        Thread h8= new Thread(()->{
            consulta1("'Tibas'");
        });
        Thread h9= new Thread(()->{
            consulta1("'Liberia'");
        });
        Thread h10= new Thread(()->{
            consulta1("'Matina'");
        });

        long inicioT = System.currentTimeMillis();

        h1.start();
        h2.start();
        h3.start();
        h4.start();
        h5.start();
        h6.start();
        h7.start();
        h8.start();
        h9.start();
        h10.start();

        try {
            h10.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        

        long finalT = System.currentTimeMillis();
        long total = finalT-inicioT;
        System.out.println("El query 1 tardó: "+total+"milisegundos"); 
    }

    public static void consulta2(){

        
        String connectionUrl ="jdbc:sqlserver://localhost:1433;databaseName=Aseni;user=sa2;password=pass;encrypt=true; trustServerCertificate=true;";

        try (Connection conn = DriverManager.getConnection(connectionUrl);) {
            // Aquí se ejecuta el query que deseemos
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT Canton.IDCanton CantonNumero, Canton.Nombre Canton, COUNT(*) CantidadEntregables FROM Canton INNER JOIN EntregablesPorCanton ON EntregablesPorCanton.IDCanton=Canton.IDCanton INNER JOIN Entregable ON Entregable.IDEntregable=EntregablesPorCanton.IDEntregable INNER JOIN (SELECT COUNT(*) CantPart FROM Partido) AS aux ON aux.CantPart>0 GROUP BY Canton.IDCanton, Canton.Nombre, CantPart HAVING aux.CantPart/4>= COUNT(DISTINCT Entregable.IDPartido);");
            
            while (rs.next()){
                //Obtener los datos del query y mostrarlos en pantalla
                String cantNum=rs.getString("CantonNumero");
                String cantNom=rs.getString("Canton");
                String cantEnt=rs.getString("CantidadEntregables");
                System.out.println(cantNum+"  "+cantNom+"  "+cantEnt);
            }
        }
        // Por si ocurre un error
        catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void query2(){
        Thread h1 = new Thread(()->consulta2());
        Thread h2 = new Thread(()->consulta2());
        Thread h3 = new Thread(()->consulta2());
        Thread h4 = new Thread(()->consulta2());
        Thread h5 = new Thread(()->consulta2());
        Thread h6 = new Thread(()->consulta2());
        Thread h7 = new Thread(()->consulta2());
        Thread h8 = new Thread(()->consulta2());
        Thread h9 = new Thread(()->consulta2());
        Thread h10 = new Thread(()->consulta2());
        
        long inicioT = System.currentTimeMillis();

        h1.start();
        h2.start();
        h3.start();
        h4.start();
        h5.start();
        h6.start();
        h7.start();
        h8.start();
        h9.start();
        h10.start();

        try {
            h10.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        long finalT = System.currentTimeMillis();
        long total = finalT-inicioT;
        System.out.println("El query 2 tardó: "+total+"milisegundos");
        
    }

}
