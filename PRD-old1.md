# PRD-001: GymTrack — registro y seguimiento de entrenamientos de gimnasio

> **Documento vivo.** Primera versión (Módulo 1, AI-First Builders Lab 2026). Sigue el template del curso: Contexto/Problema (+personas), Objetivos, Requerimientos Funcionales (RF), Requerimientos No Funcionales (RNF), Criterios de Aceptación (AC en Dado/Cuando/Entonces), Fuera de Alcance y Riesgos/Dependencias. IDs para trazabilidad.
>
> *Nombre provisorio: **GymTrack** (cambialo si querés).*

## Contexto y Problema

Entreno 3-4 veces por semana, rotando grupos musculares y ejercicios. Para progresar de verdad necesito saber **qué levanté la última vez** en cada ejercicio (peso y repeticiones) y así subir de a poco con el tiempo. Hoy llevo todo en una **planilla de Excel**: es tedioso de cargar, incómodo en el celular al lado de la máquina, y buscar "cuánto hice la semana pasada en press banca" entre pestañas y filas es un dolor. Sin ese dato a mano, o estanco el peso o improviso.

No necesito una app cara y pesada llena de features de nutrición y red social: necesito **algo simple que reemplace al Excel** — cargar rápido la sesión de hoy y ver el historial de cada ejercicio para saber por dónde seguir. Como está pensada para que la usen personas que no conozco, cada uno tiene su **cuenta con sus propios datos, aislados**.

**Personas:**
- **Silvio (usuario que entrena, intermedio):** va al gym 3-4 veces/semana, trabaja distintos grupos musculares. Odia su Excel. Antes de cada serie quiere ver rápido cuánto hizo la última vez para subir el peso con criterio.
- **Lucía (principiante, usuaria externa):** empezó hace poco, no se acuerda qué peso usó la sesión anterior ni cómo venía progresando. Necesita algo guiado y simple que le muestre su último registro para no arrancar de cero cada vez.

## Objetivos

Que cargar la sesión de hoy sea **más rápido y cómodo que el Excel**, y que en cualquier momento pueda ver **el historial de cada ejercicio** (peso × reps a lo largo del tiempo) para decidir la progresión. Que cada persona use su cuenta con sus datos privados, sin ver ni afectar los de otros. Ganar: **dejar el Excel** y no perder nunca más el registro de "cuánto levanté la última vez".

## Requerimientos Funcionales

- RF-01: El sistema debe permitir que una persona se registre con email + contraseña.
- RF-02: El sistema debe permitir iniciar sesión con email + contraseña y mantener una sesión activa.
- RF-03: El sistema debe requerir autenticación para toda operación sobre datos de entrenamiento, y cada usuario solo debe poder acceder a sus propios datos.
- RF-04: El sistema debe ofrecer un catálogo base de ejercicios, cada uno asociado a un grupo muscular (pecho, espalda, piernas, hombros, brazos, core).
- RF-05: El usuario debe poder crear un ejercicio personalizado (nombre + grupo muscular) que se suma a su catálogo.
- RF-06: El usuario debe poder crear una sesión de entrenamiento con una fecha (por defecto, la del día).
- RF-07: Dentro de una sesión, el usuario debe poder agregar uno o más ejercicios tomados de su catálogo.
- RF-08: Para cada ejercicio de la sesión, el usuario debe poder registrar una o más series, cada una con peso (en kg) y repeticiones.
- RF-09: El usuario debe poder editar una sesión propia existente (agregar, quitar o modificar ejercicios y series).
- RF-10: El usuario debe poder eliminar una sesión propia.
- RF-11: El sistema debe mostrar el historial de sesiones del usuario ordenado por fecha (más reciente primero) y paginado.
- RF-12: El sistema debe permitir ver el detalle de una sesión (ejercicios, series, peso y reps).
- RF-13: Al agregar un ejercicio a una sesión, el sistema debe mostrar el último registro previo de ese ejercicio para ese usuario (peso × reps y fecha) como referencia; si no hay registro previo, debe indicarlo.

## Requerimientos No Funcionales

- RNF-01: Las pantallas de historial y detalle deben cargar en < 2 s (p95) con hasta 500 sesiones cargadas.
- RNF-02: El historial debe paginarse de a 20 sesiones por página.
- RNF-03: Las contraseñas deben almacenarse con hash seguro (bcrypt o argon2), nunca en texto plano.
- RNF-04: La sesión de usuario debe expirar tras 24 h de inactividad.
- RNF-05: Ninguna credencial o secreto (claves, strings de conexión) debe estar en el código; se leen de variables de entorno.
- RNF-06: La interfaz debe ser responsive y usable en pantalla de teléfono (ancho ≥ 360 px), porque se carga junto a la máquina en el gym.
- RNF-07: El peso admitido por serie debe estar en el rango 0–1000 kg y las repeticiones en 1–100; valores fuera de rango se rechazan.

## Criterios de Aceptación

- AC-01 (RF-01): Dado un email no registrado, cuando una persona se registra con email + contraseña válida, entonces se crea la cuenta y puede iniciar sesión.
- AC-02 (RF-01): Dado un email ya registrado, cuando se intenta registrar de nuevo con ese email, entonces HTTP 409 y no se crea otra cuenta.
- AC-03 (RF-03): Dado un usuario no autenticado, cuando intenta ver el historial, entonces HTTP 401 y no muestra datos.
- AC-04 (RF-03): Dado el usuario A dueño de una sesión y el usuario B autenticado, cuando B intenta ver o editar esa sesión, entonces HTTP 403 y no la muestra ni la modifica. *(control de acceso — OWASP #1)*
- AC-05 (RF-08, RNF-07): Dada una serie con peso = -5 kg o repeticiones = 0, cuando se intenta guardar, entonces HTTP 400 y no se guarda.
- AC-06 (RF-08): Dada una serie con peso = 80 kg y 8 repeticiones, cuando se guarda, entonces queda persistida y aparece en el detalle de esa sesión.
- AC-07 (RF-11): Dadas más de 20 sesiones, cuando se lista el historial, entonces se devuelven paginadas de a 20 (parámetros page/size) y ordenadas por fecha descendente.
- AC-08 (RF-13): Dado que registré "Press banca 60 kg × 8" la semana pasada, cuando agrego "Press banca" a la sesión de hoy, entonces se muestra "último: 60 kg × 8" con su fecha como referencia.
- AC-09 (RF-13): Dado un ejercicio que nunca registré, cuando lo agrego a una sesión, entonces se muestra "sin registro previo" y no se inventa un valor.
- AC-10 (RF-10): Dada una sesión propia, cuando la elimino, entonces desaparece del historial y su detalle devuelve HTTP 404.
- AC-11 (RF-05): Dado el ejercicio personalizado "Hip thrust" (grupo: piernas), cuando lo creo, entonces queda disponible en mi catálogo para futuras sesiones.

## Fuera de Alcance

- **App mobile nativa** (iOS/Android): la v1 es solo web responsive.
- **Integración con wearables/relojes** (Apple Watch, Garmin, pulseras, ritmo cardíaco).
- **Red social / compartir**: seguir amigos, feed, likes, publicar rutinas.
- **Nutrición / dieta**: conteo de calorías, macros, planes de comida.
- **Sugerencias de progresión con IA** (próximo peso, detección de estancamiento, generación de rutinas): se evaluará en una versión futura; la v1 es tracking manual. *(La autenticación con cuentas individuales aisladas SÍ entra: RF-01/02/03.)*
- **Gráficos/analítica avanzada** (curvas por ejercicio, volumen por grupo muscular): la v1 es historial de sesiones; los gráficos quedan para después.
- **Equipos, roles de administrador o compartir datos entre cuentas**: cada cuenta es individual y privada.
- **Rutinas planificadas/plantillas y recordatorios/notificaciones**.

## Riesgos y Dependencias

- Riesgo: *scope creep* hacia gráficos, IA o features sociales → mitigación: Fuera de Alcance explícito; la v1 se limita a tracking + historial + referencia del último registro.
- Riesgo: fuga de datos entre usuarios (ver o editar datos ajenos) → mitigación: autorización por dueño en cada endpoint (RF-03) y su prueba (AC-04).
- Riesgo: contraseñas mal almacenadas → mitigación: hash con bcrypt/argon2 (RNF-03) y secretos fuera del código (RNF-05).
- Riesgo: carga incómoda en el gym que haga abandonar la app → mitigación: UI responsive y flujo de carga rápido (RNF-06) + mostrar el último registro para no tener que buscarlo (RF-13).
- Dependencia: un framework web full-stack (front + API) y una base de datos relacional (por ejemplo SQLite en desarrollo / PostgreSQL en producción).
- Dependencia: un hosting que sirva la web y la API con variables de entorno para los secretos.
