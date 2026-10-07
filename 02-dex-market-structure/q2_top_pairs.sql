SELECT
    token_pair,
    COUNT(DISTINCT tx_hash) AS trade_count,
    SUM(amount_usd) AS volume_usd
FROM dex.trades
WHERE blockchain = 'ethereum'
  AND block_time > now() - interval '30' day
GROUP BY token_pair
ORDER BY volume_usd DESC
LIMIT 10
