package JDBC.src;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class jdbc{


    public static void main(String[] args){
        query1();
        query2();        
    }

    public static void consulta1(String canton){

        //se conecta la base de datos con el programa de java, con los credenciales
        String connectionUrl ="jdbc:sqlserver://localhost:1433;databaseName=Aseni;user=sa2;password=pass;encrypt=true; trustServerCertificate=true;";

        try (Connection conn = DriverManager.getConnection(connectionUrl);) {
            //se ejecutan los llamados a la base de datos necesarios, en este caso la llamada al procedimiento almacenado
            //y como parametro el canton que se quiera consultar
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("spEntregablesPorCanton "+canton);

            while (rs.next()){
                //se obtiene la información del query y se muestra
                String nomPart=rs.getString("Partido");
                String entr=rs.getString("Descripcion");
                System.out.println(nomPart+"  "+entr);
            }
        }
        //Manejo de algún error que pueda ocurrir
        catch (SQLException e) {
            e.printStackTrace();
        }
    }


    //Función que crea los 10 hilos, cada uno con una llamada a la consulta 1 con un cantón diferente
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

        //inicia el conteo del tiempo en milisegundos, después de crear los hilos, pero antes de ponerlos a correr
        long inicioT = System.currentTimeMillis();

        //comienzan a correr los hilos haciendo las consultas de cada uno
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

        //hago un join para esperar que termine el hilo y poder detener el tiempo
        try {
            h10.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        //se detiene e imprime el tiempo que duró el Query 1 en total
        long finalT = System.currentTimeMillis();
        long total = finalT-inicioT;
        System.out.println("El query 1 tardó: "+total+" milisegundos"); 
    }

    public static void consulta2(){

        //se conecta la base de datos con el programa de java, con los credenciales
        //En los ultimos parametros del string de conexion se configura el CONECTION POOLING
        String connectionUrl ="jdbc:sqlserver://localhost:1433;databaseName=Aseni;user=sa2;password=pass;encrypt=true; trustServerCertificate=true";

        try (Connection conn = DriverManager.getConnection(connectionUrl);) {
            // Aquí se ejecuta el query que deseemos
            Statement stmt = conn.createStatement();

            //se ejecutan los llamados a la base de datos necesarios, en este caso el inline query completo
            //de cantones que recibieron entregables de maximo 25% de los partidos
            ResultSet rs = stmt.executeQuery("SELECT Canton.IDCanton CantonNumero, Canton.Nombre Canton, COUNT(*) CantidadEntregables FROM Canton INNER JOIN EntregablesPorCanton ON EntregablesPorCanton.IDCanton=Canton.IDCanton INNER JOIN Entregable ON Entregable.IDEntregable=EntregablesPorCanton.IDEntregable INNER JOIN (SELECT COUNT(*) CantPart FROM Partido) AS aux ON aux.CantPart>0 GROUP BY Canton.IDCanton, Canton.Nombre, CantPart HAVING aux.CantPart/4>= COUNT(DISTINCT Entregable.IDPartido);");
            
            while (rs.next()){
                //Obtener los datos del query y mostrarlos en pantalla
                String cantNum=rs.getString("CantonNumero");
                String cantNom=rs.getString("Canton");
                String cantEnt=rs.getString("CantidadEntregables");
                System.out.println(cantNum+"  "+cantNom+"  "+cantEnt);
            }
        }
        // Por si ocurre un error se maneja
        catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //Función que crea los 10 hilos, que van a ejecutar el inline query cada uno
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
        
        //inicia el conteo del tiempo en milisegundos, después de crear los hilos, pero antes de ponerlos a correr
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

        //hago un join para esperar que termine el hilo y poder detener el tiempo
        try {
            h10.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        //se detiene e imprime el tiempo que duró el Query 2 en total
        long finalT = System.currentTimeMillis();
        long total = finalT-inicioT;
        System.out.println("El query 2 tardó: "+total+" milisegundos");
        
    }

}

