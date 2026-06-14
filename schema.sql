-- ========================================================
-- ONLINE VISITOR MANAGEMENT SYSTEM (OVMS)
-- Exact Database Schema Replicated from pgAdmin Views
-- ========================================================

-- 1. DROP EXISTING TABLES (Ensures a clean execution slate)
DROP TABLE IF EXISTS pass_requests CASCADE;
DROP TABLE IF EXISTS officer CASCADE;

-- 2. CREATE OFFICER TABLE (As seen in image_571237.png)
CREATE TABLE officer (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    office VARCHAR(255) NOT NULL
);

-- 3. CREATE PASS REQUESTS TABLE (As seen in image_571235.png)
CREATE TABLE pass_requests (
    pass_id SERIAL PRIMARY KEY,
    visitor_name VARCHAR(255) NOT NULL,
    officer_id INT NOT NULL,
    visit_date DATE NOT NULL,
    time_from TIME WITHOUT TIME ZONE NOT NULL,
    time_to TIME WITHOUT TIME ZONE NOT NULL,
    slot_duration INT NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING',
    CONSTRAINT fk_officer FOREIGN KEY (officer_id) REFERENCES officer(id) ON DELETE CASCADE
);

-- 4. INSERT EXACT SEED DATA FOR OFFICERS (image_571237.png)
INSERT INTO officer (id, name, office) VALUES
(1, 'Mr. Sharma', 'Main Administration'),
(2, 'Ms. Das', 'HR Department'),
(3, 'Dr. Choudhury', 'IT Cell')
ON CONFLICT (id) DO NOTHING;

-- 5. INSERT EXACT SEED DATA FOR PASS REQUESTS (image_571235.png)
INSERT INTO pass_requests (pass_id, visitor_name, officer_id, visit_date, time_from, time_to, slot_duration, status) VALUES
(2, 'sub', 1, '2026-06-15', '10:00:00', '12:00:00', 30, 'CHECKED_IN'),
(1, 'sub', 1, '2026-06-15', '10:00:00', '12:00:00', 30, 'CHECKED_IN'),
(3, 'sub', 1, '2026-06-15', '10:00:00', '10:30:00', 30, 'CHECKED_IN'),
(4, 'subhas', 1, '2026-06-15', '10:00:00', '10:30:00', 30, 'CHECKED_IN'),
(6, 'subhas', 3, '2026-06-15', '10:30:00', '10:45:00', 15, 'CHECKED_IN'),
(5, 'arkadeep', 2, '2026-06-15', '10:00:00', '10:30:00', 30, 'CHECKED_IN'),
(7, 'subhas', 1, '2026-06-15', '10:30:00', '11:00:00', 30, 'CHECKED_IN')
ON CONFLICT (pass_id) DO NOTHING;

-- 6. RESET SEQUENCES (Ensures auto-generated IDs don't cause duplicate errors later)
SELECT setval(pg_get_serial_sequence('officer', 'id'), COALESCE(MAX(id), 1)) FROM officer;
SELECT setval(pg_get_serial_sequence('pass_requests', 'pass_id'), COALESCE(MAX(pass_id), 1)) FROM pass_requests;