
-- V4: SpendWise database security
-- Use separate roles for the application and audit reviewers.
-- These are NOLOGIN roles; login accounts can be added later.

CREATE ROLE spendwise_app NOLOGIN;
CREATE ROLE spendwise_audit_reader NOLOGIN;

-- Prevent ordinary roles from creating objects in the public schema.
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

GRANT USAGE ON SCHEMA public
TO spendwise_app, spendwise_audit_reader;

-- Remove default public access to existing tables and sequences.
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;

-- Application access to user accounts.
-- password_hash can be written for registration/password changes,
-- but is deliberately excluded from SELECT permissions.
GRANT SELECT (user_id, full_name, email, created_at)
ON users TO spendwise_app;

GRANT INSERT (full_name, email, password_hash)
ON users TO spendwise_app;

GRANT UPDATE (full_name, email, password_hash)
ON users TO spendwise_app;

-- Application access to financial records.
GRANT SELECT, INSERT, UPDATE, DELETE
ON budgets, categories, expenses,
   savings_goals, savings_contributions
TO spendwise_app;

-- Permit the application to use identity sequences where needed.
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public
TO spendwise_app;

-- Audit reviewers can inspect logs but cannot change or delete them.
GRANT SELECT ON audit_logs TO spendwise_audit_reader;

-- Permit audit reviewers to identify users without reading password hashes.
GRANT SELECT (user_id, full_name, email, created_at)
ON users TO spendwise_audit_reader;

-- Audit triggers must be able to insert logs even when the application
-- role has no direct permission to modify audit_logs.
-- The function is owned by the migration owner (normally postgres).
ALTER FUNCTION public.log_spendwise_change()
    SECURITY DEFINER;

-- Use a fixed search path for this privileged function.
ALTER FUNCTION public.log_spendwise_change()
    SET search_path = pg_catalog, public;

-- Application users must not call the privileged function directly.
REVOKE ALL ON FUNCTION public.log_spendwise_change() FROM PUBLIC;
