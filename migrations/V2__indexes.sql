
-- V2: Indexes for common SpendWise queries

-- Find budgets belonging to a user.
CREATE INDEX idx_budgets_user
    ON budgets(user_id);

-- Find categories belonging to a user.
CREATE INDEX idx_categories_user
    ON categories(user_id);

-- Filter expenses by user and date.
CREATE INDEX idx_expenses_user_date
    ON expenses(user_id, expense_date DESC);

-- Find expenses associated with a budget.
CREATE INDEX idx_expenses_budget
    ON expenses(budget_id);

-- Find expenses by category.
CREATE INDEX idx_expenses_category
    ON expenses(category_id);

-- Find savings goals belonging to a user.
CREATE INDEX idx_savings_goals_user
    ON savings_goals(user_id);

-- Retrieve contributions for a savings goal.
CREATE INDEX idx_contributions_goal_date
    ON savings_contributions(goal_id, contribution_date DESC);

-- Find audit records by table and time.
CREATE INDEX idx_audit_table_changed
    ON audit_logs(table_name, changed_at DESC);
