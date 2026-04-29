USE coffee_machine_db;

SET @OLD_SQL_SAFE_UPDATES = @@SQL_SAFE_UPDATES;
SET SQL_SAFE_UPDATES = 0;

INSERT INTO `role` (
    role_id,
    role_name,
    description
) VALUES
    (1, 'admin', 'Full access to the system'),
    (2, 'employee', 'Regular employee with no administrative permissions'),
    (3, 'cleaner', 'Can register machine cleaning'),
    (4, 'technician', 'Can update and transfer inventory');

INSERT INTO `permission` (
    permission_id,
    permission_name,
    description
) VALUES
    (1, 'UPDATE_CASH', 'Can update cash balance and withdraw cash'),
    (2, 'UPDATE_INVENTORY', 'Can update inventory and transfer stock'),
    (3, 'REGISTER_CLEANING', 'Can register cleaning events'),
    (4, 'CREATE_DRINK', 'Can create or change drinks and recipes');

INSERT INTO `role_permission` (
    role_id,
    permission_id
) VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (3, 3),
    (4, 2);

INSERT INTO employee (
    employee_id,
    employee_code,
    name,
    role_id,
    pin_code,
    is_active,
    created_at
) VALUES
    (1, 'EMP001', 'Philip Hansen', 1, '1234', 1, '2026-04-01 08:00:00'),
    (2, 'EMP002', 'Mikkel Jensen', 2, '2345', 1, '2026-04-01 08:05:00'),
    (3, 'EMP003', 'Sara Nielsen', 3, '3456', 1, '2026-04-01 08:10:00'),
    (4, 'EMP004', 'Jonas Larsen', 4, '4567', 1, '2026-04-01 08:15:00');

SET @login_employee_code = 'EMP001';
SET @login_pin_code = '1234';
SET @current_employee_id = NULL;

SELECT employee_id
INTO @current_employee_id
FROM employee
WHERE employee_code = CONVERT(@login_employee_code USING utf8mb4) COLLATE utf8mb4_unicode_ci
  AND pin_code = CONVERT(@login_pin_code USING utf8mb4) COLLATE utf8mb4_unicode_ci
  AND is_active = 1;

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
    (4, 'Latte', 30.00, 1, '2026-04-01 09:00:00'),
    (5, 'Flat White', 30.00, 1, '2026-04-01 09:00:00'),
    (6, 'Cortado', 24.00, 1, '2026-04-01 09:00:00'),
    (7, 'Mocha', 34.00, 1, '2026-04-01 09:00:00'),
    (8, 'Vanilla Latte', 34.00, 1, '2026-04-01 09:00:00'),
    (9, 'Caramel Oat Latte', 36.00, 1, '2026-04-01 09:00:00');

INSERT INTO ingredient (
    ingredient_id,
    name,
    unit,
    minimum_threshold,
    created_at
) VALUES
    (1, 'Coffee beans', 'g', 250.00, '2026-04-01 09:05:00'),
    (2, 'Water', 'ml', 1000.00, '2026-04-01 09:05:00'),
    (3, 'Milk', 'ml', 750.00, '2026-04-01 09:05:00'),
    (4, 'Sugar', 'g', 200.00, '2026-04-01 09:05:00'),
    (5, 'Cocoa powder', 'g', 150.00, '2026-04-01 09:05:00'),
    (6, 'Vanilla syrup', 'ml', 250.00, '2026-04-01 09:05:00'),
    (7, 'Caramel syrup', 'ml', 250.00, '2026-04-01 09:05:00'),
    (8, 'Oat milk', 'ml', 750.00, '2026-04-01 09:05:00');

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
    (4, 3, 180.00),
    (5, 1, 18.00),
    (5, 2, 35.00),
    (5, 3, 140.00),
    (6, 1, 18.00),
    (6, 2, 35.00),
    (6, 3, 60.00),
    (7, 1, 18.00),
    (7, 2, 40.00),
    (7, 3, 150.00),
    (7, 4, 8.00),
    (7, 5, 12.00),
    (8, 1, 18.00),
    (8, 2, 40.00),
    (8, 3, 180.00),
    (8, 6, 20.00),
    (9, 1, 18.00),
    (9, 2, 40.00),
    (9, 4, 5.00),
    (9, 7, 20.00),
    (9, 8, 180.00);

INSERT INTO machine_inventory (
    ingredient_id,
    quantity,
    last_updated
) VALUES
    (1, 1000.00, '2026-04-01 09:10:00'),
    (2, 5000.00, '2026-04-01 09:10:00'),
    (3, 3000.00, '2026-04-01 09:10:00'),
    (4, 500.00, '2026-04-01 09:10:00'),
    (5, 300.00, '2026-04-01 09:10:00'),
    (6, 700.00, '2026-04-01 09:10:00'),
    (7, 700.00, '2026-04-01 09:10:00'),
    (8, 2500.00, '2026-04-01 09:10:00');

INSERT INTO remote_inventory (
    ingredient_id,
    quantity,
    last_updated
) VALUES
    (1, 5000.00, '2026-04-01 09:10:00'),
    (2, 20000.00, '2026-04-01 09:10:00'),
    (3, 10000.00, '2026-04-01 09:10:00'),
    (4, 2000.00, '2026-04-01 09:10:00'),
    (5, 1500.00, '2026-04-01 09:10:00'),
    (6, 3000.00, '2026-04-01 09:10:00'),
    (7, 3000.00, '2026-04-01 09:10:00'),
    (8, 8000.00, '2026-04-01 09:10:00');

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
    (4, 4, 'card', 30.00, '2026-04-03 11:15:00'),
    (5, 7, 'cash', 34.00, '2026-04-04 09:30:00'),
    (6, 8, 'card', 34.00, '2026-04-04 09:45:00'),
    (7, 9, 'cash', 36.00, '2026-04-04 10:00:00');

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
    (3, 1, 3, 1000.00),
    (4, 1, 4, 250.00),
    (5, 1, 5, 200.00),
    (6, 1, 6, 500.00),
    (7, 1, 7, 500.00),
    (8, 1, 8, 1000.00);

SET @current_employee_id = NULL;
SET SQL_SAFE_UPDATES = @OLD_SQL_SAFE_UPDATES;
