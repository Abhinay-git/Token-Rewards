// Connect to Ethereum provider
if (window.ethereum) {
    window.web3 = new Web3(window.ethereum);
    window.ethereum.request({ method: "eth_requestAccounts" });
} else {
    alert("Please install MetaMask to use this feature!");
}

const contractAddress = "0xBc3D7a9f9D7Cc94633F9fE54b711B62301D35967 ";
const contractABI = [
    [
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "internalType": "uint256",
                    "name": "id",
                    "type": "uint256"
                },
                {
                    "indexed": true,
                    "internalType": "address",
                    "name": "sender",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "internalType": "string",
                    "name": "feedback",
                    "type": "string"
                }
            ],
            "name": "FeedbackCreated",
            "type": "event"
        },
        {
            "inputs": [
                {
                    "internalType": "string",
                    "name": "feedback",
                    "type": "string"
                }
            ],
            "name": "createFeedback",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "",
                    "type": "uint256"
                }
            ],
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "id",
                    "type": "uint256"
                }
            ],
            "name": "getFeedback",
            "outputs": [
                {
                    "internalType": "string",
                    "name": "",
                    "type": "string"
                },
                {
                    "internalType": "address",
                    "name": "",
                    "type": "address"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        }
    ]
];

const contract = new web3.eth.Contract(contractABI, contractAddress);

// Donate function
async function donate() {
    const accounts = await web3.eth.getAccounts();
    const amount = document.getElementById("donationAmount").value;
    if (!amount) return alert("Please enter an amount!");

    try {
        await contract.methods.donate().send({
            from: accounts[0],
            value: web3.utils.toWei(amount, "ether"),
        });
        alert("Donation successful! Tokens will be credited.");
    } catch (error) {
        console.error(error);
        alert("Transaction failed!");
    }
}

// Get token balance
async function getBalance() {
    const accounts = await web3.eth.getAccounts();
    const balance = await contract.methods.balanceOf(accounts[0]).call();
    document.getElementById("tokenBalance").innerText = balance + " Tokens";
}

// Auto-fetch balance on load
window.onload = getBalance;
