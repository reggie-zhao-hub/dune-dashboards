WITH big_senders AS (
    SELECT
        "from" AS address,
        COUNT(*) AS tx_count,
        SUM(amount_usd) AS total_usd
    FROM tokens.transfers
    WHERE blockchain = 'ethereum'
      AND symbol = 'USDT'
      AND amount_usd > {{min_amount}}
      AND block_time > now() - interval '30' day
    GROUP BY "from"
    ORDER BY total_usd DESC
    LIMIT 20
)
SELECT
    b.address,
    b.tx_count,
    b.total_usd,
    l.name AS entity_name,
    l.category AS entity_category
FROM big_senders b
LEFT JOIN labels.addresses l
    ON l.blockchain = 'ethereum'
   AND l.address = b.address
ORDER BY b.total_usd DESC
