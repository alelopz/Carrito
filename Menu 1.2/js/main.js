document.addEventListener('DOMContentLoaded', function () {
    let carrito = JSON.parse(localStorage.getItem('carrito')) || [];
    let idCarrito = null;
    const menuProductos = document.getElementById('menuProductos');
    const carritoItems = document.getElementById('carritoItems');
    const totalCarrito = document.getElementById('totalCarrito');
    const carritoContador = document.getElementById('carritoContador');
    const btnRealizarPedido = document.getElementById('btnRealizarPedido');
    const btnMesero = document.getElementById('btnMesero');
    const cartelVerCarrito = document.getElementById('cartelVerCarrito');
    const cartelCantidad = document.getElementById('cartelCantidad');
    const cartelTotal = document.getElementById('cartelTotal');
    const btnCartelVerCarrito = document.getElementById('btnCartelVerCarrito');
    const btnVaciarCarrito = document.getElementById('btnVaciarCarrito');
    const btnCarrito = document.getElementById('btnCarrito');

    // Referencias al modal del carrito
    const modalCarrito = document.getElementById('modalCarrito');
    const carritoItemsModal = document.getElementById('carritoItemsModal');
    const totalCarritoModal = document.getElementById('totalCarritoModal');
    const btnVaciarCarritoModal = document.getElementById('btnVaciarCarritoModal');
    const btnRealizarPedidoModal = document.getElementById('btnRealizarPedidoModal');
    const btnCerrarCarrito = document.getElementById('btnCerrarCarrito');
    const btnCerrarCarritoX = document.getElementById('btnCerrarCarritoX');

    // Chequeo de elementos clave
    const elementosClave = [
        { id: 'btnVaciarCarritoModal', ref: btnVaciarCarritoModal },
        { id: 'btnRealizarPedidoModal', ref: btnRealizarPedidoModal },
        { id: 'btnCerrarCarrito', ref: btnCerrarCarrito },
        { id: 'btnCerrarCarritoX', ref: btnCerrarCarritoX },
        { id: 'btnCartelVerCarrito', ref: btnCartelVerCarrito },
        { id: 'btnCarrito', ref: btnCarrito },
        { id: 'btnMesero', ref: btnMesero },
        { id: 'menuProductos', ref: menuProductos },
        { id: 'carritoItemsModal', ref: carritoItemsModal },
        { id: 'totalCarritoModal', ref: totalCarritoModal },
    ];
    elementosClave.forEach(e => {
        if (!e.ref) {
            console.warn('Elemento no encontrado en el HTML:', e.id);
        }
    });

    // Función para verificar si un elemento existe
    function elementoExiste(elemento) {
        return elemento !== null;
    }

    // Función para obtener la URL de la imagen
    function obtenerImagenUrl(img) {
        return img || 'img/default.jpg';
    }

    // Inicializar carrito
    async function inicializarCarrito() {
        try {
            const response = await fetch('api/carrito.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    action: 'crear',
                    cliente: 'cliente_' + Math.random().toString(36).substr(2, 9),
                    id_usuario: '1' // Por defecto, podrías obtenerlo de una sesión
                })
            });
            const data = await response.json();
            if (data.success) {
                idCarrito = data.id_carrito;
            }
        } catch (error) {
            console.error('Error al inicializar carrito:', error);
        }
    }

    // Filtrado por categorías
    let todosLosProductos = [];
    function mostrarProductos(productos) {
        todosLosProductos = productos;
        renderizarProductosPorCategoria('todas');
    }

    function renderizarProductosPorCategoria(categoria) {
        if (!elementoExiste(menuProductos)) return;

        menuProductos.innerHTML = '';
        let filtrados = categoria === 'todas' ? todosLosProductos : todosLosProductos.filter(p => (p.categoria || '').toLowerCase() === categoria.toLowerCase());
        if (filtrados.length === 0) {
            menuProductos.innerHTML = '<div class="col-12 text-center text-muted">No hay productos en esta categoría.</div>';
        }
        filtrados.forEach(producto => {
            const productoHTML = `
                <div class="col-md-6 col-lg-4">
                    <div class="card producto-card">
                        <img src="${obtenerImagenUrl(producto.img)}" class="card-img-top producto-imagen" alt="${producto.nombre}" onerror="this.src='img/default.jpg'">
                        <div class="card-body">
                            <h5 class="card-title">${producto.nombre}</h5>
                            <p class="card-text">${producto.descripcion}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="h5 mb-0">$${producto.precio}</span>
                                <button class="btn btn-primary" onclick="agregarAlCarrito('${producto.id_producto}')">
                                    <i class="fas fa-plus"></i> Agregar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            menuProductos.innerHTML += productoHTML;
        });
        menuProductos.innerHTML += '<div class="espaciador-movil"></div>';
    }

    // Evento para los botones de categoría
    document.querySelectorAll('.categoria-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.categoria-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            renderizarProductosPorCategoria(this.getAttribute('data-categoria'));
        });
    });

    function esMovil() {
        return window.innerWidth <= 768;
    }

    function mostrarCartelVerCarrito() {
        if (carrito.length > 0 && esMovil()) {
            cartelVerCarrito.classList.remove('d-none');
            cartelCantidad.textContent = carrito.reduce((acc, item) => acc + item.cantidad, 0);
            cartelTotal.textContent = `$${carrito.reduce((acc, item) => acc + item.precio * item.cantidad, 0).toFixed(2)}`;
        } else {
            cartelVerCarrito.classList.add('d-none');
        }
    }

    function ocultarCartelVerCarrito() {
        cartelVerCarrito.classList.add('d-none');
    }

    function actualizarContadorCarrito() {
        const carrito = JSON.parse(localStorage.getItem('carrito')) || [];
        const carritoContador = document.getElementById('carritoContador');
        const totalCantidad = carrito.reduce((acc, item) => acc + item.cantidad, 0);
        carritoContador.textContent = totalCantidad;
    }

    window.agregarAlCarrito = async function (id_producto) {
        try {
            const response = await fetch(`api/productos.php?id=${id_producto}`);
            const producto = await response.json();

            const itemExistente = carrito.find(item => item.id_producto === producto.id_producto);
            if (itemExistente) {
                itemExistente.cantidad++;
            } else {
                carrito.push({
                    id_producto: producto.id_producto,
                    nombre: producto.nombre,
                    precio: producto.precio,
                    img: producto.img,
                    cantidad: 1
                });
            }

            // Guardar en la base de datos
            await fetch('api/carrito.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    action: 'agregar',
                    id_carrito: idCarrito,
                    id_producto: producto.id_producto,
                    cantidad: itemExistente ? itemExistente.cantidad : 1,
                    precio_unitario: producto.precio
                })
            });

            localStorage.setItem('carrito', JSON.stringify(carrito));
            actualizarCarrito();
            actualizarContadorCarrito();
            mostrarCartelVerCarrito();
        } catch (error) {
            console.error('Error:', error);
        }
    }

    async function actualizarCarrito() {
        if (!elementoExiste(carritoItems)) return;

        carritoItems.innerHTML = '';
        let total = 0;
        let contador = 0;

        carrito.forEach(item => {
            contador += item.cantidad;
            total += item.precio * item.cantidad;
            const itemHTML = `
                <div class="carrito-item">
                    <img src="${obtenerImagenUrl(item.img)}" alt="${item.nombre}" onerror="this.src='img/default.jpg'">
                    <div class="carrito-info">
                        <h6>${item.nombre}</h6>
                        <p>$${item.precio}</p>
                    </div>
                    <div class="carrito-cantidad">
                        <button class="btn btn-sm btn-outline-secondary btn-cantidad" onclick="actualizarCantidad('${item.id_producto}', ${item.cantidad - 1})">-</button>
                        <span>${item.cantidad}</span>
                        <button class="btn btn-sm btn-outline-secondary btn-cantidad" onclick="actualizarCantidad('${item.id_producto}', ${item.cantidad + 1})">+</button>
                    </div>
                </div>
            `;
            carritoItems.innerHTML += itemHTML;
        });

        if (elementoExiste(totalCarrito)) {
            totalCarrito.textContent = `$${total.toFixed(2)}`;
        }
        if (elementoExiste(carritoContador)) {
            carritoContador.textContent = contador;
        }
        mostrarCartelVerCarrito();
    }

    window.actualizarCantidad = async function (id_producto, nuevaCantidad) {
        if (nuevaCantidad <= 0) {
            carrito = carrito.filter(item => item.id_producto !== id_producto);
        } else {
            const item = carrito.find(item => item.id_producto === id_producto);
            if (item) {
                item.cantidad = nuevaCantidad;
            }
        }

        // Actualizar en la base de datos
        try {
            await fetch('api/carrito.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    action: nuevaCantidad <= 0 ? 'eliminar' : 'actualizar',
                    id_detalle_carrito: id_producto,
                    cantidad: nuevaCantidad
                })
            });
        } catch (error) {
            console.error('Error al actualizar cantidad:', error);
        }

        localStorage.setItem('carrito', JSON.stringify(carrito));
        actualizarCarrito();
        actualizarContadorCarrito();
    }

    // Mostrar el modal del carrito
    function abrirModalCarrito() {
        actualizarCarrito();
        modalCarrito.classList.remove('d-none');
        document.body.style.overflow = 'hidden';
        renderizarCarritoModal();
    }

    // Cerrar el modal del carrito
    function cerrarModalCarrito() {
        modalCarrito.classList.add('d-none');
        document.body.style.overflow = '';
    }

    // Renderizar los productos en el modal del carrito
    function renderizarCarritoModal() {
        carritoItemsModal.innerHTML = '';
        let total = 0;
        carrito.forEach(item => {
            total += item.precio * item.cantidad;
            const itemHTML = `
                <div class="carrito-item">
                    <img src="${obtenerImagenUrl(item.img)}" alt="${item.nombre}" onerror="this.src='img/default.jpg'">
                    <div class="carrito-info">
                        <h6>${item.nombre}</h6>
                        <p>$${item.precio}</p>
                    </div>
                    <div class="carrito-cantidad">
                        <button class="btn btn-sm btn-outline-secondary btn-cantidad" onclick="actualizarCantidadModal('${item.id_producto}', ${item.cantidad - 1})">-</button>
                        <span>${item.cantidad}</span>
                        <button class="btn btn-sm btn-outline-secondary btn-cantidad" onclick="actualizarCantidadModal('${item.id_producto}', ${item.cantidad + 1})">+</button>
                    </div>
                </div>
            `;
            carritoItemsModal.innerHTML += itemHTML;
        });
        totalCarritoModal.textContent = `$${total.toFixed(2)}`;
    }

    // Actualizar cantidad desde el modal
    window.actualizarCantidadModal = async function (id_producto, nuevaCantidad) {
        await actualizarCantidad(id_producto, nuevaCantidad);
        renderizarCarritoModal();
    }

    // Botón para vaciar el carrito en el modal
    if (btnVaciarCarritoModal) {
        btnVaciarCarritoModal.addEventListener('click', async function () {
            try {
                await fetch('api/carrito.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        action: 'vaciar',
                        id_carrito: idCarrito
                    })
                });
                carrito = [];
                localStorage.setItem('carrito', JSON.stringify(carrito));
                renderizarCarritoModal();
                actualizarCarrito();
                actualizarContadorCarrito();
                mostrarCartelVerCarrito();
                cerrarModalCarrito();
                ocultarCartelVerCarrito();
            } catch (error) {
                console.error('Error al vaciar carrito:', error);
            }
        });
    }

    // Botón para realizar pedido en el modal
    if (btnRealizarPedidoModal) {
        btnRealizarPedidoModal.addEventListener('click', async function () {
            if (carrito.length === 0) {
                alert('El carrito está vacío');
                return;
            }

            const total = carrito.reduce((acc, item) => acc + item.precio * item.cantidad, 0);
            const modalPago = new bootstrap.Modal(document.getElementById('modalPago'));
            modalPago.show();

            // Configurar el botón de confirmar pago
            document.getElementById('btnConfirmarPago').onclick = async function () {
                const metodoPago = document.querySelector('input[name="metodoPago"]:checked')?.value;
                if (!metodoPago) {
                    alert('Por favor, seleccione un método de pago');
                    return;
                }

                try {
                    const response = await fetch('api/pedidos.php', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            action: 'crear',
                            id_usuario: '1', // Por defecto
                            id_cliente: 'cliente_' + Math.random().toString(36).substr(2, 9),
                            total: total,
                            items: carrito.map(item => ({
                                id_producto: item.id_producto,
                                cantidad: item.cantidad,
                                precio_unitario: item.precio
                            })),
                            metodo_pago: metodoPago
                        })
                    });

                    const data = await response.json();
                    if (data.success) {
                        alert('Pedido realizado con éxito');
                        carrito = [];
                        localStorage.setItem('carrito', JSON.stringify(carrito));
                        actualizarCarrito();
                        actualizarContadorCarrito();
                        cerrarModalCarrito();
                        modalPago.hide();
                    } else {
                        alert('Error al realizar el pedido');
                    }
                } catch (error) {
                    console.error('Error al realizar pedido:', error);
                    alert('Error al realizar el pedido');
                }
            };
        });
    }

    // Botones para cerrar el modal
    if (btnCerrarCarrito) {
        btnCerrarCarrito.addEventListener('click', cerrarModalCarrito);
    }
    if (btnCerrarCarritoX) {
        btnCerrarCarritoX.addEventListener('click', cerrarModalCarrito);
    }

    // Abrir modal desde el cartel flotante
    if (btnCartelVerCarrito) {
        btnCartelVerCarrito.addEventListener('click', function () {
            abrirModalCarrito();
            ocultarCartelVerCarrito();
        });
    }

    // Si quieres abrir el modal desde un botón de carrito en escritorio
    if (btnCarrito) {
        btnCarrito.addEventListener('click', function () {
            abrirModalCarrito();
        });
    }

    // Ocultar cartel si se cambia el tamaño de pantalla
    window.addEventListener('resize', mostrarCartelVerCarrito);

    // Manejar cambio de mesa
    // selectMesa.addEventListener('change', function () {
    //     mesaSeleccionada = this.value;
    //     btnMesero.disabled = !mesaSeleccionada;
    // });

    if (btnMesero) {
        btnMesero.addEventListener('click', async function () {
            try {
                const response = await fetch('api/llamar_mesero.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        id_mesa: 1, // Mesa por defecto
                        id_usuario: 1 // Usuario por defecto
                    })
                });
                const data = await response.json();
                if (data.success) {
                    alert('El mesero ha sido notificado y llegará pronto.');
                } else {
                    alert(data.error || 'Error al llamar al mesero');
                }
            } catch (error) {
                console.error('Error:', error);
                alert('Error al llamar al mesero');
            }
        });
    }

    // Cargar productos
    fetch('api/productos.php')
        .then(response => {
            if (!response.ok) {
                throw new Error('Error en la respuesta de la API: ' + response.status);
            }
            return response.json();
        })
        .then(productos => {
            if (!Array.isArray(productos) || productos.length === 0) {
                menuProductos.innerHTML = '<div class="col-12 text-center text-danger">No se encontraron productos. Verifica la base de datos o la API.</div>';
            } else {
                mostrarProductos(productos);
            }
        })
        .catch(error => {
            menuProductos.innerHTML = `<div class='col-12 text-center text-danger'>Error al cargar productos: ${error.message}</div>`;
            console.error('Error:', error);
        });

    // Inicializar carrito al cargar la página
    inicializarCarrito();
    actualizarCarrito();
    actualizarContadorCarrito();

    // Cargar mesas al iniciar
    // cargarMesas(); // ELIMINADO: el cliente no elige mesa
}); 