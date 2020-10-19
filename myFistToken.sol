// SPDX-License-Identifier: MIT                 r
pragma solidity >=0.6.0;

// Contrat FistToken à améliorer dans les exercices
contract FirstToken {
    mapping(address => uint256) public balances;
    mapping(address => bool) public investors;
    mapping(address => bool) public owners;
    
    address payable wallet;

    event Purchase(
        address indexed _buyer,
        uint256 _amount_ether,
        uint256 _amount_token
    );

    modifier atLeast1Ether() {
        require(msg.value >= 1, 'Minimun 1 Ether');
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == wallet, 'Only onwners can use this function');
        _;
    }

    constructor(address payable _wallet) public {
        wallet = _wallet;
    }

    receive() external payable {
        buyToken();
    }

    fallback() external payable {
        wallet.transfer(msg.value);
    }
    
    function setInvestor(address _investor) public onlyOwner returns(bool) {
        investors[_investor] = true;
    }
    
    function unSetInvestor(address _investor) public onlyOwner returns(bool) {
        investors[_investor] = false;
    }


    function buyToken() public atLeast1Ether payable{
        uint multiplier = investors[msg.sender] ? 10 : 1;
        uint nbToken = multiplier * msg.value / 1;
        balances[msg.sender] += nbToken;
        wallet.transfer(msg.value);
        emit Purchase(msg.sender, msg.value, nbToken);
    }
}