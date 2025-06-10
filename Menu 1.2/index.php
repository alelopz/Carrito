<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurante - Menú Digital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">Restaurante</a>
            <div class="d-flex">
                <button class="btn btn-warning me-2" id="btnMesero">
                    <i class="fas fa-bell"></i> Llamar Mesero
                </button>
                <button class="btn btn-primary" id="btnCarrito">
                    <i class="fas fa-shopping-cart"></i> Carrito
                    <span class="badge bg-danger" id="carritoContador">0</span>
                </button>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <!-- Menú de productos -->
            <div class="col-12">
                <h2>Nuestro Menú</h2>
                <div class="categorias-carrusel mb-3">
                    <div id="categoriasScroll" class="d-flex overflow-auto gap-2">
                        <button class="btn btn-outline-primary categoria-btn active" data-categoria="todas">Todas</button>
                        <button class="btn btn-outline-primary categoria-btn" data-categoria="Hamburguesas">Hamburguesas</button>
                        <button class="btn btn-outline-primary categoria-btn" data-categoria="Pizzas">Pizzas</button>
                        <button class="btn btn-outline-primary categoria-btn" data-categoria="Bebidas">Bebidas</button>
                        <button class="btn btn-outline-primary categoria-btn" data-categoria="Menú del día">Menú del día</button>
                        <button class="btn btn-outline-primary categoria-btn" data-categoria="Postres">Postres</button>
                    </div>
                </div>
                <div class="row" id="menuProductos">
                    <!-- Los productos se cargarán dinámicamente -->
                </div>
            </div>
        </div>
    </div>

    <!-- Modal de métodos de pago -->
    <div class="modal fade" id="modalPago" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Métodos de Pago</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="list-group">
                        <label class="list-group-item">
                            <input class="form-check-input me-1" type="radio" name="metodoPago" value="Efectivo">
                            <i class="fas fa-money-bill-wave"></i> Efectivo
                        </label>
                        <label class="list-group-item">
                            <input class="form-check-input me-1" type="radio" name="metodoPago" value="Debito">
                            <i class="fas fa-credit-card"></i> Tarjeta de Débito
                        </label>
                        <label class="list-group-item">
                            <input class="form-check-input me-1" type="radio" name="metodoPago" value="Targeta de Credito">
                            <i class="fas fa-credit-card"></i> Tarjeta de Crédito
                        </label>
                        <label class="list-group-item">
                            <input class="form-check-input me-1" type="radio" name="metodoPago" value="Mercado pago">
                            <i class="fas fa-mobile-alt"></i> Mercado Pago
                        </label>
                        <label class="list-group-item">
                            <input class="form-check-input me-1" type="radio" name="metodoPago" value="Transferencia">
                            <i class="fas fa-exchange-alt"></i> Transferencia
                        </label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" id="btnConfirmarPago">Confirmar Pago</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Cartel flotante para ver carrito en móvil -->
    <div id="cartelVerCarrito" class="cartel-ver-carrito d-none">
        <div class="d-flex justify-content-between align-items-center w-100">
            <div>
                <span id="cartelCantidad">0</span> producto(s)
                <span id="cartelTotal">$0.00</span>
            </div>
            <button class="btn btn-pink" id="btnCartelVerCarrito">Ver carrito</button>
        </div>
    </div>

    <!-- Modal/Pantalla flotante del carrito -->
    <div id="modalCarrito" class="modal-carrito d-none">
        <div class="modal-carrito-content">
            <div class="modal-carrito-header d-flex align-items-center justify-content-between">
                <button class="btn btn-link text-dark fs-3" id="btnCerrarCarrito" aria-label="Cerrar"><i class="fas fa-arrow-left"></i></button>
                <h3 class="mb-0">Tu Pedido</h3>
                <button class="btn btn-link text-dark fs-3 d-md-none" id="btnCerrarCarritoX" aria-label="Cerrar"><i class="fas fa-times"></i></button>
            </div>
            <div class="modal-carrito-body">
                <div id="carritoItemsModal">
                    <!-- Los items del carrito se mostrarán aquí -->
                </div>
                <hr>
                <div class="d-flex justify-content-between">
                    <h4>Total:</h4>
                    <h4 id="totalCarritoModal">$0.00</h4>
                </div>
                <div class="d-flex justify-content-between align-items-center mt-3">
                    <button class="btn btn-danger" id="btnVaciarCarritoModal">
                        <i class="fas fa-trash"></i> Vaciar
                    </button>
                    <button class="btn btn-success w-100 ms-2" id="btnRealizarPedidoModal">
                        Realizar Pedido
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/main.js"></script>
</body>
</html> 