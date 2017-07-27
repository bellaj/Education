contract ShlomiICO is ERC20, SafeMath{

	
	mapping(address => uint256) balances;

	uint256 public totalSupply;


	function balanceOf(address _owner) constant returns (uint256 balance) {
	    return balances[_owner];
	}

	function transfer(address _to, uint256 _value) returns (bool success){
	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
	    balances[_to] = safeAdd(balances[_to], _value);
	    Transfer(msg.sender, _to, _value);
	    return true;
	}

	mapping (address => mapping (address => uint256)) allowed;

	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
	    var _allowance = allowed[_from][msg.sender];
	    
	    balances[_to] = safeAdd(balances[_to], _value);
	    balances[_from] = safeSub(balances[_from], _value);
	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
	    Transfer(_from, _to, _value);
	    return true;
	}

	function approve(address _spender, uint256 _value) returns (bool success) {
	    allowed[msg.sender][_spender] = _value;
	    Approval(msg.sender, _spender, _value);
	    return true;
	}

	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
	    return allowed[_owner][_spender];
	}




	uint256 public endTime;

	modifier during_offering_time(){
		if (now >= endTime){
			throw;
		}else{
			_;
		}
	}

	function () payable during_offering_time {
		createTokens(msg.sender);
	}

	function createTokens(address recipient) payable {
		if (msg.value == 0) {
		  throw;
		}

		uint tokens = safeDiv(safeMul(msg.value, price), 1 ether);
		totalSupply = safeAdd(totalSupply, tokens);

		balances[recipient] = safeAdd(balances[recipient], tokens);

		if (!owner.send(msg.value)) {
		  throw;
		}
	}




	string 	public name = "ShlomiCoin";
	string 	public symbol = "SCO";
	uint 	public decimals = 3;
	uint256 public INITIAL_SUPPLY = 10000;
	uint256 public price;
	address public owner;

	function ShlomiICO() {
		totalSupply = INITIAL_SUPPLY;
		balances[msg.sender] = INITIAL_SUPPLY;  // Give all of the initial tokens to the contract deployer.
		endTime = now + 1 weeks;
		owner 	= msg.sender;
		price 	= 500;
	}

}

