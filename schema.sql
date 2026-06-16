
-- ========================================================
-- HRMS ONLINE VISITOR MANAGEMENT SYSTEM (OVMS)
-- Frontend & Backend Compatible Enhanced Schema
-- ========================================================

-- ========================================================
-- DROP EXISTING TABLES
-- ========================================================

DROP TABLE IF EXISTS pass_requests CASCADE;
DROP TABLE IF EXISTS officer CASCADE;

-- ========================================================
-- OFFICER TABLE
-- ========================================================

CREATE TABLE officer (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    office VARCHAR(255) NOT NULL,

    -- HRMS Features
    email VARCHAR(255),
    department VARCHAR(255),
    designation VARCHAR(255),
    phone VARCHAR(15)
);

-- ========================================================
-- PASS REQUESTS TABLE
-- ========================================================

CREATE TABLE pass_requests (

    -- Existing Backend Fields
    pass_id SERIAL PRIMARY KEY,

    visitor_name VARCHAR(255) NOT NULL,

    officer_id BIGINT NOT NULL,

    visit_date DATE NOT NULL,

    time_from TIME NOT NULL,

    time_to TIME NOT NULL,

    slot_duration INT NOT NULL,

    status VARCHAR(50) DEFAULT 'PENDING',

    -- HRMS Additional Features
    visitor_phone VARCHAR(15),

    visitor_email VARCHAR(255),

    visitor_id_proof VARCHAR(100),

    purpose TEXT,

    request_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    approved_at TIMESTAMP,

    check_in TIMESTAMP,

    check_out TIMESTAMP,

    -- Relationships
    CONSTRAINT fk_officer
        FOREIGN KEY (officer_id)
        REFERENCES officer(id)
        ON DELETE CASCADE,

    -- Ensure valid slots
    CONSTRAINT valid_time_slot
        CHECK (time_to > time_from),

    -- Valid statuses
    CONSTRAINT status_check
        CHECK (
            status IN (
                'PENDING',
                'APPROVED',
                'REJECTED',
                'CHECKED_IN',
                'CHECKED_OUT'
            )
        )
);

-- ========================================================
-- INDEXES FOR PERFORMANCE
-- ========================================================

CREATE INDEX idx_pass_requests_officer
ON pass_requests(officer_id);

CREATE INDEX idx_pass_requests_visit_date
ON pass_requests(visit_date);

CREATE INDEX idx_pass_requests_status
ON pass_requests(status);

-- ========================================================
-- OFFICER SEED DATA
-- ========================================================

INSERT INTO officer (
    id,
    name,
    office,
    email,
    department,
    designation,
    phone
)
VALUES
(
    1,
    'Mr. Sharma',
    'Main Administration',
    'sharma@hrms.com',
    'Administration',
    'Manager',
    '9876543210'
),
(
    2,
    'Ms. Das',
    'HR Department',
    'das@hrms.com',
    'Human Resources',
    'HR Executive',
    '9876543211'
),
(
    3,
    'Dr. Choudhury',
    'IT Cell',
    'choudhury@hrms.com',
    'Information Technology',
    'Technical Officer',
    '9876543212'
)
ON CONFLICT (id)
DO NOTHING;

-- ========================================================
-- PASS REQUESTS SEED DATA
-- ========================================================

INSERT INTO pass_requests (
    pass_id,
    visitor_name,
    officer_id,
    visit_date,
    time_from,
    time_to,
    slot_duration,
    status,
    visitor_phone,
    visitor_email,
    visitor_id_proof,
    purpose,
    approved_at,
    check_in,
    check_out
)
VALUES

(
    1,
    'Sub',
    1,
    '2026-06-15',
    '10:00:00',
    '10:30:00',
    30,
    'CHECKED_OUT',
    '9123456789',
    'sub@gmail.com',
    'Aadhar Card',
    'Official Meeting',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP - INTERVAL '2 hours',
    CURRENT_TIMESTAMP - INTERVAL '1 hour'
),

(
    2,
    'Subhas',
    1,
    '2026-06-15',
    '10:30:00',
    '11:00:00',
    30,
    'CHECKED_IN',
    '9234567890',
    'subhas@gmail.com',
    'PAN Card',
    'Project Discussion',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    NULL
),

(
    3,
    'Arkadeep',
    2,
    '2026-06-15',
    '11:00:00',
    '11:30:00',
    30,
    'APPROVED',
    '9345678901',
    'arkadeep@gmail.com',
    'Driving License',
    'Interview',
    CURRENT_TIMESTAMP,
    NULL,
    NULL
),

(
    4,
    'Sneha Roy',
    3,
    '2026-06-15',
    '12:00:00',
    '12:30:00',
    30,
    'PENDING',
    '9456789012',
    'sneha@gmail.com',
    'Passport',
    'Vendor Meeting',
    NULL,
    NULL,
    NULL
)
ON CONFLICT (pass_id)
DO NOTHING;

-- ========================================================
-- RESET SEQUENCES
-- ========================================================

SELECT setval(
    pg_get_serial_sequence('officer', 'id'),
    COALESCE((SELECT MAX(id) FROM officer), 1)
);

SELECT setval(
    pg_get_serial_sequence('pass_requests', 'pass_id'),
    COALESCE((SELECT MAX(pass_id) FROM pass_requests), 1)
);

-- ========================================================
-- USEFUL QUERIES
-- ========================================================

-- View all requests with officer details

SELECT
    p.pass_id,
    p.visitor_name,
    p.visitor_phone,
    p.purpose,
    p.visit_date,
    p.time_from,
    p.time_to,
    p.status,
    o.name AS officer_name,
    o.office,
    o.department
FROM pass_requests p
JOIN officer o
ON p.officer_id = o.id
ORDER BY p.visit_date, p.time_from;

-- Pending Requests

SELECT *
FROM pass_requests
WHERE status = 'PENDING';

-- Approved Requests

SELECT *
FROM pass_requests
WHERE status = 'APPROVED';

-- Check-In Visitor

UPDATE pass_requests
SET
    status = 'CHECKED_IN',
    check_in = CURRENT_TIMESTAMP
WHERE pass_id = 1;

-- Check-Out Visitor

UPDATE pass_requests
SET
    status = 'CHECKED_OUT',
    check_out = CURRENT_TIMESTAMP
WHERE pass_id = 1;




-- -- =====================================================
-- -- HRMS Visitor Management System
-- -- PostgreSQL Database Schema
-- -- =====================================================

-- -- Drop tables if they already exist
-- DROP TABLE IF EXISTS pass_requests CASCADE;
-- DROP TABLE IF EXISTS officer CASCADE;

-- -- =====================================================
-- -- Officer Table
-- -- =====================================================

-- CREATE TABLE officer (
--     officer_id SERIAL PRIMARY KEY,
--     officer_name VARCHAR(100) NOT NULL,
--     email VARCHAR(100) UNIQUE NOT NULL,
--     department VARCHAR(100) NOT NULL,
--     designation VARCHAR(100) NOT NULL,
--     phone VARCHAR(15) UNIQUE,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

-- -- =====================================================
-- -- Pass Requests Table
-- -- =====================================================

-- CREATE TABLE pass_requests (
--     request_id SERIAL PRIMARY KEY,

--     -- Visitor Details
--     visitor_name VARCHAR(100) NOT NULL,
--     visitor_phone VARCHAR(15) NOT NULL,
--     visitor_email VARCHAR(100),
--     visitor_id_proof VARCHAR(50),

--     -- Visit Information
--     purpose TEXT NOT NULL,
--     visit_date DATE NOT NULL,

--     -- Time Slot Management
--     time_from TIME NOT NULL,
--     time_to TIME NOT NULL,
--     slot_duration INT NOT NULL CHECK (slot_duration > 0),

--     -- Officer Reference
--     officer_id INT NOT NULL,

--     -- Approval and Status Tracking
--     status VARCHAR(20)
--     CHECK (
--         status IN (
--             'PENDING',
--             'APPROVED',
--             'REJECTED',
--             'CHECKED_IN',
--             'CHECKED_OUT'
--         )
--     ) DEFAULT 'PENDING',

--     request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     approved_at TIMESTAMP,

--     -- Check-In / Check-Out
--     check_in TIMESTAMP,
--     check_out TIMESTAMP,

--     -- Foreign Key Constraint
--     CONSTRAINT fk_officer
--     FOREIGN KEY (officer_id)
--     REFERENCES officer(officer_id)
--     ON DELETE RESTRICT,

--     -- Ensure end time is after start time
--     CONSTRAINT valid_time_slot
--     CHECK (time_to > time_from)
-- );

-- -- =====================================================
-- -- Insert Sample Officers
-- -- =====================================================

-- INSERT INTO officer (
--     officer_name,
--     email,
--     department,
--     designation,
--     phone
-- )
-- VALUES
-- (
--     'Rahul Sharma',
--     'rahul@company.com',
--     'HR',
--     'Manager',
--     '9876543210'
-- ),
-- (
--     'Priya Das',
--     'priya@company.com',
--     'IT',
--     'Team Lead',
--     '9876543211'
-- ),
-- (
--     'Subhas Choudhury',
--     'subhas@company.com',
--     'Administration',
--     'Officer',
--     '9876543212'
-- );

-- -- =====================================================
-- -- Insert Sample Pass Requests
-- -- =====================================================

-- INSERT INTO pass_requests (
--     visitor_name,
--     visitor_phone,
--     visitor_email,
--     visitor_id_proof,
--     purpose,
--     visit_date,
--     time_from,
--     time_to,
--     slot_duration,
--     officer_id
-- )
-- VALUES
-- (
--     'Amit Kumar',
--     '9123456789',
--     'amit@gmail.com',
--     'Aadhar',
--     'Interview',
--     CURRENT_DATE,
--     '10:00:00',
--     '10:30:00',
--     30,
--     1
-- ),
-- (
--     'Sneha Roy',
--     '9234567890',
--     'sneha@gmail.com',
--     'PAN',
--     'Project Discussion',
--     CURRENT_DATE,
--     '11:00:00',
--     '11:30:00',
--     30,
--     2
-- ),
-- (
--     'Arkadeep Das',
--     '9345678901',
--     'arkadeep@gmail.com',
--     'Driving License',
--     'Official Meeting',
--     CURRENT_DATE,
--     '12:00:00',
--     '12:30:00',
--     30,
--     3
-- );

-- -- =====================================================
-- -- Useful Queries
-- -- =====================================================

-- -- View all officers
-- SELECT * FROM officer;

-- -- View all pass requests
-- SELECT * FROM pass_requests;

-- -- View pending requests
-- SELECT *
-- FROM pass_requests
-- WHERE status = 'PENDING';

-- -- Approve a request
-- UPDATE pass_requests
-- SET status = 'APPROVED',
--     approved_at = CURRENT_TIMESTAMP
-- WHERE request_id = 1;

-- -- Check In Visitor
-- UPDATE pass_requests
-- SET status = 'CHECKED_IN',
--     check_in = CURRENT_TIMESTAMP
-- WHERE request_id = 1;

-- -- Check Out Visitor
-- UPDATE pass_requests
-- SET status = 'CHECKED_OUT',
--     check_out = CURRENT_TIMESTAMP
-- WHERE request_id = 1;

-- -- Join Query
-- SELECT
--     p.request_id,
--     p.visitor_name,
--     p.purpose,
--     p.visit_date,
--     p.time_from,
--     p.time_to,
--     p.status,
--     o.officer_name,
--     o.department,
--     o.designation
-- FROM pass_requests p
-- JOIN officer o
-- ON p.officer_id = o.officer_id;