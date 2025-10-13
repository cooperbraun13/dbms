### Python Example using psycopg

```python
import psycopg2 as pg

def main():
  # connection info
  hst = 'cps-database.gonzaga.edu'
  usr = 'your_username'
  pwd = 'your_password'
  dat = 'your_database'
  # create a connection
  cn = pg.connect(host=hst, user=usr, password=pwd, database=dat)
  # make a cursor
  rs = cn.cursor()
  # execute the query
  q = 'SELECT id, name FROM pet ORDER BY name'
  rs.execute(q)
  # display results
  for row in rs:
    print(f'{row[0]}, {row[1]}')
  # close connection
  rs.close()
  cn.close()

if __name__ == '__main__':
  main()
```

To install: ... pip3 may just be pip for you

- via pip: pip3 install psycopg
- via conda: conda install psycopg

To Run: python3 may just be python for you

- python3 sql_test_1.py

Note: your setup may vary slightly
