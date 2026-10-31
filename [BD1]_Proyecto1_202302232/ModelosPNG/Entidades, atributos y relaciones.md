

|**ENTIDADES**|**ATRIBUTOS**|
|-|-|
|País|Código\_Pais (Pk) y Nombre|
|Departamento|Id\_Departamento (PK), Nombre, Código\_País (Fk)|
|Municipio|Id\_Municipio (PK), Nombre, Id\_Departamento (Fk)|
|Tienda|Id (Pk), Nombre, Dirección, Teléfono, Id\_Municipio (Fk) y Id\_tipo\_tienda (Fk)|
|Tipo\_tienda|Id (Pk), Nombre\_tipo *(conveniencia, supermercado, tienda mayorista o tienda especializada)*|
|Empleado|Código (Pk), Nombre, Apellido, Correo electrónico, Teléfono, Fecha de contratación y Tienda a la que pertenece (Fk)|
|Cargo\_empleado|Id (Pk), Nombre\_cargo (Gerente, Supervisor, Vendedor o Cajero).|
|Cliente|Código (Pk), Nombres, Apellidos, Número identificación, Correo electrónico, Dirección, Id\_Municipio (Fk) y Id\_tipo\_identificación (Fk)|
|Tipo\_identificación|Id (Pk), nombre\_identificación|
|Producto|Codigo (Pk), Nombre, Descripción, Precio, Existencia actual, id\_categoria (Fk), id\_marca (Fk)|
|Categoría\_Producto|Código\_categoria (Fk) y Nombre|
|Marca\_Producto|Código\_marca (Fk) y Nombre|
|Venta|Número único (Pk), Fecha, Id\_Cliente (Fk), Id\_Tienda (Fk), Id\_Empleado (Fk) y Id\_estado\_actual (Fk)|
|Estado\_Venta|Id, Tipo\_estado (Registrada, Pagada y Anulada)|
|Detalle\_Venta|Id\_Detalle\_Venta (Pk), Número\_Venta (Fk), Codigo\_Producto (Fk), Cantidad, Precio\_Unitario\_Venta y subtotal (es un calculo)|
|Metodo\_Pago|Id\_metodo (Pk), Nombre\_Metodo|
|Detalle\_Pago|Id\_Pago (Pk), Numero\_Venta (Fk), Id\_Metodo (Fk) y Monto\_Pagado|









#### Relaciones:



1. País - Departamento: (1:N)



2\. Departamento - Municipios: (1:N)



3\. Municipio - Tienda: (1:N)



4\. Municipio - Cliente: (1:N)



5\. Tipo\_tienda - Tienda: (1:N)



6\. Cargo\_empleado - Empleado: (1:N)



7\. Tienda - Empleado: (1:N)



8\. Tipo\_identificacion - Cliente: (1:N)



9\. Categoria\_producto - Producto: (1:N)



10\. Marca\_producto - Producto: (1:N)



11\. Tienda - Venta: (1:N)



12\. Empleado - Venta: (1:N)



13\. Cliente - Venta: (1:N)



14\. Estado\_venta - Venta: (1:N)



15\. Venta - Detalle\_Venta: (1:N)



16\. Producto - Detalle\_Venta: (1:N)

&#x20;

17\. Venta - Detalle\_Pago: (1:N)



18\. Metodo\_Pago - Detalle\_Pago: (1:N)

