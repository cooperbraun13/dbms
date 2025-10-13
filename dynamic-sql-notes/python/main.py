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