-- Total ETH Donated
SELECT SUM(ethAmount) 
  FROM ethereum.public.logs WHERE contract_address = '0x2a7096f07749096ff70F3F50ba20097506642Bf6' 
  AND topic = '0x' || SUBSTR(keccak256('DonationReceived(address,uint256)'), 3)

-- Total BUILD Received
SELECT SUM(amountOut) 
  FROM ethereum.public.logs WHERE contract_address = '0x2a7096f07749096ff70F3F50ba20097506642Bf6' 
  AND topic = '0x' || SUBSTR(keccak256('SwapExecuted(address,address,uint256,uint256)'), 3) AND toToken = '0x0a0E0FccC2c799845214E8E5583E44479EC02a23'

-- Top Supporters (ETH)
WITH Donations AS (SELECT donor, SUM(ethAmount) AS total_eth_donated 
  FROM ethereum.public.logs WHERE contract_address = '0x2a7096f07749096ff70F3F50ba20097506642Bf6' 
  AND topic = '0x' || SUBSTR(keccak256('DonationReceived(address,uint256)'), 3) GROUP BY donor) 
  SELECT donor, total_eth_donated FROM Donations ORDER BY total_eth_donated DESC LIMIT 10

-- Number of Donations
SELECT COUNT(DISTINCT tx_hash) FROM ethereum.public.logs 
  WHERE contract_address = '0x2a7096f07749096ff70F3F50ba20097506642Bf6' AND topic = '0x' || SUBSTR(keccak256('DonationReceived(address,uint256)'), 3)

-- Donations Over Time (Daily)
SELECT DATE(block_time), SUM(ethAmount) FROM ethereum.public.logs 
  WHERE contract_address = '0x2a7096f07749096ff70F3F50ba20097506642Bf6' AND topic = '0x' || SUBSTR(keccak256('DonationReceived(address,uint256)'), 3) 
  GROUP BY DATE(block_time) ORDER BY DATE(block_time)