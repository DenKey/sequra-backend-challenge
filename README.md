# TABLE

| Year | Number of Disbursement | Amount disbursed to merchants | Amount of order fees | Number of monthly fees charged (From minimum monthly fee) | Amount of monthly fee charged (From minimum monthly fee) |
| :---: | ---: | ---: | ---: | ---: | ---: |
| 2022 | 1464 | 16346354.24 | 152047.65 | 44 | 690 | 
| 2023 | 1024 | 17668506.43 | 162463.52 | 13 | 225 | 


# MONEY CHECKS
34329371.84 (total migrated orders sum)

34329371.84 = 16346354.24 + 17668506.43 + 152047.65 + 162463.52 (total disbursted)

0 (diff)

# TABLE QUERIES

```
// Disbursement count
Select count(*) from disbursements where fee_type = 0 AND EXTRACT(YEAR FROM operated_at) = 2022;
Select count(*) from disbursements where fee_type = 0 AND EXTRACT(YEAR FROM operated_at) = 2023;

// Merchant fee sum
Select sum(amount) from disbursements where fee_type = 0 AND EXTRACT(YEAR FROM operated_at) = 2022;
Select sum(amount) from disbursements where fee_type = 0 AND EXTRACT(YEAR FROM operated_at) = 2023;

// Service fee sum
Select sum(amount) from disbursements where fee_type = 1 AND EXTRACT(YEAR FROM operated_at) = 2022;
Select sum(amount) from disbursements where fee_type = 1 AND EXTRACT(YEAR FROM operated_at) = 2023;

// Monthly fee count
Select count(*) from disbursements where fee_type = 2 AND EXTRACT(YEAR FROM operated_at) = 2022;
Select count(*) from disbursements where fee_type = 2 AND EXTRACT(YEAR FROM operated_at) = 2023;

// Monthly fee Sum
Select sum(amount) from disbursements where fee_type = 2 AND EXTRACT(YEAR FROM operated_at) = 2022;
Select sum(amount) from disbursements where fee_type = 2 AND EXTRACT(YEAR FROM operated_at) = 2023;
```

