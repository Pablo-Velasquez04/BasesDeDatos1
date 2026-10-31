# Comercial La Estrella — Proyecto Fase 2: Backend y Exposición de Servicios

**Curso:** Bases de Datos 1 · Segundo Semestre 2026
**Universidad de San Carlos de Guatemala — Facultad de Ingeniería — Ingeniería en Ciencias y Sistemas**
**Estudiante:** [NOMBRE COMPLETO] · **Carnet:** 202302232

<!-- Repositorio en GitHub (opcional). Si lo creas, quita las marcas de comentario y completa el enlace:
**Repositorio:** https://github.com/USUARIO/REPOSITORIO
-->

---

## 1. Descripción general

Este proyecto transforma el modelo relacional de la Fase 1 (diseñado en Oracle) en un backend funcional:

- **Base de datos:** Microsoft SQL Server 2022, ejecutada en un contenedor **Docker** y creada automáticamente con el script `init.sql` (tablas, llaves, 3 vistas analíticas y 2 triggers).
- **API REST:** Node.js + Express, con la librería `mssql`. Es la **única** vía para ingresar, consultar, modificar y eliminar datos.
- **Pruebas:** colección de Postman con el CRUD de las 17 tablas, los reportes (vistas) y los 3 escenarios de validación de los triggers.

```
Postman  ──HTTP/JSON──►  API REST (Node.js, puerto 3000)  ──mssql──►  SQL Server 2022 (Docker, puerto 1433)
                                                                        ├─ 17 tablas
                                                                        ├─ 2 triggers (reglas de negocio)
                                                                        └─ 3 vistas (reportes)
```

Reparto de responsabilidades (según el enunciado): las validaciones de inventario, el cambio automático de estado y los cálculos de los reportes los hace **el motor de base de datos** (triggers y vistas). La API solo expone los datos y traduce los errores del motor a respuestas HTTP.

---

## 2. Requisitos previos

| Herramienta | Uso |
|---|---|
| Docker Desktop (con docker compose) | Ejecutar SQL Server 2022 |
| Node.js 18 o superior y npm | Ejecutar la API y el script de carga |
| Postman | Ejecutar la colección de pruebas |
| DBeaver (opcional) | **Solo lectura**, para verificar la estructura de la base |

Se recomiendan al menos 8 GB de RAM (SQL Server necesita como mínimo 2 GB asignados a Docker).

---

## 3. Estructura del proyecto

```
[BD1]_ProyectoFase2_202302232/
├── docker-compose.yml        # SQL Server 2022 + inicialización automática
├── init.sql                  # Tablas, llaves, triggers y vistas
├── package.json              # Dependencias y scripts de Node.js
├── .env.example              # Plantilla de variables de entorno
├── README.md                 # Este documento
├── Imagenes/                 # Capturas de evidencia
├── postman/
│   └── ComercialLaEstrella.postman_collection.json
├── scripts/
│   ├── cargarExcel.js        # Carga el Excel a la base USANDO la API
│   ├── dataset_adaptado.xlsx # Datos adaptados a las tablas del proyecto
│   └── adaptar_dataset.py    # (Referencia) cómo se adaptó el Excel original
└── src/
    ├── server.js             # Arranque: conecta a la BD y abre el puerto
    ├── app.js                # Configuración de Express
    ├── config/db.js          # Conexión a SQL Server (variables de entorno)
    ├── middlewares/errorHandler.js   # Traduce errores de SQL Server a HTTP
    ├── routes/               # Una ruta por tabla + reportes + health
    └── controllers/          # Un controlador por tabla + reportes + health
```

---

## 4. Guía paso a paso para ejecutar el proyecto

Todos los comandos se ejecutan en una terminal **dentro de la carpeta raíz del proyecto**.

### Paso 1. Levantar el contenedor de SQL Server

Abre Docker Desktop y espera a que indique que el motor está corriendo. Luego:

```bash
docker compose up -d
```

Esto crea dos contenedores:

- `comercial_estrella_db`: SQL Server 2022. Tarda unos 30 a 60 segundos en estar listo.
- `comercial_estrella_db_init`: ejecuta `init.sql` automáticamente y termina. Solo corre la primera vez; si la base ya está inicializada, no hace nada.

Verifica la inicialización:

```bash
docker compose logs db-init
```

Debe terminar con el mensaje **`Base de datos inicializada correctamente.`**

### Paso 2. Configurar las variables de entorno

Copia la plantilla y, si lo deseas, cambia los valores:

```bash
cp .env.example .env        # en Windows (CMD): copy .env.example .env
```

| Variable | Valor por defecto | Descripción |
|---|---|---|
| `DB_HOST` | `localhost` | Servidor de SQL Server |
| `DB_PORT` | `1433` | Puerto publicado por Docker |
| `DB_USER` | `sa` | Usuario administrador |
| `DB_PASSWORD` | `Estrella2026!` | Contraseña (debe coincidir con la del contenedor) |
| `DB_NAME` | `ComercialLaEstrella` | Base de datos |
| `PORT` | `3000` | Puerto de la API |

> Si no existe el archivo `.env`, tanto `docker-compose.yml` como la API usan estos mismos valores por defecto.

### Paso 3. Instalar dependencias y ejecutar la API

```bash
npm install
npm start
```

Debe mostrar:

```
Conectado a SQL Server
API escuchando en http://localhost:3000
```

Verifica que la API ve la base abriendo `http://localhost:3000/api/health`. Debe responder:

```json
{ "ok": true, "base_de_datos": "ComercialLaEstrella", "tablas": 17, "vistas": 3, "triggers": 2 }
```

### Paso 4. Cargar los datos (a través de la API)

Con la API corriendo, abre **otra** terminal en la misma carpeta y ejecuta:

```bash
node scripts/cargarExcel.js
```

El script lee `scripts/dataset_adaptado.xlsx` hoja por hoja y envía un `POST` a la API por cada fila, en el orden que exigen las llaves foráneas. **No se conecta a SQL Server directamente.** Termina con `Carga terminada.` (carga 16 hojas; los 3 estados de venta ya vienen creados por `init.sql`).

La carga exige una base **vacía**: los ids que genera SQL Server deben coincidir con los del Excel. Si hay que repetirla:

```bash
docker compose down -v      # BORRA la base de datos y el volumen
docker compose up -d        # la recrea vacía con init.sql
# esperar a que db-init termine, reiniciar la API y volver a ejecutar la carga
```

### Paso 5. Ejecutar las pruebas en Postman

1. En Postman: **Import** y seleccionar `postman/ComercialLaEstrella.postman_collection.json`.
2. Con la API corriendo, clic en `...` junto a la colección → **Run** → **Start run**.
3. Resultado esperado: **118 peticiones y 162 pruebas aprobadas, 0 fallidas**.

| Carpeta | Contenido |
|---|---|
| `00 - Salud de la API` | `GET /api/health` |
| `01 - Escenarios de triggers` | Los 3 escenarios de validación del enunciado (ejecutar en orden) |
| `02 - Reportes (vistas)` | Las 3 vistas analíticas |
| `03 - CRUD ...` (17 carpetas) | Listar, obtener, crear, actualizar, eliminar y comprobar el 404, una carpeta por tabla |

> La carpeta 01 deja una venta de prueba y baja en 2 unidades la existencia del producto 1. Para repetir las pruebas con los valores originales, reiniciar la base (Paso 4).

---

## 5. Objetos de base de datos (en `init.sql`)

### Triggers

| Trigger | Tabla | Qué hace |
|---|---|---|
| `trg_Insert_Detalle` | `Detalle_Venta` | Se dispara tras insertar un detalle. Usa la tabla temporal `inserted` para sumar la cantidad pedida por producto y la compara con `Existencia_Actual`. Si no alcanza, ejecuta `ROLLBACK` y lanza `THROW 50001, 'Stock insuficiente'` (la API lo traduce a **HTTP 400**). Si alcanza, descuenta la cantidad del inventario. |
| `trg_Insert_Pago` | `Detalle_Pago` | Se dispara tras insertar un pago. Para cada venta afectada suma todos sus pagos y los compara con el total de la venta (suma de `Subtotal` de sus detalles). Si la suma alcanza o supera el total, cambia el estado de la venta de "Registrada" a **"PAGADA"**. |

Ambos trabajan con **conjuntos de filas** (un `INSERT` puede traer varias filas en `inserted`). Actúan solo en `INSERT`: un `PUT` o `DELETE` sobre detalles o pagos no reajusta inventario ni estado.

### Vistas

| Vista | Qué muestra |
|---|---|
| `Vista_Ventas_Ubicacion` | Por tienda: municipio, departamento, país, cantidad de ventas y total facturado (excluye ventas anuladas). |
| `Vista_Top_Productos` | Por producto: código, nombre, categoría, marca, unidades vendidas y monto total (excluye ventas anuladas). |
| `Vista_Saldos_Pendientes` | Ventas en estado "Registrada": total de la venta, total pagado (si hay abonos) y saldo pendiente. |

La API **no realiza JOINs ni cálculos** para los reportes: los endpoints solo ejecutan `SELECT * FROM <vista>`. (Única excepción simple: `GET /api/ventas` une `Estado_Venta` para mostrar el estado como texto en la columna `Estado`.)

---

## 6. Endpoints de la API

Base: `http://localhost:3000/api`. Todas las respuestas son JSON.

Cada recurso ofrece las cinco operaciones: `GET /recurso` (listar), `GET /recurso/:id`, `POST /recurso`, `PUT /recurso/:id` y `DELETE /recurso/:id`.

| Recurso | Tabla | | Recurso | Tabla |
|---|---|---|---|---|
| `/paises` | Pais | | `/clientes` | Cliente |
| `/departamentos` | Departamento | | `/empleados` | Empleado |
| `/municipios` | Municipio | | `/productos` | Producto |
| `/tipos-identificacion` | Tipo_Identificacion | | `/ventas` | Venta |
| `/cargos-empleado` | Cargo_Empleado | | `/detalles-venta` | Detalle_Venta |
| `/tipos-tienda` | Tipo_Tienda | | `/pagos` | Detalle_Pago |
| `/metodos-pago` | Metodo_Pago | | `/estados-venta` | Estado_Venta |
| `/categorias` | Categoria_Producto | | `/marcas` | Marca_Producto |
| `/tiendas` | Tienda | | | |

Reportes y salud:

| Endpoint | Fuente |
|---|---|
| `GET /api/reportes/ventas-ubicacion` | `Vista_Ventas_Ubicacion` |
| `GET /api/reportes/top-productos` | `Vista_Top_Productos` |
| `GET /api/reportes/saldos-pendientes` | `Vista_Saldos_Pendientes` |
| `GET /api/health` | Estado de la conexión y conteo de objetos |

Ejemplos de cuerpo (los nombres de los campos son los de las columnas; el id lo genera la base):

```jsonc
// POST /api/ventas   (Fecha y estado son opcionales: por defecto hoy y "Registrada")
{ "Tienda_Id_Tienda": 1, "Empleado_Codigo_Empleado": 1, "Cliente_Codigo_Cliente": 1 }

// POST /api/detalles-venta   (Subtotal opcional: se calcula como Cantidad x Precio_Unitario)
{ "Cantidad": 2, "Precio_Unitario": 100, "Venta_Numero_Venta": 1, "Producto_Codigo_Producto": 1 }

// POST /api/pagos
{ "Monto_Pagado": 80, "Venta_Numero_Venta": 1, "Metodo_Pago_Id_Metodo": 1 }
```

Códigos de respuesta:

| Código | Cuándo |
|---|---|
| `200` / `201` | Operación exitosa / registro creado |
| `400` | Stock insuficiente (trigger), campo obligatorio faltante o dato con formato inválido |
| `404` | Registro o ruta inexistente |
| `409` | Valor repetido (UNIQUE) o violación de llave foránea / CHECK |
| `500` | Error interno |

---

## 7. Datos de prueba

Los datos provienen del Excel entregado por el auxiliar (`dataset_comercial_la_estrella.xlsx`), cuyo modelo difiere del aprobado en la Fase 1. Se **adaptó el Excel a las tablas del proyecto** (no al revés), con `scripts/adaptar_dataset.py`:

- `PERSONA` no existe en el modelo del proyecto: sus nombres, correo y dirección se repartieron dentro de `Cliente` y `Empleado`.
- `CATALOGO_PRODUCTO` guardaba precio y existencia por tienda; el modelo del proyecto tiene una existencia y un precio por producto (suma de existencias y precio promedio). El precio real de cada venta se conserva en `Detalle_Venta.Precio_Unitario`.
- `ESTADO_VENTA` no se carga: `init.sql` ya crea `Registrada`, `PAGADA` y `Anulada`.

Volumen cargado: 1500 ventas, 3687 detalles de venta, 1389 pagos, 300 clientes, 88 empleados, 114 productos y 20 tiendas.

---

## 8. Evidencias

> Las capturas se guardan en la carpeta `Imagenes/` con los nombres indicados. Valores esperados sobre una base recién cargada.

### 8.1 Triggers

**Verificación de conexión (`GET /api/health`)**

![Health](Imagenes/01-health.png)

**Existencia inicial del producto 1 (antes de las pruebas): 1112**

![Existencia inicial](Imagenes/02-existencia-inicial.png)

**Escenario 1 — Inventario (fallo).** `POST /api/detalles-venta` con una cantidad mayor a la existencia. El trigger aborta la transacción y la API responde **HTTP 400** con el mensaje `Stock insuficiente`.

![Escenario 1: HTTP 400](Imagenes/03-escenario1-fallo-400.png)

Comprobación: la existencia no cambió (el `ROLLBACK` deshizo la operación).

![Escenario 1: sin cambio](Imagenes/04-escenario1-sin-cambio.png)

**Escenario 2 — Inventario (éxito).** `POST` con una cantidad válida (2 unidades) responde **HTTP 201**.

![Escenario 2: HTTP 201](Imagenes/05-escenario2-exito-201.png)

Un `GET` inmediato al producto muestra la existencia reducida en 2 (de 1112 a 1110).

![Escenario 2: existencia reducida](Imagenes/06-escenario2-existencia-reducida.png)

**Escenario 3 — Estado de venta.** La venta de prueba vale 200. Se registran pagos parciales de 80 y 70 (acumulado 150): la API solo confirma el pago y la venta sigue **"Registrada"**.

![Escenario 3: sigue Registrada](Imagenes/07-escenario3-sigue-registrada.png)

Se registra el pago final de 50 (acumulado 200 = total):

![Escenario 3: pago final](Imagenes/08-escenario3-pago-final-201.png)

Un `GET` a la venta muestra el estado **"PAGADA"**, cambiado automáticamente por el motor:

![Escenario 3: PAGADA](Imagenes/09-escenario3-pagada.png)

### 8.2 Vistas

**`Vista_Ventas_Ubicacion`** — una fila por tienda.

![Vista_Ventas_Ubicacion](Imagenes/10-vista-ventas-ubicacion.png)

**`Vista_Top_Productos`** — de mayor a menor cantidad vendida.

![Vista_Top_Productos](Imagenes/11-vista-top-productos.png)

**`Vista_Saldos_Pendientes`** — ventas "Registrada" con total, pagado y saldo.

![Vista_Saldos_Pendientes](Imagenes/12-vista-saldos-pendientes.png)

### 8.3 Resultado global de la colección de Postman

![Resumen del Runner](Imagenes/13-resumen-runner-162-pruebas.png)

### 8.4 Infraestructura

**Inicialización automática de la base (`docker compose logs db-init`)**

![Docker: init.sql](Imagenes/14-docker-init.png)

**Carga del Excel a través de la API (`node scripts/cargarExcel.js`)**

![Carga del Excel](Imagenes/15-carga-excel.png)

**Estructura verificada en DBeaver (solo lectura): 17 tablas, 3 vistas y 2 triggers**

![DBeaver](Imagenes/16-dbeaver-estructura.png)

---

## 9. Cumplimiento de las reglas del enunciado

| Requisito | Cómo se cumple |
|---|---|
| SQL Server 2022 en Docker con docker-compose | `docker-compose.yml`; no se usa ninguna instancia local |
| Inicialización automática por script DDL | El servicio `db-init` ejecuta `init.sql` (tablas, llaves, vistas y triggers) |
| Todo el CRUD pasa por el API REST | Endpoints para las 17 tablas; la carga del Excel también usa la API |
| DBeaver solo para verificación estructural | Conexión configurada como solo lectura |
| Reglas de negocio en el motor | Triggers `trg_Insert_Detalle` y `trg_Insert_Pago` |
| Reportes sin JOINs en la API | Endpoints que consultan las 3 vistas |
| Colección de Postman con CRUD y triggers | `postman/ComercialLaEstrella.postman_collection.json` |
| Conexión mediante variables de entorno | `.env` leído por `src/config/db.js` |

---

## 10. Solución de problemas

| Síntoma | Causa probable y solución |
|---|---|
| `failed to connect to the docker API` | Docker Desktop no está corriendo. Ábrelo y espera a que el motor inicie. |
| `Cannot open database "ComercialLaEstrella"` al iniciar la API | `db-init` aún no terminó. Espera y revisa `docker compose logs db-init`; la API reintenta sola unas veces. |
| `Login failed for user 'sa'` | La contraseña del `.env` no coincide con la del contenedor. Usa la misma, o ejecuta `docker compose down -v` y vuelve a levantar. |
| El puerto 1433 ya está en uso | Hay otro SQL Server local. Define `DB_PORT=1434` en el `.env` y reinicia con `docker compose up -d`. |
| `Ruta no encontrada: GET /health` | Falta `/api` en la URL. La ruta correcta es `/api/health`. |
| El script de carga dice "La base ya tiene datos" | La carga exige una base vacía. Ejecuta `docker compose down -v` y `docker compose up -d`. |
| El script de carga dice que el id no coincide | La base no estaba vacía. Reiníciala como en el punto anterior. |
| Postman: `Could not get response` | La API no está corriendo. Ejecuta `npm start`. |

---

## 11. Comandos útiles

```bash
docker compose up -d          # levantar la base
docker compose logs db-init   # ver la inicialización
docker compose down           # detener (conserva los datos)
docker compose down -v        # detener y BORRAR los datos
npm start                     # iniciar la API
node scripts/cargarExcel.js   # cargar los datos por la API
```
