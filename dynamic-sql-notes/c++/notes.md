### C++ Example using the PostgreSQL C++ Binding (libpqxx)

```c++
#include <iostream>
#include <pqxx/pqxx>

using namespace std;
using namespace pqxx;

int main()
{
  // conection info
  string hst = "cps-database.gonzaga.edu";
  string usr = "your_usename";
  string dat = "your_database";
  string pwd = "your_password";
  string url = "postgresql://" + usr + ":" + pwd + "@" + hst + "/" + dat;
  // create a connection
  connection cx{url};
  work tx(cx);
  // execute a query
  string q = "SELECT id, name FROM pet ORDER BY name";
  result r{tx.exec(q)};
  for (auto row : r)
  {
    cout << row["id"].as<int>() << ", " << row["name"].c_str() << endl;
  }
}
```

To install library: See `https://pqxx.org/libpqxx`

- like much of C++, much easier in Linux and MacOS

To compile and run (assuming running on Linux):

```bash
g++ sql_test_1.cpp -lpqxx -lpq -o sql-test-1
./sql_test_1
```

Note: More examples in libpqxx documentation (see website above)
