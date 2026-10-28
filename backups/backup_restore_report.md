\# SpendWise Backup and Restore Verification Report



\## 1. Objective



Verify that the SpendWise PostgreSQL database can be backed up and restored into a separate test database without changing the original database.



\## 2. Environment



\- Database system: PostgreSQL 16.15

\- Source database: `capstone`

\- Backup file: `backups/capstone\_backup.dump`

\- Backup format: PostgreSQL custom archive

\- Restore target: `capstone\_restore\_test`



\## 3. Backup Evidence



The backup was created successfully using `pg\_dump`.



\- Backup file size: 31,625 bytes

\- Archive inspection: Successful using `pg\_restore --list`

\- Archive contents included tables, table data, indexes, constraints, sequences, audit triggers, and Flyway migration history.



\## 4. Restore Evidence



The backup was restored into the separate `capstone\_restore\_test` database using `pg\_restore`.



The restored database contains eight tables:



1\. `users`

2\. `budgets`

3\. `categories`

4\. `expenses`

5\. `savings\_goals`

6\. `savings\_contributions`

7\. `audit\_logs`

8\. `flyway\_schema\_history`



\## 5. Migration Verification



Four Flyway migrations were found in the restored database, all marked successful:



| Version | Description | Success |

|---|---|---|

| 1 | Core tables | Yes |

| 2 | Indexes | Yes |

| 3 | Audit triggers | Yes |

| 4 | Database security | Yes |



\## 6. Data Verification



The following business tables were checked:



\- `users`

\- `budgets`

\- `categories`

\- `expenses`

\- `savings\_goals`

\- `savings\_contributions`

\- `audit\_logs`



All seven tables contained zero rows in the restored database, matching the current source database state. The earlier performance benchmark used temporary data inside a transaction that was rolled back.



\## 7. Conclusion



The custom-format PostgreSQL backup was readable and successfully restored into a separate test database. The restored database contained all eight expected tables and all four successful Flyway migrations.



This test verifies structural recovery and the current empty-data state. A future test using representative persistent sample records would provide additional evidence of business-data recovery.



\## 8. Safety Note



The restore target was `capstone\_restore\_test`. The original `capstone` database was not used as the restore target.

