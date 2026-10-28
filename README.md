\# SpendWise — Personal Financial Management Database



\## 1. Project Overview



SpendWise is a personal financial management database designed to organize budgets, expense records, savings goals, savings contributions, and audit history.



The project demonstrates relational database design, database migrations, indexing, audit logging, database permissions, Redis-compatible caching, and backup and restore verification.



\## 2. Technology Stack



\- \*\*PostgreSQL 16.15:\*\* Relational database.

\- \*\*Flyway:\*\* Version-controlled database migrations.

\- \*\*Memurai:\*\* Windows-compatible Redis implementation for cache testing.

\- \*\*PowerShell:\*\* Windows command-line administration and testing.

\- \*\*DBML:\*\* Entity-relationship diagram definition.



\## 3. Database Structure



The database includes the following tables:



1\. `users` — user identity and password hash storage.

2\. `budgets` — user budgets and budget periods.

3\. `categories` — expense categories.

4\. `expenses` — expense transactions.

5\. `savings\_goals` — savings targets.

6\. `savings\_contributions` — contributions toward savings goals.

7\. `audit\_logs` — records of changes to selected financial tables.

8\. `flyway\_schema\_history` — Flyway migration tracking.



See `er\_diagram.dbml` for the database diagram definition.



\## 4. Database Migrations



The `migrations/` directory contains four migrations:



| Migration | Purpose |

|---|---|

| V1 | Create core database tables |

| V2 | Add performance indexes |

| V3 | Add audit logging triggers |

| V4 | Configure database roles and permissions |



The migrations were applied successfully, and the restored database also contains all four successful migration records.



\## 5. Performance Optimization



The performance report is located at `optimization/performance\_report.md`.



In the recorded test, the indexed query execution time decreased from 1.012 ms to 0.311 ms, an observed reduction of approximately 69.3%.



The test used synthetic data inside a transaction that was rolled back. Results may vary with different datasets and environments.



\## 6. NoSQL Cache Test



The cache test report is located at `nosql/redis\_cache\_test.md`.



Memurai was used to test Redis-compatible storage and retrieval of a sample financial summary, including an expiration time.



This demonstrates a cache proof of concept. Full application-level cache integration and invalidation are not yet implemented.



\## 7. Backup and Restore



The PostgreSQL custom-format backup is stored at `backups/capstone\_backup.dump`.



The backup was inspected and restored into the separate `capstone\_restore\_test` database. The restored database contains all eight expected tables and four successful Flyway migrations.



See `backups/backup\_restore\_report.md` for verification details.



The restored business tables were empty, matching the source database at the time of backup. Testing with representative persistent sample records would provide additional data-recovery evidence.



\## 8. Security Considerations



\- Passwords must be hashed by the application before they are stored.

\- Database roles limit access to selected tables and columns.

\- Audit triggers record selected database changes without including `password\_hash` in the old and new row data.

\- The current project demonstrates database-level permissions, not a complete production authentication system.

\- Per-user row isolation and application-level authorization still require implementation and testing.



\## 9. Project Structure



```text

capstone-build-sprint/

├── README.md

├── requirements.md

├── er\_diagram.dbml

├── flyway.toml

├── migrations/

│   ├── V1\_\_core\_tables.sql

│   ├── V2\_\_indexes.sql

│   ├── V3\_\_audit\_triggers.sql

│   └── V4\_\_database\_security.sql

├── nosql/

│   └── redis\_cache\_test.md

├── optimization/

│   └── performance\_report.md

└── backups/

&#x20;   ├── capstone\_backup.dump

&#x20;   └── backup\_restore\_report.md

```



\## 10. Current Status and Future Improvements



Completed:

\- Core relational schema and migrations.

\- Index creation and a documented performance comparison.

\- Database audit triggers and permission roles.

\- Redis-compatible cache proof of concept.

\- PostgreSQL backup and separate-database restore verification.



Future improvements:

\- Add representative sample data and automated tests.

\- Implement application authentication and per-user authorization.

\- Integrate cache reads, writes, expiration, and invalidation into the application.

\- Automate backup verification and recovery testing.

\- Add a final presentation with screenshots and command outputs.



\## 11. Conclusion



SpendWise demonstrates a structured approach to building and maintaining a personal financial management database. The project includes versioned schema changes, performance testing, auditing, access-control configuration, cache testing, and backup and restore verification.



