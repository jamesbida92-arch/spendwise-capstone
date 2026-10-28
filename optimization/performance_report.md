\# SpendWise Query Performance Report



\## Objective



Measure the effect of the composite index `idx\_expenses\_user\_date` on a query that retrieves a user's recent expenses, ordered by expense date.



\## Test Setup



\- Database: PostgreSQL 16.15

\- Benchmark dataset: 5,000 generated expenses

\- Query filter: One user and expenses from the last 7 days

\- Rows returned: 111

\- Measurement tool: `EXPLAIN (ANALYZE, BUFFERS)`



\## Results



| Metric | Before index | After index |

|---|---:|---:|

| Execution time | 1.012 ms | 0.311 ms |

| Planning time | 4.423 ms | 0.406 ms |

| Expense access method | Sequential scan | Bitmap index scan |

| Rows returned | 111 | 111 |



\## Analysis



Before the index was used, PostgreSQL scanned the expense table and removed 4,889 rows that did not match the filter. After creating `idx\_expenses\_user\_date` on `(user\_id, expense\_date DESC)`, PostgreSQL used a bitmap index scan to locate matching expenses.



The observed execution time decreased by approximately 69.3%, from 1.012 ms to 0.311 ms. The query still required a sort operation.



\## Conclusion



The composite index improved execution time for this test workload by narrowing the expense rows PostgreSQL needed to access. Results are specific to this dataset and run; repeated measurements on representative production-sized data would provide stronger evidence.



\## Reproducibility Note



The benchmark ran in a transaction that was rolled back, so its generated records and temporary index changes were not retained. The permanent `idx\_expenses\_user\_date` index from migration V2 remains in the database.



