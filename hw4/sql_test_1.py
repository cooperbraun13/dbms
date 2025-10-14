import psycopg2 as pg
import config

def main():
  # connection info
  hst = config.HOST
  usr = config.USER
  pwd = config.PASSWORD
  dat = config.DATABASE

  # make a connection
  with pg.connect(host=hst, user=usr, password=pwd, dbname=dat) as cn:
    # make a cursor
    with cn.cursor() as rs: 
      # execute a query
      q = 'SELECT id, name FROM pet ORDER BY name'
      rs.execute(q)
      # display results
      for row in rs:
        print(f'{row[0]}, {row[1]}')

if __name__ == '__main__':
  main()