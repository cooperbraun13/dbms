import java.sql.*;
import java.util.Properties;

public class SQLTest1 {

  public static void main(String[] args) throws Exception {
    // connection string
    String url = "jdbc:postgresql://cps-postgresql.gonzaga.edu/";
    // connection properties
    Properties props = new Properties();
    // username
    props.setProperty("user", "your username");
    // password
    props.setProperty("password", "your password");
    // database to connect to
    props.setProperty("database", "your database");
    // create the connection
    Connection cn = DriverManager.getConnection(url, props);
    // create a simple (non-prepared) statement
    Statement st = cn.createStatement();
    // the query string
    String q = "SELECT id, name FROM pet ORDER BY name";
    // execute query
    ResultSet rs = st.executeQuery(q);
    // for each row in result set
    while (rs.next()) {
      // get the (int-valued) id
      int id = rs.getInt("id");
      // get the (string-valued) name
      String name = rs.getString("name");
      // print
      System.out.println(id + ", " + name);
    }
    // release the result set
    rs.close();
    // release the statement
    st.close();
    // close the connection
    cn.close();
  }
}
