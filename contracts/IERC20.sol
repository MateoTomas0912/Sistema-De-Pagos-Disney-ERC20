//SPDX-License-Identifier: MIT 
pragma solidity >= 0.4.4 < 7.0.0;
pragma experimental ABIEncoderV2;

//interface del token ERC20
interface IERC20{
    //Funciones
    //devuelve la cantidad de tokens en existencia
    function totalSupply() external view returns (uint256);

    //devuelve la cantidad de tokens para una direccion indicada por parametro
    function balanceOf(address account) external view returns(uint256); 

    //devuelve el numero de tokens que la persona podra gastar en nombre del propietario
    function allowance(address owner, address spender) external view returns (uint256);

    //devuelve un valor booleano resultado de la operacion transferir
    function transfer(address recipient, uint256 amount) external returns(bool);

    //permite realizar una transferencia entre un cliente y disney
    function transferDisney(address _cliente,address recipient, uint256 amount) external returns(bool);

    //devuelve un valor booleano con el resultado de la operacion gasto
    function approve(address spender, uint256 amount) external returns (bool);

    //devuelve un booleano con el resultado de la operacion usando el metodo allowance
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    //Eventos
    //se debe emitir cuando una cantidad de tokens pase de un usuario a otro
    event Transfer(address indexed from, address indexed to, uint256 tokens);

    //se debe emitir cuando se establece una asignacion con el metodo allowance
    event Approval(address indexed owner, address indexed spender, uint256 tokens);
}
