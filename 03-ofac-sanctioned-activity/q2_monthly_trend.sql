/*before you run this query,
 please make sure you have created the table dataset_sdn_eth_addresses in your own schema. 
 You can refer to the repository sdn_data to create the table:
 */
WITH sdn AS (
    SELECT address AS addr
    FROM dune.<your username>.dataset_sdn_eth_addresses), -- change to your own dataset.
flows AS (
    SELECT t.block_time, t.value
    FROM ethereum.transactions t JOIN sdn s ON t."from" = s.addr
    WHERE t.block_time > now() - interval '365' day
    UNION ALL
    SELECT t.block_time, t.value
    FROM ethereum.transactions t JOIN sdn s ON t."to" = s.addr
    WHERE t.block_time > now() - interval '365' day
)
SELECT
    date_trunc('month', block_time) AS month,
    COUNT(*) AS tx_count,
    SUM(value / 1e18) AS eth_volume
FROM flows
GROUP BY 1
ORDER BY 1
