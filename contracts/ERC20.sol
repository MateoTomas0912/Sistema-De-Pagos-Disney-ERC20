//SPDX-License-Identifier: MIT 
pragma solidity >= 0.4.4 < 7.0.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";
import "./IERC20.sol";

//contrato del token ERC20 basado en IERC20
contract ERC20Basic is IERC20{
    //invocamos la libreria safe math para las operaciones de uint256
    using SafeMath for uint256;

    //Eventos
    //se debe emitir cuando una cantidad de tokens pase de un usuario a otro
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    //se debe emitir cuando se establece una asignacion con el metodo allowance
    event Approval(address indexed owner, address indexed spender, uint256 tokens);

    //Variables
    //nombre del token
    string public constant name = "ERC20BlockchainAZ";
    //simbolo del token
    string public constant symbol = "ERC";
    //decimales con los que permite trabajar
    uint8 public constant decimals = 2;
    //relaciona cada direccion con una cantidad de tokens
    mapping(address => uint) balances;
    //relaciona la division de tokens de una address hacia otras address
    mapping(address => mapping(address => uint)) allowed;
    //cantidad total de token disponibles
    uint256 totalSupply_;

    //constructor
    //al principio se le asigna el totalSupply al creador del token
    constructor(uint256 _initialSupply) public {
        totalSupply_ = _initialSupply;
        balances[msg.sender] = totalSupply_;
    }

    //Funciones
    //devuelve la cantidad de tokens en existencia
    function totalSupply() public override view returns (uint256){
        return totalSupply_;
    }

    //devuelve la cantidad de tokens para una direccion indicada por parametro
    function balanceOf(address _tokenOwner) public override view returns(uint256){
        return balances[_tokenOwner];
    }

    //devuelve el numero de tokens que la persona podra gastar en nombre del propietario
    function allowance(address _owner, address _delegate) public override view returns (uint256){
        return allowed[_owner][_delegate];
    }  

    //permite incrementar el token supply en nombre de un usuario que ejecuta la funcion
    function increaseTottalSupply(uint _newTokensAmount) public {
        totalSupply_ += _newTokensAmount;
        balances[msg.sender] += _newTokensAmount;
    }

    //permite realizar una transferencia
    function transfer(address _recipient, uint256 _amount) public override returns(bool){
        require(_amount <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(_amount);
        balances[_recipient] = balances[_recipient].add(_amount);

        emit Transfer(msg.sender, _recipient, _amount);

        return true;
    }

    //permite realizar una transferencia entre un cliente y disney
    function transferDisney(address _cliente, address _recipient, uint256 _amount) public override returns(bool){
        require(_amount <= balances[msg.sender]);

        balances[_cliente] = balances[_cliente].sub(_amount);
        balances[_recipient] = balances[_recipient].add(_amount);

        emit Transfer(_cliente, _recipient, _amount);

        return true;
    }

    //permite delegar a otro usuario una _amount de tokens para gastar. No cambia de propietario, solo permite delegar
    function approve(address _delegate, uint256 _amount) public override returns(bool){
        allowed[msg.sender][_delegate] = _amount;
        emit Approval(msg.sender, _delegate, _amount);

        return true;
    }

    //transfiere de un propietario que nos da permisos para realizar la operacion hacia un buyer
    //el msg.sender actua como intermediario delegado por parte del owner
    function transferFrom(address _owner, address _buyer, uint256 _amount) public override returns (bool){
        require(balances[_owner] >= _amount);
        require(_amount <= allowed[_owner][msg.sender]);
        
        balances[_owner] = balances[_owner].sub(_amount);
        allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(_amount);
        balances[_buyer] = balances[_buyer].add(_amount);
        emit Transfer(_owner, _buyer, _amount);

        return true;
    }
}