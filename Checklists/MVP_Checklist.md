# Checklist MVP: Xoan Academy (Prioridad por Flujo de Valor)

Objetivo: Validar ventas rápidamente con código 100% en español.

## 1. Prioridad Alta: Cimientos e Infraestructura

_Sin esto, nada funciona. Es la base del sistema._

- [x] **Configuración Inicial**:
  - [x] Dependencias (`@supabase/supabase-js`, etc).
  - [x] Variables de Entorno (`.env`).
  - [x] Tipos TypeScript en Español (`Usuario`, `Curso`, `Pedido`).
- [x] **Base de Datos (Supabase + Custom Auth)**:
  - [x] Tablas: `users_app`, `perfiles`, `cursos`, `pedidos`, `inscripciones`.
  - [x] Buckets: `comprobantes_pago`, `contenido_curso`.
- [x] **Autenticación Base (Backend Propio)**:
  - [x] Contexto `ProveedorAutenticacion`.
  - [x] Pantallas: `IniciarSesion.tsx`, `Registro.tsx`.

## 2. Prioridad Alta: Gestión del Producto (¿Qué vendemos?)

_Necesitamos cursos en el sistema para poder mostrarlos._

- [x] **Panel Admin: Gestión de Cursos**:
  - [x] Crear/Editar Curso (Título, Precio, Descripción).
  - [x] Subir/Enlazar Contenido.
  - [x] Publicar Curso (Switch On/Off).

## 3. Prioridad Alta: La Vitrina y Venta (Captar y Cobrar)

_El corazón del MVP de Meralis: Vender._

- [x] **Refactorización Frontend**:
  - [x] Traducir estructura (`Inicio.tsx`, `Cursos.tsx`).
  - [x] Navegación pública.
- [x] **Flujo de Ventas**:
  - [x] **Página de Presentación** (`Inicio.tsx`): Oferta clara y CTA.
  - [x] **Catálogo** (`Cursos.tsx`): Listado de precios.
- [x] **Procesamiento de Pago** (`Pago.tsx`):
  - [x] Validación de usuario logueado.
  - [x] **Transferencia**: Mostrar cuenta -> Subir comprobante -> Crear Pedido.
  - [x] **Efectivo**: Botón WhatsApp -> Crear Pedido (o contacto directo).

## 4. Prioridad Media: Gestión del Negocio (Validar Cobros)

_Cerrar la venta "manualmente" como especifica el modelo lean._

- [x] **Panel Admin: Gestión de Pedidos**:
  - [x] Listar pedidos `pendiente`.
  - [x] Ver y validar comprobantes.
  - [x] **Aprobar**: Pasa a `pagado` y crea `inscripcion`.
  - [x] **Rechazar**: Notificar error.

## 5. Prioridad Media: Entrega de Valor (Consumo)

_El estudiante accede a lo que compró._

- [x] **Área del Estudiante**:
  - [x] **Mis Cursos** (`MisCursos.tsx`): Lista de inscripciones activas.
  - [x] **Visor de Curso**: Reproducción de contenido.

## 6. Prioridad Baja: Despliegue y Ajustes Finales

_Puesta en producción._

- [ ] **Despliegue**: Configuración de Vercel/Netlify.
- [x] **Prueba de Humo (Smoke Test)**: Verificar flujo completo de compra manual.
- [x] **Seguridad**: Rutas protegidas por Rol (Admin/Estudiante).
