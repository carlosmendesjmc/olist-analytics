"""Carrega os CSVs da Olist (data/raw) pa ao PostgreSQL, sem alterar nada."""

import os 
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine

load_dotenv()

engine = create_engine(os.environ["DATABASE_URL"])

RAW_DIR = Path(__file__).resolve().parent.parent / "data" / "raw"
 
ARQUIVOS = {
      "raw_orders": "olist_orders_dataset.csv",
    "raw_order_items": "olist_order_items_dataset.csv",
    "raw_customers": "olist_customers_dataset.csv",
    "raw_products": "olist_products_dataset.csv",
    "raw_reviews": "olist_order_reviews_dataset.csv",
    "raw_category_translation": "product_category_name_translation.csv",
 }

for tabela, arquivo in ARQUIVOS.items():
    
        df = pd.read_csv(RAW_DIR / arquivo)
    
        df.to_sql(tabela, engine, if_exists= "replace", index=False, chunksize=5000, method="multi")
    
        print(f"{tabela}: {len(df):,} linhas carregadas")
    
print("Carga conclcuida.")