-- =============================================================
-- 01_views.sql
-- Camada de análise: limpa e organiza os dados brutos (raw_)
-- sem alterá-los. Modelo estrela: dim_ descreve, fct_ mede.
-- =============================================================

-- Schema separado para a camada limpa (organização profissional)
CREATE SCHEMA IF NOT EXISTS analytics;


-- -------------------------------------------------------------
-- dim_customers: um registro por customer_id
-- -------------------------------------------------------------
CREATE OR REPLACE VIEW analytics.dim_customers AS
SELECT
    customer_id,
    customer_unique_id,
    INITCAP(customer_city) AS city,     -- "sao paulo" vira "Sao Paulo"
    customer_state         AS state
FROM raw_customers;


-- -------------------------------------------------------------
-- dim_products: produto com categoria tratada
-- -------------------------------------------------------------
CREATE OR REPLACE VIEW analytics.dim_products AS
SELECT
    p.product_id,
    COALESCE(p.product_category_name, 'sem_categoria')         AS category,
    COALESCE(t.product_category_name_english, 'uncategorized') AS category_en
FROM raw_products p
LEFT JOIN raw_category_translation t
       ON t.product_category_name = p.product_category_name;


-- -------------------------------------------------------------
-- fct_orders: um registro por pedido, com métricas de entrega
-- e nota média de avaliação
-- -------------------------------------------------------------
CREATE OR REPLACE VIEW analytics.fct_orders AS
WITH reviews AS (
    -- Alguns pedidos têm mais de uma avaliação: usamos a média
    SELECT
        order_id,
        ROUND(AVG(review_score), 1) AS review_score
    FROM raw_reviews
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp::timestamp       AS purchased_at,
    o.order_delivered_customer_date::timestamp  AS delivered_at,
    o.order_estimated_delivery_date::timestamp  AS estimated_delivery_at,

    -- Dias entre a compra e a entrega
    o.order_delivered_customer_date::date
      - o.order_purchase_timestamp::date        AS delivery_days,

    -- Atrasou? (vazio quando o pedido não foi entregue)
    CASE
        WHEN o.order_delivered_customer_date IS NULL THEN NULL
        WHEN o.order_delivered_customer_date::date
             > o.order_estimated_delivery_date::date THEN TRUE
        ELSE FALSE
    END                                         AS is_late,

    r.review_score
FROM raw_orders o
LEFT JOIN reviews r ON r.order_id = o.order_id;


-- -------------------------------------------------------------
-- fct_order_items: um registro por item vendido
-- -------------------------------------------------------------
CREATE OR REPLACE VIEW analytics.fct_order_items AS
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    price,
    freight_value,
    price + freight_value AS total_value
FROM raw_order_items;