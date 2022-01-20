# Simple token contract
The contract essentially proxies token holder requests, parallely updating balances map. In this way, it works similar to transfering extra currency, but with ability to add custom logic on transfers.

It also supports bouncing token transfers (which is useful in DEXes).

Also there is silent transfers, primary for wallet contracts which don't support the notifications.

`allowance` mechanism isn't implemented, because it's just an alternative to notify-on-transfer interface. It might be more convinient in synchronous Ethereum model, but is totally inconvinient for asynchronous TON architecture.

## Ownable branch
Here is an example of reference implementation modification.

## Token requests and responses
As per `func/scheme.tlb`.
### Transfer
```
transfer#4034a3c0 query_id:uint64
    reciever:MsgAddrSmpl amount:Extra body:Any = Request;
```
Regular token transfer. Sends a notification to receiver contract, which carries all of the remaining message value and indicated body. After receiving a response, sends the remaining toncoins to the original sender.
### Recv_transfer
```
recv_transfer#0x5fb163bd query_id:uint64
    sender:MsgAddrSmpl amount:Extra body:Any = Request;
```
A notification of regular transfer. The receiver contract (e.g. a decentralized exchange) may perform some action based on the `sender`, `amount` and `body` and expected to send a response (with the same `query_id`), carring remaining message value. If such query is bounced, or a `0xffffffff` op returned, token contract processes a rollback.
### Confirm_transfer
```
confirm_transfer#0xbc85eb11 query_id:uint64
    reciever:MsgAddrSmpl change:Extra body:Any = Response;
```
A confirmation of receiving a transfer notification. The token contract resends `body` and remaining value to the original request sender. Also reciever can return some `change` of token.
### Transfer_ok
```
transfer_ok#0x9f94a9c5 query_id:uint64
    reciever:MsgAddrSmpl change:Extra body:Any = Response;
```  
Notification of a successful regular transfer.
### Transfer_fail
```
transfer_fail#0xbed2072b query_id:uint64
    reciever:MsgAddrSmpl change:Extra = Response;
```   
Notification of a failed and rolled back regular transfer.
### Silent_transfer
```
silent_transfer#0x333cd134 query_id:uint64
    reciever:MsgAddrSmpl amount:Extra = Request;
```    
Just change `balances` map without sending a notification. Primary for transfers on user wallet contracts which don't support notifications.
### Silent_transfer_ok
```
silent_transfer_ok#0xb48aba01 query_id:uint64 = Response;
```
Silent transfer confirmation.
