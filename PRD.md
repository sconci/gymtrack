# PRD-001: RutinaGym — registro y seguimiento de entrenamientos de gimnasio

**Versión:** 3.0 (unifica PRD-A y PRD-B, resuelve el feedback del 30/09/2026) · **Fecha:** 4 de octubre de 2026 · **Autores:** Silvio y Marco

> **Documento vivo.** Sigue el template del curso (Módulo 1, AI-First Builders Lab 2026): Contexto/Problema (+personas), Objetivos, Requerimientos Funcionales (RF), Requerimientos No Funcionales (RNF), Criterios de Aceptación (AC en Dado/Cuando/Entonces), Fuera de Alcance y Riesgos/Dependencias. Cada elemento tiene un ID para poder rastrearlo.

### Respecto al feedback del 30/09/2026

- **Alcance recortado:** composición corporal y recuperación de contraseña por email pasan a Fuera de Alcance (V2), para ajustar el tamaño a los tiempos del curso.
- RF-07 ahora define los campos exactos que pide cada tipo de esfuerzo.
- La ejecución (RF-16) se crea al guardar la primera serie, no al entrar a ver el día: ya no quedan ejecuciones vacías en el historial.
- El trofeo (RF-21, RF-26, RF-27) se recalcula dinámicamente: si después se supera un récord, el trofeo se traslada a la nueva marca.
- "Último registro" (RF-17) se define por fecha de entrenamiento, no por orden de carga: una ejecución cargada tarde con fecha pasada no pisa un registro más reciente.
- Solo el creador de un ejercicio puede editarlo (RF-08), para que nadie le cambie el nombre/historial a los demás.
- RNF-08 corrige el mínimo de peso: debe ser mayor a 0 kg (antes permitía 0 kg con esfuerzo 0).
- Se agregan AC para la creación de la ejecución, el detalle con trofeos y la edición de una ejecución (AC-12, AC-13, AC-25, AC-26).

## Contexto y Problema

Quien entrena en serio necesita un control preciso de su progreso: series, repeticiones, pesos y tiempos por ejercicio. Las planillas de Excel y las notas en papel no funcionan en la práctica. Son tediosas de cargar e incómodas en el celular al lado de la máquina. Además, mientras se entrena no hay forma de recordar con exactitud cuánto se levantó, cuántas series se hicieron o cuántas repeticiones se completaron en la sesión anterior. Sin esa referencia, o se estanca el peso o se improvisa, y no hay manera de saber si realmente se está progresando.

Hace falta un sistema web que se pueda usar desde el celular en el gimnasio y que haga tres cosas:

- Mostrar automáticamente lo que se hizo la última vez en cada ejercicio.
- Permitir registrar rápido lo que se hace hoy.
- Calcular solo el progreso y avisar cuando se iguala o supera el propio récord.

Está pensado para personas que no conocemos, así que cada una tiene su **cuenta con sus propios datos, aislados** de los demás.

**Personas:**
- **Nino (usuario intermedio):** entrena con una rutina organizada por días. Probó Excel y papel, y ninguno le sirvió. Entre serie y serie quiere ver al instante cuánto hizo la última vez, cargar lo de hoy en pocos toques y saber si está mejorando.
- **Lucía (principiante, usuaria externa):** empezó hace poco, no se acuerda qué peso usó la sesión anterior ni cómo venía progresando. Necesita algo guiado y simple: una rutina armada, su último registro a la vista y un indicador claro de cuándo superó su marca.

## Objetivos

- Eliminar la dependencia de la memoria o de planillas durante el entrenamiento, mostrando siempre el último registro de cada ejercicio.
- Que registrar las repeticiones, el peso y/o los segundos de cada serie durante el entrenamiento sea **más rápido y cómodo que el Excel**.
- Calcular automáticamente una métrica de **esfuerzo** por serie (peso × repeticiones × segundos) para comparar el desempeño entre sesiones.
- Detectar y destacar automáticamente cuando se iguala o supera el récord histórico de esfuerzo en un ejercicio, como feedback motivacional inmediato.
- Soportar múltiples usuarios, cada uno con sus rutinas y entrenamientos completamente aislados.
- Ganar: **dejar el Excel** y no perder nunca más el registro de "cuánto levanté la última vez".

## Requerimientos Funcionales

**Autenticación y usuarios**
- RF-01: El sistema debe permitir que una persona se registre con email + contraseña. El email funciona como nombre de usuario (no existe un "usuario" aparte).
- RF-02: El sistema debe permitir iniciar sesión con email + contraseña y mantener una sesión activa.
- RF-03: El sistema debe permitir cerrar sesión.
- RF-04: El sistema debe exigir autenticación para toda operación. Cada usuario solo puede ver y modificar sus propias rutinas y ejecuciones. La única excepción es el catálogo de ejercicios, que es compartido (RF-05).

**Catálogo de ejercicios**
- RF-05: El sistema debe ofrecer un catálogo de ejercicios **compartido** entre todos los usuarios, que al lanzamiento viene **precargado** con un set base de ejercicios.
- RF-06: Cada ejercicio debe tener: nombre, imagen, categoría (tren superior / tren inferior), uno o varios músculos relacionados, instrucciones, tipo de esfuerzo y el usuario que lo creó. Los ejercicios precargados del catálogo base no tienen un usuario creador: por eso no pueden editarse ni eliminarse (ver RF-08).
- RF-07: El tipo de esfuerzo define qué datos se piden al registrar una serie:

  | Tipo de esfuerzo | Campos que pide la serie | Factores que valen 1 en la fórmula (RF-24) |
  |---|---|---|
  | Solo peso (barra, discos o mancuernas) | peso (kg), repeticiones | segundos |
  | Solo peso corporal (sin carga adicional) | repeticiones | peso, segundos |
  | Solo tiempo (en segundos, ej. plancha) | segundos | peso, repeticiones |
  | Peso + tiempo | peso (kg), segundos | repeticiones |
  | Peso corporal + tiempo | segundos | peso, repeticiones |

  *"Peso corporal + tiempo" pide los mismos campos que "Solo tiempo" (solo segundos); la diferencia es conceptual, para catalogar correctamente el ejercicio, no cambia el formulario de carga.*
- RF-08: Cualquier usuario autenticado puede crear ejercicios nuevos en el catálogo. Solo el usuario que creó un ejercicio puede editarlo. Un ejercicio solo puede eliminarse si no tiene ejecuciones asociadas, y solo puede eliminarlo su creador.
- RF-09: El tipo de esfuerzo de un ejercicio no se puede cambiar si ya tiene ejecuciones asociadas, ni siquiera por su creador.

**Rutinas, días y series de ejercicio**
- RF-10: El usuario debe poder crear, editar y eliminar rutinas propias, cada una con nombre, objetivo y un indicador de "actual".
- RF-11: Solo una rutina por usuario puede estar marcada como actual. Al marcar otra, la anterior se desmarca automáticamente.
- RF-12: Dentro de una rutina, el usuario debe poder crear, editar, reordenar y eliminar días. Cada día tiene nombre (por ejemplo, "Pecho y tríceps" o "Día 1") y un orden.
- RF-13: Dentro de un día, el usuario debe poder crear, editar, reordenar y eliminar series de ejercicio. Cada una define: ejercicio del catálogo, cantidad de series planificadas, repeticiones planificadas por serie y orden dentro del día.

**Registro de ejecución durante el entrenamiento**
- RF-14: Al iniciar sesión, si el usuario tiene una rutina actual, el sistema debe llevarlo directo a ella. Si no tiene, lo lleva a su listado de rutinas.
- RF-15: Dentro de su rutina actual (o cualquier otra rutina propia), el usuario debe poder elegir cualquier día para entrenar, no necesariamente en el orden definido.
- RF-16: La ejecución de ese día (con fecha, por defecto la de hoy) se crea en el momento en que se guarda la **primera serie**. Entrar a ver un día sin registrar ninguna serie no genera ejecución ni deja rastro en el historial.
- RF-17: Al entrar a una serie de ejercicio, el sistema debe mostrar automáticamente el último registro de ese mismo ejercicio para ese usuario, sin importar en qué rutina o día se hizo. "Último" se define por la **fecha de entrenamiento más reciente**, no por el orden en que se cargó. Para cada serie muestra repeticiones, peso y/o segundos (según el tipo de esfuerzo) y el esfuerzo calculado, junto con la fecha. Si no hay registro previo, debe indicar "sin registro previo".
- RF-18: El usuario debe poder registrar cada serie individual ejecutada hoy (serie 1, serie 2, serie 3…) con los datos que corresponden al tipo de esfuerzo (RF-07). Las series y repeticiones planificadas son una referencia: se pueden registrar más o menos series que las planificadas.
- RF-19: El usuario debe poder dejar una nota de texto libre en la ejecución de cada ejercicio del día (por ejemplo, "hoy me costó mucho" o "usé el banco inclinado a 30 grados").
- RF-20: El sistema debe mostrar el historial de ejecuciones del usuario, ordenado por fecha (más reciente primero) y paginado.
- RF-21: El sistema debe permitir ver el detalle de una ejecución: día, ejercicios, series con sus datos, esfuerzo y trofeo de cada serie (recalculado en el momento de la consulta, ver RF-27), y notas.
- RF-22: El usuario debe poder editar una ejecución propia (agregar, quitar o modificar series y notas). Al editar una serie, su esfuerzo se recalcula, y el récord histórico y los trofeos del ejercicio afectado se recalculan en consecuencia (pueden terminar mostrándose en una serie distinta a la que los tenía antes de la edición).
- RF-23: El usuario debe poder eliminar una ejecución propia. Al eliminarla, el récord histórico del ejercicio se recalcula sin las series de esa ejecución.

**Cálculo de esfuerzo y detección de récord**
- RF-24: Por cada serie ejecutada, el sistema debe calcular automáticamente el esfuerzo como **peso × repeticiones × segundos**. Si el tipo de esfuerzo no usa alguno de esos factores, ese factor vale **1** (ver tabla de RF-07).
- RF-25: El esfuerzo calculado debe mostrarse junto a cada serie registrada.
- RF-26: El récord histórico de un ejercicio es, en todo momento, el esfuerzo más alto que registró ese usuario en ese ejercicio, en cualquier rutina, día o ejecución. Se recalcula de forma continua: no es un valor fijado en el momento de guardar una serie.
- RF-27: Una serie muestra un **trofeo** visible si su esfuerzo iguala el récord histórico vigente del ejercicio (RF-26). La primera serie que un usuario registra de un ejercicio siempre tiene trofeo (es el único dato, por lo tanto el récord). Si más adelante se registra una serie con esfuerzo mayor, el trofeo se traslada: deja de mostrarse en la serie anterior y aparece en la nueva.

## Requerimientos No Funcionales

- RNF-01: La aplicación debe ser web, responsive y mobile-first, usable en pantallas de teléfono (ancho ≥ 360 px) y también en PC o notebook, sin instalar ninguna app nativa.
- RNF-02: Registrar una serie desde la pantalla del ejercicio no debe requerir más de 3 interacciones (por ejemplo: completar reps, completar peso, guardar), porque se hace entre series, con poco tiempo.
- RNF-03: Las pantallas de rutina actual, historial y detalle deben cargar en < 2 s (p95) con hasta 500 ejecuciones registradas.
- RNF-04: El historial de ejecuciones debe paginarse de a 20 registros por página.
- RNF-05: Las contraseñas deben almacenarse con hash seguro (bcrypt o argon2), nunca en texto plano.
- RNF-06: La sesión de usuario debe expirar tras 24 h de inactividad.
- RNF-07: Ninguna credencial o secreto (claves, strings de conexión) debe estar en el código. Todos se leen de variables de entorno.
- RNF-08: Rangos admitidos, con rechazo de cualquier valor fuera de ellos:
  - Peso por serie (tipos "solo peso" y "peso + tiempo"): mayor a 0 y hasta 1000 kg (admite decimales, por ejemplo 0.5 kg).
  - Repeticiones: 1–100.
  - Segundos: 1–3600.
- RNF-09: El historial completo de ejecuciones debe conservarse de forma indefinida, porque es la base para calcular récords.
- RNF-10: La interfaz debe estar en español.
- RNF-11: El sistema debe almacenar y mostrar una imagen por ejercicio (JPG, PNG o WebP, hasta 5 MB).

## Criterios de Aceptación

- AC-01 (RF-01): Dado un email no registrado, cuando una persona se registra con ese email y una contraseña válida, entonces se crea la cuenta y puede iniciar sesión con esas credenciales.
- AC-02 (RF-01): Dado un email ya registrado, cuando se intenta registrar de nuevo con ese email, entonces HTTP 409 y no se crea otra cuenta.
- AC-03 (RF-04): Dado un usuario no autenticado, cuando intenta ver su rutina o su historial, entonces HTTP 401 y no se muestran datos.
- AC-04 (RF-04): Dado el usuario A dueño de una rutina y una ejecución, y el usuario B autenticado, cuando B intenta verlas o editarlas, entonces HTTP 403 y no se muestran ni se modifican. *(control de acceso — OWASP #1)*
- AC-05 (RF-05, RF-08): Dado que el usuario A crea el ejercicio "Hip thrust" (tren inferior, glúteos, tipo peso), cuando el usuario B abre el catálogo, entonces "Hip thrust" aparece disponible junto a los ejercicios precargados.
- AC-06 (RF-08): Dado un ejercicio creado por el usuario A, cuando el usuario B intenta editarlo (por ejemplo, cambiarle el nombre), entonces HTTP 403 y el ejercicio no cambia.
- AC-07 (RF-08): Dado un ejercicio con al menos una ejecución registrada, cuando su creador intenta eliminarlo, entonces HTTP 409 y el ejercicio no se elimina.
- AC-08 (RF-09): Dado un ejercicio con al menos una ejecución registrada, cuando su creador intenta cambiar su tipo de esfuerzo, entonces HTTP 409 y el tipo no cambia.
- AC-09 (RF-10, RF-11): Dadas dos rutinas propias con la rutina 1 marcada como actual, cuando marco la rutina 2 como actual, entonces la rutina 2 queda actual y la rutina 1 deja de serlo.
- AC-10 (RF-12, RF-13): Dada una rutina propia, cuando creo el día "Pecho y tríceps" (orden 1) y le agrego "Press banca, 4 series × 8 reps", entonces el día y la serie de ejercicio quedan guardados y visibles en ese orden.
- AC-11 (RF-14): Dado un usuario con una rutina actual, cuando inicia sesión, entonces entra directo a esa rutina sin pasos adicionales.
- AC-12 (RF-16): Dado un usuario que elige un día para entrenar pero no registra ninguna serie, cuando sale de esa pantalla, entonces no queda ninguna ejecución creada en su historial.
- AC-13 (RF-16): Dado un usuario que elige un día para entrenar y guarda la primera serie, cuando se guarda, entonces se crea la ejecución con fecha de hoy y la serie queda asociada a ella.
- AC-14 (RF-17): Dado que la semana pasada registré "Press banca" con 3 series de 60 kg × 8, cuando entro a "Press banca" hoy (en cualquier rutina o día), entonces veo las 3 series (60 kg × 8, esfuerzo 480) con su fecha, sin buscarlas.
- AC-15 (RF-17): Dado un ejercicio que nunca registré, cuando entro a él, entonces se muestra "sin registro previo" y no se inventa ningún valor.
- AC-16 (RF-17): Dado que ayer registré "Press banca" y hoy cargo, con fecha de hace 3 días, una ejecución olvidada de ese mismo ejercicio, cuando entro a "Press banca", entonces el "último registro" mostrado sigue siendo el de ayer (por fecha de entrenamiento, no por orden de carga).
- AC-17 (RF-07, RF-18): Dado un ejercicio de tipo "solo tiempo", cuando se intenta guardar una serie sin segundos, entonces HTTP 400 y no se guarda.
- AC-18 (RF-18, RNF-08): Dada una serie de tipo "peso" con peso = -5 kg, peso = 0 kg, repeticiones = 0 o segundos = 0, cuando se intenta guardar, entonces HTTP 400 y no se guarda.
- AC-19 (RF-18): Dada una serie con peso = 80 kg y 8 repeticiones, cuando se guarda, entonces queda persistida y aparece en el detalle de esa ejecución.
- AC-20 (RF-19): Dada la ejecución de un ejercicio hoy, cuando dejo la nota "usé el banco inclinado a 30 grados", entonces la nota queda guardada y visible junto a ese registro en el detalle.
- AC-21 (RF-20, RNF-04): Dadas más de 20 ejecuciones, cuando se lista el historial, entonces se devuelven paginadas de a 20 (parámetros page/size) y ordenadas por fecha descendente.
- AC-22 (RF-24, RF-25): Dadas tres series registradas, cuando se guardan, entonces se muestra el esfuerzo que corresponde a cada una:
  - "Press banca" (tipo peso) con 80 kg × 8 reps → esfuerzo 640.
  - "Dominadas" (tipo peso corporal) con 10 reps → esfuerzo 10.
  - "Plancha" (tipo tiempo) con 45 s → esfuerzo 45.
- AC-23 (RF-26, RF-27): Dado que mi récord en "Press banca" es 640, cuando registro una serie con esfuerzo 680, entonces aparece un trofeo junto a esa serie nueva. Si registro una con esfuerzo 640 o menos, no aparece.
- AC-24 (RF-27): Dado un ejercicio que nunca registré, cuando guardo mi primera serie, entonces aparece un trofeo junto a esa serie.
- AC-25 (RF-21, RF-27): Dado que la serie X tenía trofeo por ser el récord de "Press banca", cuando registro después una serie con esfuerzo mayor, entonces al volver a ver el detalle de la ejecución de la serie X el trofeo ya no aparece ahí, y aparece en la nueva serie.
- AC-26 (RF-22): Dada una ejecución propia con una serie que tenía trofeo, cuando edito esa serie y le bajo el peso de forma que ya no sea el esfuerzo máximo, entonces el trofeo se recalcula: deja de mostrarse en esa serie y pasa a la serie que ahora tiene el esfuerzo más alto (si corresponde).
- AC-27 (RF-23): Dada una ejecución propia, cuando la elimino, entonces desaparece del historial, su detalle devuelve HTTP 404, y el récord del ejercicio se recalcula sin sus series.

## Fuera de Alcance

- **App mobile nativa** (iOS/Android): la v1 es solo web responsive.
- **Entrenamientos libres fuera de una rutina**: todo entrenamiento se registra como ejecución de un día de una rutina.
- **Recuperación de contraseña por email**: en v1 no hay reset por mail (ni el servicio de email que eso implica). Queda para una v2.
- **Peso y composición corporal** (peso diario, % de agua, masa muscular y grasa, con variación respecto al promedio de los últimos días): queda para una v2. Nota de diseño para esa iteración: cada métrica debe poder cargarse en forma independiente (no exigir las cuatro juntas), porque no todas las balanzas miden las cuatro.
- **Integración con balanzas inteligentes, wearables o relojes** (Apple Watch, Garmin, pulseras, ritmo cardíaco).
- **Funcionamiento offline** (sin conexión a internet).
- **Notificaciones push o recordatorios**.
- **Nutrición / dieta**: conteo de calorías, macros, planes de comida.
- **Red social / compartir**: compartir rutinas, seguir a otros usuarios, feed, rankings o comparación de progreso entre usuarios.
- **IA**: generación automática de rutinas, sugerencia del próximo peso, detección de estancamiento. *(La autenticación con cuentas individuales aisladas SÍ entra: RF-01 a RF-04.)*
- **Roles de administrador** para moderar el catálogo: todos los usuarios tienen el mismo nivel de permisos sobre el catálogo compartido (sujeto a las restricciones de dueño de RF-08).
- **Gráficos y analítica avanzada** (curvas por ejercicio, volumen por grupo muscular, reportes) más allá del esfuerzo y el trofeo por serie: quedan como mejora futura.
- **Exportación de datos** a otros formatos (Excel, PDF, etc.).

## Riesgos y Dependencias

- Riesgo: *scope creep* hacia gráficos, IA o features sociales → mitigación: Fuera de Alcance explícito. La v1 se limita a rutinas + ejecución + último registro + esfuerzo/récord.
- Riesgo: fuga de datos entre usuarios (ver o editar datos ajenos) → mitigación: autorización por dueño en cada endpoint (RF-04) y su prueba (AC-04).
- Riesgo: contraseñas mal almacenadas → mitigación: hash con bcrypt/argon2 (RNF-05) y secretos fuera del código (RNF-07).
- Riesgo: carga incómoda en el gimnasio que haga abandonar la app → mitigación: mobile-first (RNF-01), máximo 3 interacciones por serie (RNF-02) y último registro automático (RF-17).
- Riesgo: el catálogo compartido es editable por varios usuarios, y uno podría modificar el ejercicio de otro por error o a propósito → mitigación: solo el creador edita o elimina su ejercicio (RF-08), y no se puede borrar ni cambiar el tipo de esfuerzo de uno con historial (RF-08, RF-09). Riesgo residual: los ejercicios precargados no tienen dueño y quedan bloqueados para todos; corregirlos en v1 requiere acceso directo a la base de datos, sin rol de administrador.
- Riesgo: la fórmula de esfuerzo no es comparable entre ejercicios distintos (un esfuerzo de 45 en plancha no equivale a 45 en press) → mitigación: el récord y la comparación son siempre dentro del mismo ejercicio (RF-26).
- Riesgo: al editar o eliminar una ejecución que tenía el récord, el récord y los trofeos deben reflejarse correctamente en todas las vistas → mitigación: RF-26/RF-27 definen el trofeo como recalculado dinámicamente, nunca fijo, y RF-22/RF-23 lo cubren explícitamente para edición y borrado.
- Dependencia: un framework web full-stack (front + API) y una base de datos relacional (por ejemplo, SQLite en desarrollo y PostgreSQL en producción).
- Dependencia: un hosting que sirva la web y la API con variables de entorno para los secretos.
- Dependencia: almacenamiento de imágenes para el catálogo (RNF-11) — a tener en cuenta en los tiempos del curso, como marcó el feedback del 30/09.
- Dependencia: el contenido del catálogo precargado (ejercicios base con imagen, músculos, instrucciones y tipo de esfuerzo) tiene que prepararse antes del lanzamiento.
