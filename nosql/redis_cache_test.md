\# SpendWise NoSQL Cache Integration Test



\## Objective

Test a Redis-compatible cache using Memurai on Windows.



\## Cache Key

`spendwise:summary:test-user`



\## Sample Cached Data

```json

{

&#x20; "budget": 50000,

&#x20; "expenses": 30000,

&#x20; "remaining": 20000

}

```



\## Test Results



| Operation | Result | Meaning |

|---|---|---|

| PING | PONG | Cache service responded |

| SET | OK | Summary stored |

| GET | Successful | Cached summary retrieved |

| EXPIRE 300 | 1 | Expiration configured |

| TTL | 283 seconds observed | Key had a limited lifetime |

| PowerShell JSON validation | PASSED | Returned data parsed successfully |



\## Design Notes

Memurai provides a Redis-compatible cache for this Windows development environment. In production, financial summaries should be calculated from PostgreSQL, cached for a limited period, and refreshed when relevant financial records change.



\## Limitations

This test verifies connectivity, storage, retrieval, JSON parsing, and expiry. It does not yet implement application-level cache invalidation, authentication, or full application integration.

