
-- V1: Core SpendWise tables
-- Creates the initial relational schema.

CREATE TABLE users (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE budgets (
    budget_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    budget_name VARCHAR(100) NOT NULL,
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT budgets_valid_dates CHECK (end_date >= start_date),
    CONSTRAINT budgets_id_user_unique UNIQUE (budget_id, user_id)
);

CREATE TABLE categories (
    category_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    category_name VARCHAR(100) NOT NULL,
    CONSTRAINT categories_name_per_user UNIQUE (user_id, category_name),
    CONSTRAINT categories_id_user_unique UNIQUE (category_id, user_id)
);

CREATE TABLE expenses (
    expense_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    budget_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    description TEXT,
    expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT expenses_budget_owner_fk
        FOREIGN KEY (budget_id, user_id)
        REFERENCES budgets(budget_id, user_id) ON DELETE CASCADE,

    CONSTRAINT expenses_category_owner_fk
        FOREIGN KEY (category_id, user_id)
        REFERENCES categories(category_id, user_id) ON DELETE RESTRICT
);

CREATE TABLE savings_goals (
    goal_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    goal_name VARCHAR(100) NOT NULL,
    target_amount NUMERIC(12,2) NOT NULL CHECK (target_amount > 0),
    target_date DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT savings_goals_id_user_unique UNIQUE (goal_id, user_id)
);

CREATE TABLE savings_contributions (
    contribution_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    goal_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    contribution_date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT contributions_goal_owner_fk
        FOREIGN KEY (goal_id, user_id)
        REFERENCES savings_goals(goal_id, user_id) ON DELETE CASCADE
);

CREATE TABLE audit_logs (
    audit_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT REFERENCES users(user_id) ON DELETE SET NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT,
    action VARCHAR(20) NOT NULL
        CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    old_data JSONB,
    new_data JSONB
);
