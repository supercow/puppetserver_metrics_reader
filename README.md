# Puppetserver Metrics Reader

This script parses a provided JSON dump of the Puppetserver metrics endpoint.

The most critical metrics for troubleshooting performance issues are displayed.
The output is not everything you need to troubleshoot a performance issue, but
it is much easier to read than the raw JSON.

## Example Usage

```
root@puppetserver:~ $ curl -k https://localhost:8140/status/v1/services?level=debug > metrics.json
root@puppetserver:~ $ cd src/puppetserver_metrics_reader
root@puppetserver:~/src/puppetserver_metrics_reader $ bundle install
root@puppetserver:~/src/puppetserver_metrics_reader $ bundle exec ./puppetserver_metrics_reader ~/metrics.json

+---------------------------+--------------------+
|              JRuby Status Summary              |
+---------------------------+--------------------+
| average-lock-wait-time    | 3952               |
| num-free-jrubies          | 0                  |
| borrow-count              | 336495             |
| average-requested-jrubies | 21.26451141962475  |
| borrow-timeout-count      | 0                  |
| return-count              | 336483             |
| borrow-retry-count        | 0                  |
| average-borrow-time       | 13519              |
| num-jrubies               | 12                 |
| requested-count           | 336525             |
| average-lock-held-time    | 34965              |
| average-free-jrubies      | 1.4718122605668822 |
| num-pool-locks            | 112                |
| average-wait-time         | 25979              |
+---------------------------+--------------------+
+-------------------------------------------+----------------+
|                    HTTP Metrics Summary                    |
+-------------------------------------------+----------------+
| Endpoint                                  | Mean time (ms) |
+-------------------------------------------+----------------+
| puppet-v3-catalog-/*/                     | 71408          |
| puppet-v3-node-/*/                        | 34617          |
| puppet-v3-report-/*/                      | 32213          |
| puppet-v3-file_metadata-/*/               | 30993          |
| puppet-v3-file_metadatas-/*/              | 17939          |
| puppet-v3-file_content-/*/                | 261            |
| puppet-experimental-dashboard_html        | 152            |
| puppet-v3-static_file_content-/*/         | 75             |
| puppet-experimental-metrics-dashboard-/*/ | 2              |
| All requests                              | 40167          |
+-------------------------------------------+----------------+
+--------------+--------------+
| Catalog Compilation Summary |
+--------------+--------------+
| count        | 48888        |
| mean         | 37841        |
| aggregate    | 1849970808   |
+--------------+--------------+
+------------------+-----------+
|    Top 5 Functions in ms     |
+------------------+-----------+
| require          | 787       |
| contain          | 281       |
| include          | 130       |
| create_resources | 110       |
| union            | 26        |
+------------------+-----------+
+--------------------------------+-----------+
|            Top 10 Classes in ms            |
+--------------------------------+-----------+
| Class[Root_user]               | 7298      |
| Class[Users]                   | 4838      |
| Class[puppet_agent]            | 2091      |
| Class[Users::Managed_accounts] | 2085      |
| Class[puppet_agent::linux]     | 1924      |
| Class[Software_repos]          | 1907      |
| Class[Os_packages]             | 1830      |
| Class[Ssh_keys]                | 1677      |
| Class[middleware_logrotate]    | 1597      |
| Class[logrotate]               | 1468      |
+--------------------------------+-----------+

```
