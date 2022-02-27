using System;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Threading;
using System.Diagnostics;




     public class Query2
    {
        static void Maun(string[] args)
        {            
            //Se crean los hilos con un canton diferente cada uno
            Thread H1 = new Thread(()=>consulta("'Turrialba'"));
            Thread H2 = new Thread(()=>consulta("'Zarcero'"));
            Thread H3 = new Thread(()=>consulta("'Limon'"));
            Thread H4 = new Thread(()=>consulta("'Flores'"));
            Thread H5 = new Thread(()=>consulta("'Palmares'"));
            Thread H6 = new Thread(()=>consulta("'Hojancha'"));
            Thread H7 = new Thread(()=>consulta("'Belen'"));
            Thread H8 = new Thread(()=>consulta("'Tibas'"));
            Thread H9 = new Thread(()=>consulta("'Liberia'"));
            Thread H10 = new Thread(()=>consulta("'Matina'"));


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

        public static void consulta(string Canton){
            //String de conexión con la base que es, con autenticación de MSSQL
            string connectionString = "Server=localhost;Database=Aseni;User Id=sa2;Password=pass;";

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
    }