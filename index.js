var choosenToken;
var provider, account;
var signer;
var contract;
var transferValue;
var contractSigned;
var charge = 0.00005;

connectWallet();

async function connectWallet() {
  provider = new ethers.providers.Web3Provider(window.ethereum);
  account = await provider.send("eth_requestAccounts", []);
  signer = await provider.getSigner();
  contract = new ethers.Contract(
    ExchangeContractAddress,
    ExchangeABI,
    provider
  );
  contractSigned = contract.connect(signer);
  alert(account);
}

async function exchangeToken() {
  let val = $("#userToken").val();
  let matic = { value: ethers.utils.parseEther(`${val}`) }; // put ``
  let TokenSend = await contractSigned.exchangeToken(matic);
  // alert(`Your order of ${val} has been received`);
  alert(TokenSend.data.error);
}

async function changeRate() {
  changePageRate();
  await contractSigned.changeChargeData(
    ethers.utils.parseEther($("#changeRate").val())
  );
  console.log("DONE");
}

function getValue(value) {}

async function getData() {
  let Details = await contractSigned.getHolderData($("#getDetails").val());
  alert(
    "Address : " +
      Details[0] +
      ", Tokens: " +
      Details[1] / 10 ** 18 +
      ",  TimeStamp: " +
      Details[2]
  );
}

function changePageRate() {
  rate = $("#changeRate").val();
}

function setTokenMTO() {
  choosenToken = "MTO";
  $("#selectToken").text("MTO");
  let value = $("#userToken").val();
  transferValue = (value * 1) / charge;
  $("#getToken").val(transferValue);
}

// Data

var ExchangeContractAddress = "0x835f7c1643ec969BeF8c5d1746C96872c345E2e9";

var ExchangeABI = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_chargeValue",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_chargeDecimal",
        type: "uint256",
      },
    ],
    name: "changeChargeData",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_start",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_end",
        type: "uint256",
      },
    ],
    name: "changeTime",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_tokenAddress",
        type: "address",
      },
    ],
    name: "changeTokenAddress",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "previousOwner",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "TransferOwner",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "ChargeValue",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "chargeDecimal",
        type: "uint256",
      },
    ],
    name: "chargeChanged",
    type: "event",
  },
  {
    inputs: [],
    name: "exchangeToken",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "payable",
    type: "function",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "newRate",
        type: "uint256",
      },
    ],
    name: "rateChanged",
    type: "event",
  },
  {
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_newOwner",
        type: "address",
      },
    ],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "Claim",
    outputs: [
      {
        internalType: "address",
        name: "recivier",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "mtoToken",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "timeStamp",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_address",
        type: "address",
      },
    ],
    name: "getHolderData",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "HoldByAddress",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "owner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];
