/*before you run this query,
 please make sure you have created the table dataset_sdn_eth_addresses in your own schema. 
 You can refer to the repository "ofac-sdn-crypto-addresses" to create the table:
 */
WITH sdn AS (
    SELECT
    address AS addr,
    entity
    FROM dune.<your username>.dataset_sdn_eth_addresses   -- change to your own dataset.
),
out_flow AS (
    SELECT s.addr, s.entity,
    MAX(t.block_time) AS last_active, COUNT(*) AS tx_count
    FROM ethereum.transactions t
    JOIN sdn s ON t."from" = s.addr
    WHERE t.block_time > now() - interval '365' day
    GROUP BY s.addr, s.entity
),
in_flow AS (
    SELECT s.addr, s.entity,
           MAX(t.block_time) AS last_active, COUNT(*) AS tx_count
    FROM ethereum.transactions t
    JOIN sdn s ON t."to" = s.addr
    WHERE t.block_time > now() - interval '365' day
    GROUP BY s.addr, s.entity
)
SELECT addr, entity,
       MAX(last_active) AS last_active_time,
       SUM(tx_count) AS tx_count_1y
FROM (SELECT * FROM out_flow UNION ALL SELECT * FROM in_flow)
GROUP BY addr, entity
ORDER BY last_active_time DESC
