//SPDX-License-Identifier: MIT 
pragma solidity >0.4.4 < 0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

contract Disney{
    //Variables
    //instancia del contrato ERC20
    ERC20Basic private token;
    //owner del contrato
    address payable public owner;
    //clientes de Disney
    struct cliente {
        uint tokensComprados;
        string[] atraccionesDisfrutadas;
    } 
    //relacion para registrar clientes
    mapping (address => cliente) public clientes;

    //Constructor
    //genera el token con una cantidad de 10.000 y asigna como owner a quien despliega
    constructor() public {
        token = new ERC20Basic(10000);
        owner = msg.sender;
    }

    //Modificadores
    //controla que el ejecutor de la funcion sea disney
    modifier Unicamente(address _owner){
        require(_owner == msg.sender, "No tienes permisos para ejecutar la funcion");
        _;
    }

    //FUNCIONES DEL TOKEN
    //establece el precio del token en paridad con el ethereum
    function PrecioTokens(uint _numTokens) internal pure returns (uint){
        return _numTokens * (1 ether);
    }

    //permite comprar tokens
    function ComprarTokens(uint _numTokens) public payable {
        uint coste = PrecioTokens(_numTokens);
        require(msg.value >= coste, "Dinero insuficiente para la cantidad requerida");

        //si envia dinero de mas se le retorna la diferencia al cliente
        uint diferenciaPago = msg.value - coste;
        msg.sender.transfer(diferenciaPago);
        
        uint balance = Balance();
        require(_numTokens <= balance, "Compra menos tokens");

        //transfiere el numero de tokens al cliente
        token.transfer(msg.sender, _numTokens);
        clientes[msg.sender].tokensComprados += _numTokens;
    }

    //permite generar mas tokens
    function GenerarTokens(uint _numTokens) public Unicamente(msg.sender){
        token.increaseTottalSupply(_numTokens);
    }

    //devuelve los tokens disponibles del contrato
    function Balance() public view returns (uint){
        return token.balanceOf(address(this));
    }

    //devuelve el numero de tokens restantes de un cliente
    function MisTokens() public view returns(uint){
        return token.balanceOf(msg.sender);
    }

    //FUNCIONES PARA GESTION INTERNA DE DISNEY
    
    //Eventos
    //emitido cuando el cliente se sube a una atraccion
    event disfutaAtraccion(string);
    //emitido cuando se crea una atraccion
    event nuevaAtraccion(string, uint);
    //emitido cuando se elimina una atraccion
    event bajaAtraccion(string);
    //emitido cuando el cliente se sube a una atraccion
    event disfutaComida(string);
    //emitido cuando se crea una atraccion
    event nuevaComida(string, uint);
    //emitido cuando se elimina una atraccion
    event bajaComida(string);

    //Variables
    //estructura de la atraccion
    struct atraccion {
        string nombre;
        uint precio;
        bool estado;
    }

    //estructura de las comidas
    struct comida {
        string nombre;
        uint precio;
        bool estado;
    }

    //relaciona un nombre de atraccion con su estructura de datos
    mapping (string => atraccion) public mappingAtracciones;

    //relaciona un nombre con la comida correspondiente
    mapping(string => comida) public mappingComidas;

    //arreglo para almacenar las atracciones
    string[] arrayAtracciones;

    //arreglo para almacenar las comidas
    string[] arrayComidas;

    //relaciona un cliente con su historial de atracciones 
    mapping (address => string[]) historialAtracciones;

    //relaciona un cliente con su historial de comidas consumidas
    mapping(address => string[]) historialComidas;

    //FUNCIONES
    //permite crear nuevas atracciones
    function NuevaAtraccion(string memory _nombreAtraccion, uint _precio) public Unicamente(msg.sender){
        mappingAtracciones[_nombreAtraccion] = atraccion(_nombreAtraccion, _precio, true);
        arrayAtracciones.push(_nombreAtraccion);
        emit nuevaAtraccion(_nombreAtraccion, _precio);
    }

    //permite dar de baja una atraccion
    function BajaAtraccion(string memory _nombreAtraccion) public Unicamente(msg.sender){
        mappingAtracciones[_nombreAtraccion].estado = false;
        emit bajaAtraccion(_nombreAtraccion);
    }

    //permite pagar para subirse a una atraccion
    function SubirseAtraccion(string memory _nombreAtraccion) public {
        uint tokensAtraccion = mappingAtracciones[_nombreAtraccion].precio;

        require(mappingAtracciones[_nombreAtraccion].estado == true, "La atraccion no esta disponible");
        require(tokensAtraccion <= MisTokens(), "No tienes tokens suficientes");

        token.transferDisney(msg.sender, address(this), tokensAtraccion);
        historialAtracciones[msg.sender].push(_nombreAtraccion);

        emit disfutaAtraccion(_nombreAtraccion);
    }

    //permite devolver tokens cuando el cliente quiere
    function DevolverTokens(uint _nroTokens) public payable {
        require(_nroTokens > 0, "Necesitas devolver una cantidad positiva");
        require(_nroTokens <= MisTokens(), "Quieres devolver mas tokens de los que tienes disponibles");

        token.transferDisney(msg.sender, address(this), _nroTokens);
        msg.sender.transfer(PrecioTokens(_nroTokens));
    }

    //permite crear una comida 
    function CrearComida(string memory _nombreComida, uint _precio) public {
        mappingComidas[_nombreComida] = comida(_nombreComida, _precio, true);
        arrayComidas.push(_nombreComida);
        emit nuevaComida(_nombreComida, _precio);
    }

    //permite dar de baja una comida
    function BajaComida(string memory _nombreComida) public {
        mappingComidas[_nombreComida].estado = false;
        emit bajaComida(_nombreComida);
    }

    //permita consumir una comida
    function ComprarComida(string memory _nombreComida) public {
        uint tokensComida = mappingComidas[_nombreComida].precio;

        require(tokensComida <= MisTokens(), "No tienes tokens suficientes para consumir esta comida");
        
        token.transferDisney(msg.sender, address(this), tokensComida);
        historialComidas[msg.sender].push(_nombreComida);

        emit disfutaComida(_nombreComida);
    }

    //permite visualizar las atracciones 
    function VerAtracciones() public view returns(string[] memory){
        return arrayAtracciones;
    }

    //permite visualizar las comidas
    function VerComidas() public view returns (string[] memory){
        return arrayComidas;
    }

    //permite visualizar el historial de atracciones del cliente
    function VerHistorialCliente() public view returns(string[] memory){
        return historialAtracciones[msg.sender];
    }

    //permite visualizar el historial de comidas del cliente
    function VerHistorialComidas() public view returns(string[] memory){
        return historialComidas[msg.sender];
    }
}