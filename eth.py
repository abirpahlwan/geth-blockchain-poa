# built-in packages import
import argparse
from decimal import Decimal

# 3rd party packages import
from web3 import Web3
from web3.middleware import geth_poa_middleware

# where should i use geth_poa_middleware?


# create a parser object
parser = argparse.ArgumentParser(description="Script Description")

# add arguments
parser.add_argument("command", help="Command to execute", choices=[
                    "getBalance", "sendEth", "getAccounts"])
parser.add_argument("-a", "--ownAddress", help="Owner's Address")
parser.add_argument("-t", "--toAddress", help="Other's Address")
parser.add_argument("-n", "--amount", help="Amount of ETH to send")

# parse the arguments from command line
args = parser.parse_args()

# get the arguments
command = args.command
ownAddress = args.ownAddress
toAddress = args.toAddress
amount = args.amount

# connect to the Ethereum node
w3 = Web3(Web3.HTTPProvider("http://localhost:8545"))
w32 = Web3(Web3.HTTPProvider("http://localhost:8546"))

w3.middleware_onion.inject(geth_poa_middleware, layer=0)
# w32.middleware_onion.inject(geth_poa_middleware, layer=0)

# check if my private blockchain network is connected


def isConnected():
    return w3.is_connected()

# check existing accounts in the node


def getAccounts():
    if not isConnected():
        # error with message not connected to ethereum node
        raise (Exception("Not connected to Ethereum node"))

    # List available Ethereum accounts
    node1accounts = w3.eth.accounts
    node2accounts = w32.eth.accounts
    allAccounts = node1accounts + node2accounts
    if len(allAccounts) > 0:
        return allAccounts
    else:
        return []


def getBalance(address):
    if not isConnected():
        # error with message not connected to ethereum node
        raise (Exception("Not connected to Ethereum node"))

    # Convert the address to a checksum address
    address_to_check = w3.to_checksum_address(address)
    if not address_to_check:
        print("Address is not valid!!")
        return None

    # Check the balance of the address
    balance_wei = w3.eth.get_balance(address_to_check)

    # Convert the balance from wei to ether
    balance_eth = w3.from_wei(balance_wei, 'ether')

    return balance_eth


def sendEth(fromAddress, toAddress, amount):
    if not isConnected():
        # error with message not connected to ethereum node
        raise (Exception("Not connected to Ethereum node"))

    amount_wei = w3.to_wei(amount, 'ether')

    # check if enough balance available
    if Decimal(getBalance(fromAddress)) < int(amount):
        print(f"Available balance: {Decimal(getBalance(fromAddress))} ETH")
        print(f"Requested amount: {amount} ETH")
        print(f"Not enough balance to send {amount} ETH from {fromAddress}")
        return False

     # Get the current base fee
    base_fee = w3.eth.gas_price

    # Calculate maxFeePerGas and maxPriorityFeePerGas
    max_fee_per_gas = base_fee
    max_priority_fee_per_gas = w3.to_wei('1', 'gwei')

    # Send the ETH
    tx_hash = w3.eth.send_transaction({
        'from': fromAddress,
        'to': toAddress,
        'value': amount_wei,
        'maxFeePerGas': max_fee_per_gas,
        'maxPriorityFeePerGas': max_priority_fee_per_gas,
    })

    # Get the transaction receipt
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

    # Check if the transaction was successful
    if tx_receipt['status'] == 1:
        print(f"Transaction successful. Hash: {tx_hash}")
    else:
        print(f"Transaction failed. Hash: {tx_hash}")
        return False

    return True

# check if an account number exists in the blockchain


def isAccount(accountNumber):
    if not isConnected():
        # error with message not connected to ethereum node
        raise (Exception("Not connected to Ethereum node"))

    # Check if the account exists
    if accountNumber in getAccounts():
        return True
    else:
        return False


# create account
# eb4394e531cb8812e118be301f15a72fc05fb58c99cff6f44bdbe4d044f74b52
# 0xb42d4ad620Cd7C86Fd3dE15dD65cD0FA64bC3fF3


if command == "getAccounts":
    print(getAccounts())
elif command == "getBalance":
    if not isAccount(ownAddress):
        print("Address is not valid")
    else:
        if ownAddress:
            balance = getBalance(ownAddress)
            if balance:
                print(f"Balance of {ownAddress} is {balance} ETH")
            else:
                print(f"Address {ownAddress} not found")
        else:
            print("Missing argument for -getBalance.")
elif command == "sendEth":
    if ownAddress and toAddress and amount:
        sendEth(ownAddress, toAddress, amount)
    else:
        print("Missing argument for -sendEth.")
else:
    print("Invalid command. Please use -getBalance or -sendEth.")