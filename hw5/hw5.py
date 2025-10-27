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
  pass

def q2(rs):
  pass

def q3(rs):
  pass

def q4(rs):
  pass

def q5(rs):
  pass

def q6(rs):
  pass

def q7(rs):
  pass

# main loop
def main():
  # connection info
  hst = HOST
  usr = USER
  pwd = PASSWORD
  dat = DATABASE
  
  cn = pg.connect(host=hst, user=usr, password=pwd, dbname=dat)
  rs = cn.cursor()
  
  
  while True:
    print("1. List countries")
    print("2. Add country")
    print("3. Add border")
    print("4. Find countries based on gdp and inflation")
    print("5. Update country's gdp and inflation")
    print("6. Remove border")
    print("7. Exit")

    choice = input("Enter your choice (1-7): ")
    
    if choice == "0":
      break
    elif choice == "1":
      q1(rs)
    elif choice == "2":
      q2(rs)
    elif choice == "3":
      q3(rs)
    elif choice == "4":
      q4(rs)
    elif choice == "5":
      q5(rs)
    elif choice == "6":
      q6(rs)
    elif choice == "7":
      q7(rs)
    else:
      print("Invalid choice.")
  
  rs.close()
  cn.close()
  
if __name__ == "__main__":
  main()