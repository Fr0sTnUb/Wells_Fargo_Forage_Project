-- ============================================================
-- Wells Fargo Investment Management System
-- Entity Relationship Diagram — SQL Implementation (PostgreSQL)
-- Task 1: Data Model
-- ============================================================

-- Drop tables in reverse dependency order (for clean re-runs)
DROP TABLE IF EXISTS security CASCADE;
DROP TABLE IF EXISTS portfolio CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TABLE IF EXISTS advisor CASCADE;

-- ============================================================
-- TABLE: advisor
-- One advisor can manage many clients
-- ============================================================
CREATE TABLE advisor (
    advisor_id      SERIAL PRIMARY KEY,
    first_name      VARCHAR(100)        NOT NULL,
    last_name       VARCHAR(100)        NOT NULL,
    email           VARCHAR(255)        NOT NULL UNIQUE,
    phone           VARCHAR(20),
    address         VARCHAR(255),
    created_at      TIMESTAMP           DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: client
-- Many clients belong to one advisor
-- Each client has exactly one portfolio
-- ============================================================
CREATE TABLE client (
    client_id       SERIAL PRIMARY KEY,
    advisor_id      INT                 NOT NULL,
    first_name      VARCHAR(100)        NOT NULL,
    last_name       VARCHAR(100)        NOT NULL,
    email           VARCHAR(255)        NOT NULL UNIQUE,
    phone           VARCHAR(20),
    address         VARCHAR(255),
    created_at      TIMESTAMP           DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP           DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_client_advisor
        FOREIGN KEY (advisor_id)
        REFERENCES advisor(advisor_id)
        ON DELETE CASCADE
);

-- ============================================================
-- TABLE: portfolio
-- One portfolio per client (1:1)
-- A portfolio can contain zero or more securities
-- ============================================================
CREATE TABLE portfolio (
    portfolio_id    SERIAL PRIMARY KEY,
    client_id       INT                 NOT NULL UNIQUE,  -- UNIQUE enforces 1:1 with client
    creation_date   TIMESTAMP           DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP           DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_portfolio_client
        FOREIGN KEY (client_id)
        REFERENCES client(client_id)
        ON DELETE CASCADE
);

-- ============================================================
-- TABLE: security
-- Many securities belong to one portfolio
-- ============================================================
CREATE TABLE security (
    security_id     SERIAL PRIMARY KEY,
    portfolio_id    INT                 NOT NULL,
    name            VARCHAR(255)        NOT NULL,
    category        VARCHAR(100)        NOT NULL,
    purchase_date   DATE                NOT NULL,
    purchase_price  DECIMAL(15, 2)      NOT NULL,
    quantity        INT                 NOT NULL CHECK (quantity >= 0),
    created_at      TIMESTAMP           DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP           DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_security_portfolio
        FOREIGN KEY (portfolio_id)
        REFERENCES portfolio(portfolio_id)
        ON DELETE CASCADE
);

-- ============================================================
-- INDEXES (for query performance on foreign keys)
-- ============================================================
CREATE INDEX idx_client_advisor_id     ON client(advisor_id);
CREATE INDEX idx_portfolio_client_id   ON portfolio(client_id);
CREATE INDEX idx_security_portfolio_id ON security(portfolio_id);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Advisors
INSERT INTO advisor (first_name, last_name, email, phone, address) VALUES
    ('Sarah',   'Johnson',  'sarah.johnson@wellsfargo.com',  '415-555-0101', '420 Montgomery St, San Francisco, CA'),
    ('Michael', 'Chen',     'michael.chen@wellsfargo.com',   '415-555-0102', '420 Montgomery St, San Francisco, CA');

-- Clients
INSERT INTO client (advisor_id, first_name, last_name, email, phone, address) VALUES
    (1, 'James',   'Williams', 'james.williams@email.com',  '415-555-1001', '100 Main St, San Francisco, CA'),
    (1, 'Emily',   'Davis',    'emily.davis@email.com',     '415-555-1002', '200 Oak Ave, San Francisco, CA'),
    (2, 'Robert',  'Martinez', 'robert.martinez@email.com', '415-555-1003', '300 Pine Rd, San Francisco, CA');

-- Portfolios (one per client)
INSERT INTO portfolio (client_id, creation_date) VALUES
    (1, CURRENT_TIMESTAMP),
    (2, CURRENT_TIMESTAMP),
    (3, CURRENT_TIMESTAMP);

-- Securities
INSERT INTO security (portfolio_id, name, category, purchase_date, purchase_price, quantity) VALUES
    (1, 'Apple Inc.',            'Equity',       '2023-01-15', 142.53,  10),
    (1, 'US Treasury Bond 2030', 'Fixed Income', '2023-03-10', 980.00,   5),
    (2, 'Vanguard S&P 500 ETF',  'ETF',          '2023-02-20', 374.25,  20),
    (2, 'Microsoft Corp.',       'Equity',       '2023-04-05', 285.10,   8),
    (3, 'Amazon.com Inc.',       'Equity',       '2023-05-12', 115.76,  15),
    (3, 'Gold Futures ETF',      'Commodity',    '2023-06-01',  18.40, 100);

-- ============================================================
-- VERIFICATION QUERIES
-- ============================================================

-- View all advisors and their client count
SELECT
    a.advisor_id,
    a.first_name || ' ' || a.last_name  AS advisor_name,
    COUNT(c.client_id)                  AS total_clients
FROM advisor a
LEFT JOIN client c ON a.advisor_id = c.advisor_id
GROUP BY a.advisor_id, advisor_name
ORDER BY a.advisor_id;

-- View full hierarchy: advisor → client → portfolio → securities
SELECT
    a.first_name || ' ' || a.last_name  AS advisor,
    c.first_name || ' ' || c.last_name  AS client,
    p.portfolio_id,
    s.name                              AS security_name,
    s.category,
    s.purchase_date,
    s.purchase_price,
    s.quantity,
    (s.purchase_price * s.quantity)     AS total_value
FROM advisor a
JOIN client    c ON a.advisor_id   = c.advisor_id
JOIN portfolio p ON c.client_id    = p.client_id
JOIN security  s ON p.portfolio_id = s.portfolio_id
ORDER BY advisor, client, s.name;
