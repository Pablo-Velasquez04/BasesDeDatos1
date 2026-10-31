// =====================================================================
// routes/index.js - Punto central de rutas. Todo cuelga de /api.
// Una linea por cada tabla: URL -> archivo de rutas de esa tabla.
// =====================================================================
const { Router } = require('express');

const router = Router();

router.use('/health', require('./health.routes'));
router.use('/paises', require('./pais.routes'));
router.use('/departamentos', require('./departamento.routes'));
router.use('/municipios', require('./municipio.routes'));
router.use('/tipos-identificacion', require('./tipo_identificacion.routes'));
router.use('/cargos-empleado', require('./cargo_empleado.routes'));
router.use('/tipos-tienda', require('./tipo_tienda.routes'));
router.use('/metodos-pago', require('./metodo_pago.routes'));
router.use('/estados-venta', require('./estado_venta.routes'));
router.use('/categorias', require('./categoria_producto.routes'));
router.use('/marcas', require('./marca_producto.routes'));
router.use('/tiendas', require('./tienda.routes'));
router.use('/clientes', require('./cliente.routes'));
router.use('/empleados', require('./empleado.routes'));
router.use('/productos', require('./producto.routes'));
router.use('/ventas', require('./venta.routes'));
router.use('/detalles-venta', require('./detalle_venta.routes'));
router.use('/pagos', require('./detalle_pago.routes'));

module.exports = router;
