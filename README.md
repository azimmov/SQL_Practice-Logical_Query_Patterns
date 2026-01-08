# SQL_Practice-Logical_Query_Patterns

This repository contains a collection of SQL practice tasks completed as part of my ongoing learning in relational databases and analytical SQL.

The goal of this work is not to present a production project, but to demonstrate consistent hands-on practice, logical problem solving, and understanding of core SQL patterns beyond basic CRUD queries.

All exercises are based on a single denormalized dataset and are written using Microsoft SQL Server–style syntax.

## What This Repository Shows

This repository demonstrates practical experience with:

- Aggregation and filtering using GROUP BY and HAVING
- Join logic, including self-joins and anti-joins
- Set-based reasoning using UNION, EXCEPT, and INTERSECT
- Relational division patterns
- Top-N per group logic without window functions
- Time-based analysis using table-derived dates
- Gap detection and consecutive-row logic without analytic functions
- Decomposing complex problems into smaller, testable queries
- Several tasks intentionally include intermediate attempts and refinements to show the learning and reasoning process, not just final answers

## Files

- `WorkingFile.csv` – Practice dataset
- `data_dictionary.xlsx` – Column definitions
- `Tasks.sql` – SQL problems without solutions
- `Queries.sql` – Solutions with comments and explanations
- `README.md` – Project overview

## Notes

- Window functions and CTEs are intentionally avoided in most tasks
- Queries were tested using Microsoft SQL Server syntax
- Date logic relies on values in the dataset rather than current-date functions

## Purpose

This repository exists to provide concrete evidence of SQL practice and learning for resume and interview discussions.

It reflects time spent solving non-trivial SQL problems and developing a deeper understanding of relational query logic.
