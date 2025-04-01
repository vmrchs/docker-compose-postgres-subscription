-- Create the same table structure on replica
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    product_name TEXT,
    quantity INTEGER,
    order_date DATE
);