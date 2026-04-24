USE coffee_machine_db;

SET @OLD_SQL_SAFE_UPDATES = @@SQL_SAFE_UPDATES;
SET SQL_SAFE_UPDATES = 0;

INSERT INTO employee (
    employee_id,
    employee_code,
    name,
    role,
    pin_code,
    is_authorized_cash,
    is_authorized_inventory,
    is_active,
    created_at
) VALUES
    (1, 'EMP001', 'Philip Hansen', 'admin', '1234', 1, 1, 1, '2026-04-01 08:00:00'),
    (2, 'EMP002', 'Mikkel Jensen', 'employee', '2345', 0, 0, 1, '2026-04-01 08:05:00'),
    (3, 'EMP003', 'Sara Nielsen', 'cleaner', '3456', 0, 0, 1, '2026-04-01 08:10:00'),
    (4, 'EMP004', 'Jonas Larsen', 'technician', '4567', 0, 1, 1, '2026-04-01 08:15:00');

INSERT INTO drink (
    drink_id,
    name,
    price,
    is_active,
    created_at
) VALUES
    (1, 'Espresso', 18.00, 1, '2026-04-01 09:00:00'),
    (2, 'Americano', 22.00, 1, '2026-04-01 09:00:00'),
    (3, 'Cappuccino', 28.00, 1, '2026-04-01 09:00:00'),
    (4, 'Latte', 30.00, 1, '2026-04-01 09:00:00');

INSERT INTO ingredient (
    ingredient_id,
    name,
    unit,
    minimum_threshold,
    created_at
) VALUES
    (1, 'Coffee beans', 'g', 250.00, '2026-04-01 09:05:00'),
    (2, 'Water', 'ml', 1000.00, '2026-04-01 09:05:00'),
    (3, 'Milk', 'ml', 750.00, '2026-04-01 09:05:00');

INSERT INTO drink_ingredient (
    drink_id,
    ingredient_id,
    amount_required
) VALUES
    (1, 1, 18.00),
    (1, 2, 40.00),
    (2, 1, 18.00),
    (2, 2, 160.00),
    (3, 1, 18.00),
    (3, 2, 40.00),
    (3, 3, 120.00),
    (4, 1, 18.00),
    (4, 2, 40.00),
    (4, 3, 180.00);

INSERT INTO machine_inventory (
    ingredient_id,
    quantity,
    last_updated
) VALUES
    (1, 1000.00, '2026-04-01 09:10:00'),
    (2, 5000.00, '2026-04-01 09:10:00'),
    (3, 3000.00, '2026-04-01 09:10:00');

INSERT INTO remote_inventory (
    ingredient_id,
    quantity,
    last_updated
) VALUES
    (1, 5000.00, '2026-04-01 09:10:00'),
    (2, 20000.00, '2026-04-01 09:10:00'),
    (3, 10000.00, '2026-04-01 09:10:00');

INSERT INTO cash_transaction (
    cash_transaction_id,
    employee_id,
    purchase_id,
    withdrawal_id,
    transaction_type,
    amount_change,
    note,
    transaction_time
) VALUES
    (1, 1, NULL, NULL, 'change_refill', 200.00, 'Initial cash for change', '2026-04-01 09:15:00');

INSERT INTO purchase (
    purchase_id,
    drink_id,
    payment_type,
    amount_paid,
    purchased_at
) VALUES
    (1, 1, 'cash', 18.00, '2026-04-02 10:15:00'),
    (2, 3, 'card', 28.00, '2026-04-02 10:20:00'),
    (3, 2, 'cash', 22.00, '2026-04-03 11:05:00'),
    (4, 4, 'card', 30.00, '2026-04-03 11:15:00');

INSERT INTO cash_withdrawal (
    withdrawal_id,
    employee_id,
    amount,
    reason,
    withdrawn_at
) VALUES
    (1, 1, 50.00, 'Daily cash pickup', '2026-04-03 16:00:00');

INSERT INTO cleaning_log (
    cleaning_id,
    employee_id,
    cleaned_at,
    notes
) VALUES
    (1, 3, '2026-04-02 18:00:00', 'Daily cleaning completed'),
    (2, 1, '2026-04-03 18:10:00', 'Machine rinsed and checked');

INSERT INTO stock_transfer (
    transfer_id,
    employee_id,
    transferred_at,
    note
) VALUES
    (1, 4, '2026-04-04 08:30:00', 'Refill machine inventory from remote storage');

INSERT INTO stock_transfer_item (
    transfer_item_id,
    transfer_id,
    ingredient_id,
    quantity
) VALUES
    (1, 1, 1, 500.00),
    (2, 1, 2, 2000.00),
    (3, 1, 3, 1000.00);

SET SQL_SAFE_UPDATES = @OLD_SQL_SAFE_UPDATES;
