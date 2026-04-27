USE coffee_machine_db;

-- The SELECT statements can be run freely.
-- Run INSERT, UPDATE and DELETE examples one at a time when testing changes.

SELECT
    e.employee_id,
    e.employee_code,
    e.name,
    r.role_name,
    e.is_active
FROM employee e
JOIN `role` r
    ON r.role_id = e.role_id
ORDER BY e.employee_id;

SELECT
    r.role_name,
    p.permission_name
FROM `role_permission` rp
JOIN `role` r
    ON r.role_id = rp.role_id
JOIN `permission` p
    ON p.permission_id = rp.permission_id
ORDER BY r.role_name, p.permission_name;

-- Manually read purchases/transactions with optional filters.
-- Change the values before running the SELECT.
-- Use NULL to ignore a filter.
SET @from_date = '2026-04-01 00:00:00';
SET @to_date = '2026-04-30 23:59:59';
SET @payment_type = NULL; -- 'cash', 'card' or NULL
SET @drink_name = NULL; -- for example 'Cappuccino' or NULL

SELECT
    p.purchase_id,
    p.purchased_at,
    d.name AS drink_name,
    p.payment_type,
    p.amount_paid,
    ct.transaction_type AS cash_transaction_type,
    ct.amount_change AS cash_amount_change
FROM purchase p
JOIN drink d
    ON d.drink_id = p.drink_id
LEFT JOIN cash_transaction ct
    ON ct.purchase_id = p.purchase_id
WHERE p.purchased_at BETWEEN @from_date AND @to_date
  AND (@payment_type IS NULL OR p.payment_type = CONVERT(@payment_type USING utf8mb4) COLLATE utf8mb4_unicode_ci)
  AND (@drink_name IS NULL OR d.name = CONVERT(@drink_name USING utf8mb4) COLLATE utf8mb4_unicode_ci)
ORDER BY p.purchased_at;

-- Add a new employee.
INSERT INTO employee (
    employee_code,
    name,
    role_id,
    pin_code,
    is_active,
    created_at
) VALUES (
    'EMP005',
    'New Employee',
    2,
    '5555',
    1,
    CURRENT_TIMESTAMP
);

-- Change an employee role.
UPDATE employee
SET role_id = (
    SELECT role_id
    FROM `role`
    WHERE role_name = 'cleaner'
)
WHERE employee_code = 'EMP005';

-- Deactivate and reactivate an employee.
UPDATE employee
SET is_active = 0
WHERE employee_code = 'EMP005';

UPDATE employee
SET is_active = 1
WHERE employee_code = 'EMP005';

-- Add a new role.
INSERT INTO `role` (
    role_name,
    description
) VALUES (
    'manager',
    'Can update cash and register cleaning'
);

-- Give permissions to a role.
INSERT INTO `role_permission` (
    role_id,
    permission_id
)
SELECT r.role_id, p.permission_id
FROM `role` r
JOIN `permission` p
WHERE r.role_name = 'manager'
  AND p.permission_name IN ('UPDATE_CASH', 'REGISTER_CLEANING');

-- Remove one permission from a role.
DELETE rp
FROM `role_permission` rp
JOIN `role` r
    ON r.role_id = rp.role_id
JOIN `permission` p
    ON p.permission_id = rp.permission_id
WHERE r.role_name = 'manager'
  AND p.permission_name = 'UPDATE_CASH';

-- This should work because employee_id 3 has REGISTER_CLEANING.
INSERT INTO cleaning_log (
    employee_id,
    cleaned_at,
    notes
) VALUES (
    3,
    CURRENT_TIMESTAMP,
    'Manual cleaning test'
);

-- This should work because employee_id 1 has UPDATE_CASH.
INSERT INTO cash_transaction (
    employee_id,
    purchase_id,
    withdrawal_id,
    transaction_type,
    amount_change,
    note,
    transaction_time
) VALUES (
    1,
    NULL,
    NULL,
    'manual_adjustment',
    25.00,
    'Manual cash adjustment test',
    CURRENT_TIMESTAMP
);

-- This should work because employee_id 4 has UPDATE_INVENTORY.
INSERT INTO stock_transfer (
    employee_id,
    transferred_at,
    note
) VALUES (
    4,
    CURRENT_TIMESTAMP,
    'Manual stock transfer test'
);

SET @new_transfer_id = LAST_INSERT_ID();

INSERT INTO stock_transfer_item (
    transfer_id,
    ingredient_id,
    quantity
) VALUES (
    @new_transfer_id,
    1,
    100.00
);
