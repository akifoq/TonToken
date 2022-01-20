# Simple token contract
The contract essentially proxies token holder requests, parallely updating balances map. In this way, it works similar to transfering extra currency, but with ability to add custom logic on transfers.

It also supports bouncing token transfers (which is useful in DEXes).

Also there is silent transfers, primary for wallet contracts which don't support the notifications.

`allowance` mechanism isn't implemented, because it's just an alternative to notify-on-transfer interface. It might be more convinient in synchronous Ethereum model, but is totally inconvinient for asynchronous TON architecture.
