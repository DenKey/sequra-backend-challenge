# TABLE

| Year | Number of Disbursement | Amount disbursed to merchants | Amount of order fees | Number of monthly fees charged (From minimum monthly fee) | Amount of monthly fee charged (From minimum monthly fee) |
| :---: | ---: | ---: | ---: | ---: | ---: |
| 2022 | 1471 | 16471127.75 | 153192.11 | 8 | 126.20 | 
| 2023 | 1024 | 17543732.92 | 161319.06 | 8 | 144.74 | 

# MONEY CHECKS
34329371.84 (total migrated orders sum)

34329371.84 == 16471127.75 + 17543732.92 + 153192.11 + 161319.06 (total disbursted)

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

# INSTALL

User rvm (or corresponding program) to handle ruby version and gemset

`rvm install ruby-3.2.2`
'rvm use ruby-3.2.2@sequra-denys-kriukov'

Install gems

`bundle install`

Create db and migrate

`rake db:setup`

Import historical data form CSV files. It will take 6-7 minutes

`rake import:all`

Generate disbursements for historical data. It will take near 2 minutes.

'rake history:calculate'
 
Start sidekiq

`bundle exec sidekiq`

Check sidekiq running job exectue in rails console

`Sidekiq::Cron::Job.all`

# NOTE
Hi Guys,

During my work with this task, I made the assumption that all data in CSV was valid and clear, so I skipped 
a lot of validation work and exception control. Due to the lack of time, I added only base specs for the main service.
Adding class comments in Rails projects is a discussable thing in each team so here I am laying on the readability of code.

Thanks for your time.

Best regards,
Den Key