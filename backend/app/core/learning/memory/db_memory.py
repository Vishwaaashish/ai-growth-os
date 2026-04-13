import psycopg2

def get_connection():
    return psycopg2.connect(
    dbname="postgres",
    user="odoo",
    password="odoo",
    host="localhost",
    port="5432"
)
