SELECT
block_time,symbol,"from","to",amount,amount_usd,tx_hash
FROM tokens.transfers
WHERE blockchain = 'ethereum'
  AND symbol = 'USDT'
  AND amount_usd > {{min_amount}}
  AND block_time > now() - interval '7' day
  ORDER BY amount_usd DESC
  LIMIT 50
