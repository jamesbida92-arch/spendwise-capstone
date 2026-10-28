# Capstone Project Requirements

## Project Title
SpendWise — Personal Financial Management Database

## 1. Project Overview
SpendWise is a database-driven financial management system that helps users manage budgets, record expenses, monitor savings, and analyze their spending habits.

The system uses PostgreSQL as its primary relational database and Redis as a caching layer for frequently requested financial summaries.

## 2. Project Objectives
- Design a reliable relational database.
- Track users, budgets, expense categories, expenses, and savings.
- Protect financial information using database security controls.
- Implement version-controlled database migrations.
- Improve query performance through indexing and optimization.
- Maintain audit logs for critical database changes.
- Implement automated backups and test database restoration.

## 3. Functional Requirements
1. Users can register and manage their accounts.
2. Users can create multiple budgets.
3. Users can categorize expenses.
4. Users can record and view expenses.
5. Users can create savings goals.
6. Users can record savings contributions.
7. Users can generate financial summaries.
8. Administrators can review audit records without accessing user passwords.

## 4. Non-Functional Requirements
- Security: Passwords must be securely hashed.
- Performance: Frequently executed queries must be optimized and measured.
- Reliability: Database backups must be created and tested.
- Scalability: The database must support multiple users.
- Maintainability: Database changes must use versioned migrations.
- Integrity: Foreign keys and constraints must protect data consistency.

## 5. Technologies
- PostgreSQL 16 — relational database
- Redis — financial summary caching
- Flyway — database migrations
- VS Code — development environment
- PowerShell — command-line operations
- Git and GitHub — version control
- dbdiagram.io — entity relationship diagram

## 6. Main Database Entities
- Users
- Budgets
- Categories
- Expenses
- Savings Goals
- Savings Contributions
- Audit Logs

## 7. Expected Outcome
A complete, secure, optimized, and documented financial management database with migrations, NoSQL integration, performance evidence, backup and restore verification, and a final presentation.