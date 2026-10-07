SELECT
    block_date,
    project,
    SUM(amount_usd) AS daily_volume
FROM dex.trades
WHERE blockchain = 'ethereum'
  AND block_time > now() - interval '30' day
GROUP BY block_date, project
ORDER BY block_date
