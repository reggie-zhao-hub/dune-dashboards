/*before you run this query,
 please make sure you have created the table dataset_sdn_eth_addresses in your own schema. 
 You can refer to the repository sdn_data to create the table:
 */
WITH sdn AS (
    SELECT address AS addr
    FROM dune.<your username>.dataset_sdn_eth_addresses --change to your own dataset.
),
counterparties AS (
    SELECT t."from" AS cp
    FROM ethereum.transactions t JOIN sdn s ON t."to" = s.addr
    WHERE t.block_time > now() - interval '365' day
    UNION ALL
    SELECT t."to" AS cp
    FROM ethereum.transactions t JOIN sdn s ON t."from" = s.addr
    WHERE t.block_time > now() - interval '365' day
)
SELECT
    cp AS counterparty,
    COUNT(*) AS interactions,
    MAX(l.name) AS entity_name
FROM counterparties c
LEFT JOIN labels.addresses l
    ON l.blockchain = 'ethereum' AND l.address = c.cp
GROUP BY cp
ORDER BY interactions DESC
LIMIT 20
