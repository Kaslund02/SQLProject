USE coffee_machine_db;

SET @from_date = '2026-04-01 00:00:00';
SET @to_date = '2026-04-30 23:59:59';
SET @payment_type = 'cash';
SET @drink_name = NULL;

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

SET @from_date = '2026-04-01 00:00:00';
SET @to_date = '2026-04-30 23:59:59';
SET @payment_type = NULL;
SET @drink_name = 'Cappuccino';

SELECT
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
    current_cash_balance
FROM v_cash_balance;

SELECT
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
    ingredient_id,
    name,
    unit,
    quantity,
    last_updated
FROM v_remote_inventory_status
ORDER BY name;

SELECT
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
    e.employee_code,
    e.name,
    e.role,
    e.is_authorized_cash,
    e.is_authorized_inventory,
    e.is_active
FROM employee e
ORDER BY e.employee_id;
