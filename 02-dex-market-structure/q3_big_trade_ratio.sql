SELECT
    block_date,
    COUNT(*) AS total_trades,
    COUNT_IF(amount_usd > 100000) AS big_trades,
    COUNT_IF(amount_usd > 100000) * 1.0 / COUNT(*) AS big_trade_ratio
FROM dex.trades
WHERE blockchain = 'ethereum'
  AND block_time > now() - interval '90' day
GROUP BY block_date
ORDER BY block_date
