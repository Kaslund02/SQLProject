USE coffee_machine_db;

-- Assignment query 1:
-- Read purchases/transactions in a chosen time range.
-- Optional filters:
--   @payment_type = 'cash', 'card' or NULL for both
--   @drink_name = a drink name or NULL for all drinks

-- 1A: All transactions in a time range, both cash and card, all drinks.
SET @from_date = '2026-04-01 00:00:00';
SET @to_date = '2026-04-30 23:59:59';
SET @payment_type = NULL;
SET @drink_name = NULL;

SELECT
    'All transactions in selected time range' AS result_type,
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

-- 1B: Transactions in a time range filtered by type: cash.
SET @from_date = '2026-04-01 00:00:00';
SET @to_date = '2026-04-30 23:59:59';
SET @payment_type = 'cash';
SET @drink_name = NULL;

SELECT
    'Only cash transactions' AS result_type,
    p.purchase_id,
    p.purchased_at,
    d.name AS drink_name,
    p.payment_type,
    p.amount_paid
FROM purchase p
JOIN drink d
    ON d.drink_id = p.drink_id
WHERE p.purchased_at BETWEEN @from_date AND @to_date
  AND (@payment_type IS NULL OR p.payment_type = CONVERT(@payment_type USING utf8mb4) COLLATE utf8mb4_unicode_ci)
  AND (@drink_name IS NULL OR d.name = CONVERT(@drink_name USING utf8mb4) COLLATE utf8mb4_unicode_ci)
ORDER BY p.purchased_at;

-- 1C: Transactions in a time range filtered by type: card.
SET @from_date = '2026-04-01 00:00:00';
SET @to_date = '2026-04-30 23:59:59';
SET @payment_type = 'card';
SET @drink_name = NULL;

SELECT
    'Only card transactions' AS result_type,
    p.purchase_id,
    p.purchased_at,
    d.name AS drink_name,
    p.payment_type,
    p.amount_paid
FROM purchase p
JOIN drink d
    ON d.drink_id = p.drink_id
WHERE p.purchased_at BETWEEN @from_date AND @to_date
  AND (@payment_type IS NULL OR p.payment_type = CONVERT(@payment_type USING utf8mb4) COLLATE utf8mb4_unicode_ci)
  AND (@drink_name IS NULL OR d.name = CONVERT(@drink_name USING utf8mb4) COLLATE utf8mb4_unicode_ci)
ORDER BY p.purchased_at;

-- 1D: Transactions in a time range filtered by a specific drink.
SET @from_date = '2026-04-01 00:00:00';
SET @to_date = '2026-04-30 23:59:59';
SET @payment_type = NULL;
SET @drink_name = 'Cappuccino';

SELECT
    'Only selected drink' AS result_type,
    p.purchase_id,
    p.purchased_at,
    d.name AS drink_name,
    p.payment_type,
    p.amount_paid
FROM purchase p
JOIN drink d
    ON d.drink_id = p.drink_id
WHERE p.purchased_at BETWEEN @from_date AND @to_date
  AND (@payment_type IS NULL OR p.payment_type = CONVERT(@payment_type USING utf8mb4) COLLATE utf8mb4_unicode_ci)
  AND (@drink_name IS NULL OR d.name = CONVERT(@drink_name USING utf8mb4) COLLATE utf8mb4_unicode_ci)
ORDER BY p.purchased_at;

-- 1E: Arbitrary combination: date range + payment type + drink.
SET @from_date = '2026-04-04 00:00:00';
SET @to_date = '2026-04-04 23:59:59';
SET @payment_type = 'cash';
SET @drink_name = 'Mocha';

SELECT
    'Combination: date, payment type and drink' AS result_type,
    p.purchase_id,
    p.purchased_at,
    d.name AS drink_name,
    p.payment_type,
    p.amount_paid
FROM purchase p
JOIN drink d
    ON d.drink_id = p.drink_id
WHERE p.purchased_at BETWEEN @from_date AND @to_date
  AND (@payment_type IS NULL OR p.payment_type = CONVERT(@payment_type USING utf8mb4) COLLATE utf8mb4_unicode_ci)
  AND (@drink_name IS NULL OR d.name = CONVERT(@drink_name USING utf8mb4) COLLATE utf8mb4_unicode_ci)
ORDER BY p.purchased_at;

SELECT
    'Drink recipes' AS result_type,
    d.name AS drink_name,
    i.name AS ingredient_name,
    di.amount_required,
    i.unit
FROM drink_ingredient di
JOIN drink d
    ON d.drink_id = di.drink_id
JOIN ingredient i
    ON i.ingredient_id = di.ingredient_id
ORDER BY d.name, i.name;

SELECT
    'Cash balance' AS result_type,
    current_cash_balance
FROM v_cash_balance;

SELECT
    'Machine inventory' AS result_type,
    ingredient_id,
    name,
    unit,
    quantity,
    minimum_threshold,
    status,
    last_updated
FROM v_machine_inventory_status
ORDER BY name;

SELECT
    'Remote inventory' AS result_type,
    ingredient_id,
    name,
    unit,
    quantity,
    last_updated
FROM v_remote_inventory_status
ORDER BY name;

SELECT
    'Cleaning history' AS result_type,
    cl.cleaning_id,
    cl.cleaned_at,
    e.employee_code,
    e.name AS employee_name,
    cl.notes
FROM cleaning_log cl
JOIN employee e
    ON e.employee_id = cl.employee_id
ORDER BY cl.cleaned_at DESC;

SELECT
    'Inventory history' AS result_type,
    source,
    event_timestamp,
    ingredient_name,
    employee_name,
    event_type,
    change_amount,
    reason
FROM (
    SELECT
        'machine' AS source,
        mih.event_timestamp,
        i.name AS ingredient_name,
        e.name AS employee_name,
        mih.event_type,
        mih.change_amount,
        mih.reason
    FROM machine_inventory_history mih
    JOIN ingredient i
        ON i.ingredient_id = mih.ingredient_id
    LEFT JOIN employee e
        ON e.employee_id = mih.employee_id
    UNION ALL
    SELECT
        'remote' AS source,
        rih.event_timestamp,
        i.name AS ingredient_name,
        e.name AS employee_name,
        rih.event_type,
        rih.change_amount,
        rih.reason
    FROM remote_inventory_history rih
    JOIN ingredient i
        ON i.ingredient_id = rih.ingredient_id
    LEFT JOIN employee e
        ON e.employee_id = rih.employee_id
) inventory_events
ORDER BY event_timestamp;

SELECT
    'Employees and permissions' AS result_type,
    e.employee_code,
    e.name,
    r.role_name,
    COALESCE(GROUP_CONCAT(p.permission_name ORDER BY p.permission_name SEPARATOR ', '), 'No permissions') AS permissions,
    e.is_active
FROM employee e
JOIN `role` r
    ON r.role_id = e.role_id
LEFT JOIN `role_permission` rp
    ON rp.role_id = r.role_id
LEFT JOIN `permission` p
    ON p.permission_id = rp.permission_id
GROUP BY
    e.employee_id,
    e.employee_code,
    e.name,
    r.role_name,
    e.is_active
ORDER BY e.employee_id;
