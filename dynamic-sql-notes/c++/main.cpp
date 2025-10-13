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