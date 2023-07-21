# Smart Contract de Disney

¡Bienvenido al Smart Contract de Disney! Este contrato te permite disfrutar del mágico mundo de Disney comprando y utilizando tokens de Disney para acceder a atracciones y opciones de comida. Este proyecto fue realizado en el marco del curso Solidity de la A a la Z en Udemy.
A continuación, se explica el funcionamiento de este contrato inteligente:

## Funciones

### ComprarTokens

Esta función te permite comprar tokens de Disney. Simplemente envía una cantidad de Ether equivalente al costo de los tokens que deseas adquirir.

### GenerarTokens

Permite al propietario del contrato generar más tokens de Disney y aumentar el suministro total del token.

### Balance

Devuelve la cantidad de tokens de Disney disponibles en el contrato.

### MisTokens

Devuelve el número de tokens de Disney que posee el cliente que invoca la función.

### NuevaAtraccion

Permite al propietario del contrato crear nuevas atracciones en Disney. Debes proporcionar el nombre y el precio de la nueva atracción.

### BajaAtraccion

Permite al propietario del contrato dar de baja una atracción existente en Disney. Debes proporcionar el nombre de la atracción que deseas eliminar.

### SubirseAtraccion

Permite al cliente subirse a una atracción de Disney. Se deducirá la cantidad de tokens correspondiente al precio de la atracción de su saldo de tokens.

### DevolverTokens

Permite al cliente devolver una cantidad específica de tokens de Disney y recibir Ether a cambio según la tasa de conversión.

### CrearComida

Permite al propietario del contrato crear nuevas opciones de comida en Disney. Debes proporcionar el nombre y el precio de la nueva comida.

### BajaComida

Permite al propietario del contrato dar de baja una opción de comida existente en Disney. Debes proporcionar el nombre de la comida que deseas eliminar.

### ComprarComida

Permite al cliente comprar y consumir una opción de comida en Disney. Se deducirá la cantidad de tokens correspondiente al precio de la comida de su saldo de tokens.

### VerAtracciones

Devuelve un arreglo con los nombres de todas las atracciones disponibles en Disney.

### VerComidas

Devuelve un arreglo con los nombres de todas las opciones de comida disponibles en Disney.

### VerHistorialCliente

Devuelve un arreglo con los nombres de las atracciones que el cliente ha disfrutado en Disney.

### VerHistorialComidas

Devuelve un arreglo con los nombres de las comidas que el cliente ha consumido en Disney.

¡Esperamos que disfrutes tu experiencia en Disney utilizando este Smart Contract!
