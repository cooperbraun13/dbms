""" 
Name: Cooper Braun
Class: CPSC-321-01
Year: Fall 2025
Description: A simple text-based interface over the CIA World Factbook DB created in HW3.
Implements dynamic, parameterized queries from a single entry point.
"""

import psycopg as pg
from config import HOST, USER, PASSWORD, DATABASE

def q1(rs):
  q = "SELECT name, country_code, gdp, inflation FROM country ORDER BY name;"
  # no parameters needed
  rs.execute(q)
  
  for name, code, gdp, infl in rs:
    # format -> name (code), per capita gdp $gdp, inflation rate inflation%
    print(f"{name} ({code}), per capita gdp ${gdp}, inflation rate {infl}%")
  print()

def q2(cn, rs):
  # prompt user for inputs
  code = input("Country code..................: ")
  name = input("Country name..................: ")
  gdp = input("Country per capita gdp (USD)..: ")
  infl = input("Country inflation (pct).......: ")
  
  # check if the country code already exists
  q_check = "SELECT 1 FROM country WHERE country_code = %s;"
  rs.execute(q_check, (code,))
  
  # loops through result set to see if country already exists
  exists = False
  for row in rs:
    if row:
      exists = True
      break
  
  if exists:
    print(f"Country '{code}' already exists.\n")
    return

  # insert new country
  q_insert = "INSERT INTO country (country_code, name, gdp, inflation) VALUES (%s, %s, %s, %s);"
  rs.execute(q_insert, (code, name, gdp, infl))
  cn.commit()

def q3(cn, rs):
  # prompt user for inputs
  code1 = input("Country code 1..: ")
  code2 = input("Country code 2..: ")
  length = input("Border length...: ")
  
  if code1 == code2:
    print("A country cannot border itself.\n")
    return
  
  # enforce canonical order to satisfy: CHECK (country_code_1 < country_code_2)
  codea, codeb = (code1, code2) if code1 < code2 else (code2, code1)
  
  # check both countries exist
  q_exists = "SELECT country_code FROM country WHERE country_code = %s;"
  rs.execute(q_exists, (codea,))
  a_exists = False
  for row in rs:
    if row:
      a_exists = True
      break

  rs.execute(q_exists, (codeb,))
  b_exists = False
  for row in rs:
    if row:
      b_exists = True
      break

  if not a_exists or not b_exists:
    if not a_exists and not b_exists:
      print(f"Countries '{codea}' and '{codeb}' do not exist.\n")
    elif not a_exists:
      print(f"Country '{codea}' does not exist.\n")
    else:
      print(f"Country '{codeb}' does not exist.\n")
    return
  
  # check if border already exists (in either order)
  q_check = "SELECT country_code_1, country_code_2 FROM border WHERE country_code_1 = %s AND country_code_2 = %s;"
  rs.execute(q_check, (codea, codeb))
  
  exists = False
  for row in rs:
    if row:
      exists = True
      break
    
  if exists:
    print(f"Border between {codea} and {codeb} already exists.\n")
    return
    
  # insert new border
  q_insert = "INSERT INTO border (country_code_1, country_code_2, border_length) VALUES (%s, %s, %s);"
  rs.execute(q_insert, (codea, codeb, length))
  cn.commit()

def q4(rs):
  # prompt user for inputs
  min_gdp = input("Minimum per capita gdp (USD)..: ")
  max_gdp = input("Maximum per capita gdp (USD)..: ")
  min_infl = input("Minimum inflation (pct).......: ")
  max_infl = input("Maximum inflation (pct).......: ")
  
  q = """
  SELECT name, country_code, gdp, inflation 
  FROM country 
  WHERE gdp BETWEEN %s AND %s 
    AND inflation BETWEEN %s AND %s 
  ORDER BY gdp DESC, inflation ASC;
  """
  rs.execute(q, (min_gdp, max_gdp, min_infl, max_infl))
  
  for row in rs:
    print(f"{row[0]} ({row[1]}), per capita gdp ${row[2]}, inflation rate {row[3]}%")
  print()

def q5(cn, rs):
  # prompt user for inputs
  code = input("Country code..................: ")
  gdp = input("Country per capita gdp (USD)..: ")
  infl = input("Country inflation (pct).......: ")
  
  # check to see if country exists
  q_check = "SELECT country_code FROM country WHERE country_code = %s;"
  rs.execute(q_check, (code,))
  exists = False
  for row in rs:
    if row:
      exists = True
      break
    
  if not exists:
    print(f"Country '{code}' does not exist.\n")
    return
    
  # update gdp and inflation
  q_insert = "UPDATE country SET gdp = %s, inflation = %s WHERE country_code = %s;"
  rs.execute(q_insert, (gdp, infl, code))
  cn.commit()

def q6(cn, rs):
  # prompt for user inputs
  code1 = input("Country code 1..: ")
  code2 = input("Country code 2..: ")
  
  # enforce canonical order to satisfy: CHECK (country_code_1 < country_code_2)
  codea, codeb = (code1, code2) if code1 < code2 else (code2, code1)
  
  # check border exists
  q_check = "SELECT 1 FROM border WHERE country_code_1 = %s AND country_code_2 = %s;"
  rs.execute(q_check, (codea, codeb))
  exists = False
  for row in rs:
    if row:
      exists = True
      break
    
  if not exists:
    print(f"Border between {codea} and {codeb} does not exist.\n")
    return
  
  # remove border
  q_remove = "DELETE FROM border WHERE country_code_1 = %s AND country_code_2 = %s;"
  rs.execute(q_remove, (codea, codeb))
  cn.commit()

# main loop
def main():
  # connection info
  hst = HOST
  usr = USER
  pwd = PASSWORD
  dat = DATABASE
  
  cn = pg.connect(host=hst, user=usr, password=pwd, dbname=dat)
  rs = cn.cursor()
  
  try:
    while True:
      print("1. List countries")
      print("2. Add country")
      print("3. Add border")
      print("4. Find countries based on gdp and inflation")
      print("5. Update country's gdp and inflation")
      print("6. Remove border")
      print("7. Exit")

      choice = input("Enter your choice (1-7): ")
      
      if choice == "1":
        q1(rs)
      elif choice == "2":
        q2(cn, rs)
      elif choice == "3":
        q3(cn, rs)
      elif choice == "4":
        q4(rs)
      elif choice == "5":
        q5(cn, rs)
      elif choice == "6":
        q6(cn, rs)
      elif choice == "7":
        print("Exiting program...")
        break
      else:
        print("Invalid choice.")
  
  finally:
    rs.close()
    cn.close()
  
if __name__ == "__main__":
  main()