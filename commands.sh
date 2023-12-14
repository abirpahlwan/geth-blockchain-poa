geth account new --datadir node_01
geth account new --datadir node_02

geth init --datadir node_01 genesis.json
geth init --datadir node_02 genesis.json

bootnode -genkey boot.key
bootnode -nodekey boot.key -addr :30305

clef --keystore ./node_01/keystore --configdir ./clef --chainid 123454321 --suppress-bootwarn init
clef --keystore ./node_01/keystore --configdir ./clef --chainid 123454321 --suppress-bootwarn setpw 0x08a427de46773b907a9c406f81948aa22d2d3260
clef --keystore ./node_01/keystore --configdir ./clef --chainid 123454321 --suppress-bootwarn --nousb

geth --datadir node_01 --port 30306 --bootnodes enode://a52f108d96da0318eca414177f19b08688e007a8bf7142b7b62f7a47771230155809f055012e33197d318a69d748c48f521e1ed88d2b54bcfe073241305f56bf@127.0.0.1:0?discport=30301 --networkid 123454321 --unlock 0x22e6eEb50319650DABE208c2e00eDf9D80b571C4 --password node_01/password.txt --authrpc.port 8551 --mine --miner.etherbase 0x1585917171590cA54D324D047c7B9c5ac6a6a589
geth --datadir node_02 --port 30307 --bootnodes enode://a52f108d96da0318eca414177f19b08688e007a8bf7142b7b62f7a47771230155809f055012e33197d318a69d748c48f521e1ed88d2b54bcfe073241305f56bf@127.0.0.1:0?discport=30301 --networkid 123454321 --unlock 0x9c901034B699864908792C03e720823268ED4122 --password node_02/password.txt --authrpc.port 8552

# this one doesnt work
# geth --datadir node_01 --port 30306 --bootnodes enode://a52f108d96da0318eca414177f19b08688e007a8bf7142b7b62f7a47771230155809f055012e33197d318a69d748c48f521e1ed88d2b54bcfe073241305f56bf@127.0.0.1:0?discport=30301 --networkid 123454321 --unlock 0x22e6eEb50319650DABE208c2e00eDf9D80b571C4 --password node_01/password.txt --rpc --rpcaddr '0.0.0.0' --rpcport 8501 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --rpccorsdomain "*" --mine --miner.etherbase 0x22e6eEb50319650DABE208c2e00eDf9D80b571C4 --gasprice '1'

geth --datadir ./node_01 --unlock "0x08A427De46773b907a9C406F81948Aa22D2D3260" --password node_01/password.txt --networkid 123454321 --mine --miner.etherbase "0x08A427De46773b907a9C406F81948Aa22D2D3260" --port 30306 --http --http.addr '127.0.0.1' --http.port 8501 --http.corsdomain "*"
geth --datadir ./node_02 --unlock "0x2ee97631432aD774AAC16f73AC6892fae6D817db" --password node_02/password.txt --networkid 123454321 --mine --miner.etherbase "0x2ee97631432aD774AAC16f73AC6892fae6D817db"
geth --datadir ./node_03 --unlock "0x528EA91FA33F1C194E176929F22Adda8e4687d82" --password node_03/password.txt --networkid 123454321 --port 30306 --authrpc.port 8551 --mine --miner.etherbase "0x528EA91FA33F1C194E176929F22Adda8e4687d82"

geth --datadir ./node_02 --signer ./clef/clef.ipc console

geth attach node_01/geth.ipc

# Geth Javascript Console
net.peerCount
admin.peers

eth.accounts
eth.getBalance(eth.accounts[0])

# send some Wei
eth.sendTransaction({
  to: '0x2ee97631432aD774AAC16f73AC6892fae6D817db',
  from: eth.accounts[0],
  value: 25
});

eth.sendTransaction({  to: '0x528EA91FA33F1C194E176929F22Adda8e4687d82',  from: eth.accounts[0],  value: 50000000000000000000000000000000 });
var tx = { from: '0x08a427de46773b907a9c406f81948aa22d2d3260', to: '0x528EA91FA33F1C194E176929F22Adda8e4687d82', value: 50000000000000000000000000000000 };
var tx = { from: '0x2ee97631432ad774aac16f73ac6892fae6d817db', to: '0x08A427De46773b907a9C406F81948Aa22D2D3260', value: 50000000000000000000000000000000 };
eth.sendTransaction(tx);

# check the transaction was successful by querying Node 2's account balance
eth.getBalance('0x2ee97631432aD774AAC16f73AC6892fae6D817db');

# doesnt work
# eth.getBalance('0x2ee97631432aD774AAC16f73AC6892fae6D817db').then(result => web3.utils.fromWei(result,"ether"))

web3.eth.getBalance('0x528EA91FA33F1C194E176929F22Adda8e4687d82', function (error, wei) {
    if (!error) {
        var balance = web3.utils.fromWei(wei, 'ether');
        console.log(balance + " ETH");
    }
});


# Hootum - hootum
/usr/bin/geth --datadir /root/hootum/node1 --port 30306 --bootnodes enode://210425feb653676de7014b463324e7c62933740a590e55b2868a461d8c1b1463dd7d998d61f7ba1aeeee780d0c80789d526fbb78ed5276cc40a37895bf8ee462@127.0.0.1:0?discport=30305 --networkid 138129 --unlock 0x0a179cc93fd1bd008Db536Be2828941B8E43D682 --password /root/hootum/node1/password.txt --mine --miner.etherbase 0x0a179cc93fd1bd008Db536Be2828941B8E43D682 --http --http.addr 0.0.0.0 --http.vhosts=chain.hootum.io,localhost --allow-insecure-unlock --syncmode full
/usr/bin/geth --datadir /root/hootum/node3 --port 30326 --bootnodes enode://210425feb653676de7014b463324e7c62933740a590e55b2868a461d8c1b1463dd7d998d61f7ba1aeeee780d0c80789d526fbb78ed5276cc40a37895bf8ee462@127.0.0.1:0?discport=30305 --networkid 138129 --unlock 0x813E669712eDb6c8916BaB58b3F5F933cB3F96De --password /root/hootum/node3/password.txt --mine --miner.etherbase 0x813E669712eDb6c8916BaB58b3F5F933cB3F96De --authrpc.port 8562 --http --http.port 8547 --http.addr 0.0.0.0 --http.vhosts=chain.hootum.io,localhost --allow-insecure-unlock --syncmode full

# Hootum - hootum-chain-02
geth --datadir /root/hootum-chain-02/node4 --port 30336 --bootnodes enode://210425feb653676de7014b463324e7c62933740a590e55b2868a461d8c1b1463dd7d998d61f7ba1aeeee780d0c80789d526fbb78ed5276cc40a37895bf8ee462@64.227.158.244:0?discport=30305 --networkid 138129 --unlock 0x0cC7e5D30867e6f0c2573eE4Fd9eACcd0B8742B3 --password /root/hootum-chain-02/node4/password.txt --mine --miner.etherbase 0x0cC7e5D30867e6f0c2573eE4Fd9eACcd0B8742B3 --authrpc.port 8563 --http --http.port 8548 --http.addr 0.0.0.0 --http.vhosts=chain.hootum.io --allow-insecure-unlock --syncmode full
geth --datadir /root/hootum-chain-02/node5 --port 30346 --bootnodes enode://210425feb653676de7014b463324e7c62933740a590e55b2868a461d8c1b1463dd7d998d61f7ba1aeeee780d0c80789d526fbb78ed5276cc40a37895bf8ee462@64.227.158.244:0?discport=30305 --networkid 138129 --unlock 0xFfffcC8579De94b29B6bf82E7552DDd5EFa9DAE5 --password /root/hootum-chain-02/node5/password.txt --mine --miner.etherbase 0xFfffcC8579De94b29B6bf82E7552DDd5EFa9DAE5 --authrpc.port 8564 --http --http.port 8549 --http.addr 0.0.0.0 --http.vhosts=chain.hootum.io --allow-insecure-unlock --syncmode full
