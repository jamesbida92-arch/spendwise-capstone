
-- V3: Audit logging triggers for SpendWise
-- Password hashes must never be copied into audit logs.

CREATE OR REPLACE FUNCTION log_spendwise_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    old_record JSONB;
    new_record JSONB;
    affected_user_id BIGINT;
    affected_record_id BIGINT;
BEGIN
    IF TG_OP = 'INSERT' THEN
        new_record := to_jsonb(NEW);
        affected_user_id := NEW.user_id;
        affected_record_id := NULL;

    ELSIF TG_OP = 'UPDATE' THEN
        old_record := to_jsonb(OLD);
        new_record := to_jsonb(NEW);
        affected_user_id := NEW.user_id;
        affected_record_id := NULL;

    ELSE
        old_record := to_jsonb(OLD);
        affected_user_id := OLD.user_id;
        affected_record_id := NULL;
    END IF;

    -- Never retain password hashes in audit JSON.
    IF old_record IS NOT NULL THEN
        old_record := old_record - 'password_hash';
    END IF;

    IF new_record IS NOT NULL THEN
        new_record := new_record - 'password_hash';
    END IF;

    -- Identify the affected record using its table's primary key.
    IF TG_OP = 'DELETE' THEN
        affected_record_id :=
            (old_record ->> TG_ARGV[0])::BIGINT;
    ELSE
        affected_record_id :=
            (new_record ->> TG_ARGV[0])::BIGINT;
    END IF;

    INSERT INTO audit_logs (
        user_id,
        table_name,
        record_id,
        action,
        old_data,
        new_data
    )
    VALUES (
        affected_user_id,
        TG_TABLE_NAME,
        affected_record_id,
        TG_OP,
        old_record,
        new_record
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;

    RETURN NEW;
END;
$$;

-- Track changes to budgets.
CREATE TRIGGER audit_budgets
AFTER INSERT OR UPDATE OR DELETE ON budgets
FOR EACH ROW
EXECUTE FUNCTION log_spendwise_change('budget_id');

-- Track changes to categories.
CREATE TRIGGER audit_categories
AFTER INSERT OR UPDATE OR DELETE ON categories
FOR EACH ROW
EXECUTE FUNCTION log_spendwise_change('category_id');

-- Track changes to expenses.
CREATE TRIGGER audit_expenses
AFTER INSERT OR UPDATE OR DELETE ON expenses
FOR EACH ROW
EXECUTE FUNCTION log_spendwise_change('expense_id');

-- Track changes to savings goals.
CREATE TRIGGER audit_savings_goals
AFTER INSERT OR UPDATE OR DELETE ON savings_goals
FOR EACH ROW
EXECUTE FUNCTION log_spendwise_change('goal_id');

-- Track changes to savings contributions.
CREATE TRIGGER audit_savings_contributions
AFTER INSERT OR UPDATE OR DELETE ON savings_contributions
FOR EACH ROW
EXECUTE FUNCTION log_spendwise_change('contribution_id');
