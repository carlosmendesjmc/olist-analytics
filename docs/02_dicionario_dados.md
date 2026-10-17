# Dicionário de Dados

## Tabelas utilizadas

### orders (olist_orders_dataset.csv)
Um registro por pedido. Tabela central do projeto.
| Coluna | Descrição |
|---|---|
| order_id | Identificador do pedido (chave) |
| customer_id | Cliente do pedido |
| order_status | Status (delivered, canceled, shipped...) |
| order_purchase_timestamp | Data da compra |
| order_delivered_customer_date | Data real da entrega |
| order_estimated_delivery_date | Data prometida de entrega |

### order_items (olist_order_items_dataset.csv)
Um registro por item do pedido.
| Coluna | Descrição |
|---|---|
| order_id | Pedido ao qual o item pertence |
| product_id | Produto vendido |
| seller_id | Vendedor |
| price | Preço do item |
| freight_value | Valor do frete |

### customers (olist_customers_dataset.csv)
| Coluna | Descrição |
|---|---|
| customer_id | Ligação com orders |
| customer_unique_id | Cliente real (um cliente pode ter vários customer_id) |
| customer_city | Cidade |
| customer_state | Estado (UF) |

### products (olist_products_dataset.csv)
| Coluna | Descrição |
|---|---|
| product_id | Identificador do produto |
| product_category_name | Categoria (em português) |

### reviews (olist_order_reviews_dataset.csv)
| Coluna | Descrição |
|---|---|
| order_id | Pedido avaliado |
| review_score | Nota de 1 a 5 |

### category_translation (product_category_name_translation.csv)
Tradução das categorias para inglês. Uso opcional.

## Relacionamentos
- orders → order_items por `order_id`
- orders → customers por `customer_id`
- orders → reviews por `order_id`
- order_items → products por `product_id`

## Pontos de atenção
- Pedidos não entregues não têm data de entrega (valor vazio).
- Para contar clientes únicos, usar `customer_unique_id`.