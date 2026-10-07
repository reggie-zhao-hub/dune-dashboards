SELECT
    block_date,
    COUNT(*) AS big_tx_count,
    SUM(amount_usd) AS big_tx_volume_usd
FROM tokens.transfers
WHERE blockchain = 'ethereum'
  AND symbol = 'USDT'
  AND amount_usd > {{min_amount}}
  AND block_time > now() - interval '90' day
GROUP BY block_date
ORDER BY block_date
