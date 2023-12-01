geth init --datadir node_01 genesis.json
geth init --datadir node_02 genesis.json

bootnode -genkey boot.key
bootnode -nodekey boot.key -addr :30305

geth --datadir node_01 --port 30306 --bootnodes enode://a52f108d96da0318eca414177f19b08688e007a8bf7142b7b62f7a47771230155809f055012e33197d318a69d748c48f521e1ed88d2b54bcfe073241305f56bf@127.0.0.1:0?discport=30301  --networkid 123454321 --unlock 0x22e6eEb50319650DABE208c2e00eDf9D80b571C4 --password node_01/password.txt --authrpc.port 8551 --mine --miner.etherbase 0x22e6eEb50319650DABE208c2e00eDf9D80b571C4
geth --datadir node_02 --port 30307 --bootnodes enode://a52f108d96da0318eca414177f19b08688e007a8bf7142b7b62f7a47771230155809f055012e33197d318a69d748c48f521e1ed88d2b54bcfe073241305f56bf@127.0.0.1:0?discport=30301  --networkid 123454321 --unlock 0x9c901034B699864908792C03e720823268ED4122 --password node_02/password.txt --authrpc.port 8552

# this one doesnt work
# geth --datadir node_01 --port 30306 --bootnodes enode://a52f108d96da0318eca414177f19b08688e007a8bf7142b7b62f7a47771230155809f055012e33197d318a69d748c48f521e1ed88d2b54bcfe073241305f56bf@127.0.0.1:0?discport=30301  --networkid 123454321 --unlock 0x22e6eEb50319650DABE208c2e00eDf9D80b571C4 --password node_01/password.txt --rpc --rpcaddr '0.0.0.0' --rpcport 8501 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --rpccorsdomain "*" --mine --miner.etherbase 0x22e6eEb50319650DABE208c2e00eDf9D80b571C4 --gasprice '1'


geth attach node_01/geth.ipc

# Javascript
net.peerCount
admin.peers

eth.accounts
eth.getBalance(eth.accounts[0])

# send some Wei
eth.sendTransaction({
  to: '0x9c901034B699864908792C03e720823268ED4122',
  from: eth.accounts[0],
  value: 25000
});

# check the transaction was successful by querying Node 2's account balance
eth.getBalance('0x9c901034B699864908792C03e720823268ED4122');