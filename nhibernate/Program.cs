
using System;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Threading;
using System.Diagnostics;


namespace Aseni{

     public class Program
    {
        static void Main(string[] args)
        {            
            
            //consulta2();           

        }

//-------------------------------------------------------------------------------QUERY 1-----------------------------------------------------------------------------------------

        public static void HilosConsulta1(){
            //Se crean los hilos con un canton diferente cada uno
            Thread H1 = new Thread(()=>consulta1("'Turrialba'"));
            Thread H2 = new Thread(()=>consulta1("'Zarcero'"));
            Thread H3 = new Thread(()=>consulta1("'Limon'"));
            Thread H4 = new Thread(()=>consulta1("'Flores'"));
            Thread H5 = new Thread(()=>consulta1("'Palmares'"));
            Thread H6 = new Thread(()=>consulta1("'Hojancha'"));
            Thread H7 = new Thread(()=>consulta1("'Belen'"));
            Thread H8 = new Thread(()=>consulta1("'Tibas'"));
            Thread H9 = new Thread(()=>consulta1("'Liberia'"));
            Thread H10 = new Thread(()=>consulta1("'Matina'"));


            //Se comienza a hacer el conteo del tiempo, después de crear los hilos, para sólo contar el tiempo de las consultas de cada hilo
            var tiempo = new Stopwatch();
            tiempo.Start();

            //Se ponen a correr los hilos todos al mismo tiempo
            H1.Start();
            H2.Start();
            H3.Start();
            H4.Start();
            H5.Start();
            H6.Start();
            H7.Start();
            H8.Start();
            H9.Start();
            H10.Start();
            H10.Join();

            //Se detiene el tiempo
            tiempo.Stop();
            var tiempoTotal=tiempo.ElapsedMilliseconds;
            Console.WriteLine("Tiempo total del Query 1: "+tiempoTotal+" milisegundos");
        }

        public static void consulta1(string Canton){
            //String de conexión con la base que es, con autenticación de MSSQL. Se pone el POOLING en FALSE para evitar que se use el pool que SqlConnection utiliza por defecto
            string connectionString = "Server=localhost;Database=Aseni;User Id=sa2;Password=pass;Pooling=false";

            // Creo la conexión con el string necesario
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Se abre la conexión
                conn.Open();
                // CSe crea una instancia de comandos con SQL
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = "spEntregablesPorCanton "+Canton;

                    //Se crea un lector, donde se almacenarán los datos que se extraigan en SQL
                    SqlDataReader lector = cmd.ExecuteReader();

                    //Se hace un ciclo para leer los datos que hay en lector hasta que sean nulos
                    while (lector.Read())
                    {
                        // ALmaceno en variables los datos sacados del SQL, especificamente los que me da el procedimiento almacenado que se utiliza
                        string nombrePartido = lector["Partido"].ToString();
                        string Entregable = lector["Descripcion"].ToString();

                        //Escribimos los datos utilizados en la consola
                        Console.WriteLine(nombrePartido);
                        Console.WriteLine(Entregable);
                    }
                    //Cerramos el lector de la conexión 
                    lector.Close();
                }
            }
        }

        public static void HilosConsulta2(){
            //Se crean los hilos con un canton diferente cada uno
            Thread H1 = new Thread(consulta2);
            Thread H2 = new Thread(consulta2);
            Thread H3 = new Thread(consulta2);
            Thread H4 = new Thread(consulta2);
            Thread H5 = new Thread(consulta2);
            Thread H6 = new Thread(consulta2);
            Thread H7 = new Thread(consulta2);
            Thread H8 = new Thread(consulta2);
            Thread H9 = new Thread(consulta2);
            Thread H10 = new Thread(consulta2);


            //Se comienza a hacer el conteo del tiempo, después de crear los hilos, para sólo contar el tiempo de las consultas de cada hilo
            var tiempo = new Stopwatch();
            tiempo.Start();

            //Se ponen a correr los hilos todos al mismo tiempo
            H1.Start();
            H2.Start();
            H3.Start();
            H4.Start();
            H5.Start();
            H6.Start();
            H7.Start();
            H8.Start();
            H9.Start();
            H10.Start();
            H10.Join();

            //Se detiene el tiempo
            tiempo.Stop();
            var tiempoTotal=tiempo.ElapsedMilliseconds;
            Console.WriteLine("Tiempo total del Query 2: "+tiempoTotal+" milisegundos");
        }

        public static void consulta2(){
            //String de conexión con la base que es, con autenticación de MSSQL. Se pone el POOLING en FALSE para evitar que se use el pool que SqlConnection utiliza por defecto
            string connectionString = "Server=localhost;Database=Aseni;User Id=sa2;Password=pass;Pooling=false";

            // Creo la conexión con el string necesario
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Se abre la conexión
                conn.Open();
                // CSe crea una instancia de comandos con SQL
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = "SELECT Canton.IDCanton CantonNumero, Canton.Nombre Canton, COUNT(*) CantidadEntregables FROM Canton"+
                                      "INNER JOIN EntregablesPorCanton ON EntregablesPorCanton.IDCanton=Canton.IDCanton"+
                                      "INNER JOIN Entregable ON Entregable.IDEntregable=EntregablesPorCanton.IDEntregable"+
                                      "INNER JOIN (SELECT COUNT(*) CantPart FROM Partido) AS aux ON aux.CantPart>0"+
                                      "GROUP BY Canton.IDCanton, Canton.Nombre, CantPart"+
                                      "HAVING aux.CantPart/4>= COUNT(DISTINCT Entregable.IDPartido);";

                    //Se crea un lector, donde se almacenarán los datos que se extraigan en SQL
                    SqlDataReader lector = cmd.ExecuteReader();

                    //Se hace un ciclo para leer los datos que hay en lector hasta que sean nulos
                    while (lector.Read())
                    {
                        // ALmaceno en variables los datos sacados del SQL, especificamente los que me da el procedimiento almacenado que se utiliza
                        string cantonNum = lector["CantonNumero"].ToString();
                        string cantonNom = lector["Canton"].ToString();
                        string cantEntr = lector["CantidadEntregables"].ToString();

                        //Escribimos los datos utilizados en la consola
                        Console.WriteLine(cantonNum);
                        Console.WriteLine(cantonNom);
                        Console.WriteLine(cantEntr);
                    }
                    //Cerramos el lector de la conexión 
                    lector.Close();
                }
            }            
        }
















    }
}
