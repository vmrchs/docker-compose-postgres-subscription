-- Create orders table on master
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    product_name TEXT,
    quantity INTEGER,
    order_date DATE
);

-- Insert sample data
INSERT INTO orders (product_name, quantity, order_date) VALUES 
('Laptop', 2, '2024-03-27'),
('Smartphone', 1, '2024-03-28'),
('Headphones', 3, '2024-03-29');

-- Create publication for logical replication
CREATE PUBLICATION orders_pub FOR TABLE orders;