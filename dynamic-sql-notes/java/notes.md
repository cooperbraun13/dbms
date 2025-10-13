### Java Database Connectivity (JDBC) API

- A Java API for accessing RDBMSs (RDBMS independent)
- Each specific DBMS implements a JDBC "driver" (i.e., the API)
- Similar to MS ODBC (the original)
- Many languages today have DBMS-specific libraries
- ... but most follow JDBC/ODBC style

### Must install the specific JDBC driver for your system

- The JDBC API comes standard in Java (but not the Driver)
- PostgreSQL JDBC Driver: `https://jdbc.postgresql.org/`
- This is just a jar file ...

### Java and JDBC: A Simple Example

```java
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
```

**Note:** examples here take some shortcuts to keep things simple

- exception handling (try-catch blocks), error checking, etc.
- see the example code for more examples

To compile and run the program (with installation of connector):

```bash
$ javac SQLTest1.java
$ java -cp .:lib/postgresql-42.7.4.jar SQLTest1
1, bill
4, donald
```

...
