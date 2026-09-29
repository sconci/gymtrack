# PRD-001: GymTrack — control de progreso de entrenamiento en el gimnasio

**Versión:** 2.0 (unifica PRD-A y PRD-B) · **Fecha:** 29 de septiembre de 2026 · **Autores:** Silvio y Marco

> **Documento vivo.** Sigue el template del curso (Módulo 1, AI-First Builders Lab 2026): Contexto/Problema (+personas), Objetivos, Requerimientos Funcionales (RF), Requerimientos No Funcionales (RNF), Criterios de Aceptación (AC en Dado/Cuando/Entonces), Fuera de Alcance y Riesgos/Dependencias. Cada elemento tiene un ID para poder rastrearlo.
>
> *Nombre provisorio: **RutunaGym***

## Contexto y Problema

Quien entrena en serio necesita un control preciso de su progreso: series, repeticiones, pesos y tiempos por ejercicio. Las planillas de Excel y las notas en papel no funcionan en la práctica. Son tediosas de cargar e incómodas en el celular al lado de la máquina. Además, mientras se entrena no hay forma de recordar con exactitud cuánto se levantó, cuántas series se hicieron o cuántas repeticiones se completaron en la sesión anterior. Sin esa referencia, o se estanca el peso o se improvisa, y no hay manera de saber si realmente se está progresando.

Hace falta un sistema web que se pueda usar desde el celular en el gimnasio y que haga cuatro cosas:

- Mostrar automáticamente lo que se hizo la última vez en cada ejercicio.
- Permitir registrar rápido lo que se hace hoy.
- Calcular solo el progreso y avisar cuando se supera el propio récord.
- Llevar el peso y la composición corporal día a día, con la variación calculada automáticamente.

Está pensado para personas que no conocemos, así que cada una tiene su **cuenta con sus propios datos, aislados** de los demás.

**Personas:**
- **Nino (usuario intermedio):** entrena con una rutina organizada por días. Probó Excel y papel, y ninguno le sirvió. Entre serie y serie quiere ver al instante cuánto hizo la última vez, cargar lo de hoy en pocos toques y saber si está mejorando. También se pesa a diario en una balanza que mide agua, masa muscular y grasa, y quiere ver cómo evolucionan esos valores.
- **Lucía (principiante, usuaria externa):** empezó hace poco, no se acuerda qué peso usó la sesión anterior ni cómo venía progresando. Necesita algo guiado y simple: una rutina armada, su último registro a la vista y un indicador claro de cuándo superó su marca.

## Objetivos

- Eliminar la dependencia de la memoria o de planillas durante el entrenamiento, mostrando siempre el último registro de cada ejercicio.
- Que registrar las repeticiones, el peso y/o los segundos de cada serie durante el entrenamiento sea **más rápido y cómodo que el Excel**.
- Calcular automáticamente una métrica de **esfuerzo** por serie (peso × repeticiones × segundos) para comparar el desempeño entre sesiones.
- Detectar y destacar automáticamente cuando se supera el récord histórico de esfuerzo en un ejercicio, como feedback motivacional inmediato.
- Centralizar el seguimiento del peso y la composición corporal (agua, masa muscular, grasa), mostrando la variación respecto al promedio reciente.
- Soportar múltiples usuarios, cada uno con sus rutinas, entrenamientos y registros de peso completamente aislados.
- Ganar: **dejar el Excel** y no perder nunca más el registro de "cuánto levanté la última vez".

## Requerimientos Funcionales

**Autenticación y usuarios**
- RF-01: El sistema debe permitir que una persona se registre con email + contraseña. El email funciona como nombre de usuario (no existe un "usuario" aparte).
- RF-02: El sistema debe permitir iniciar sesión con email + contraseña y mantener una sesión activa.
- RF-03: El sistema debe permitir cerrar sesión.
- RF-04: El sistema debe permitir recuperar y restablecer la contraseña mediante un enlace enviado al email registrado.
- RF-05: El sistema debe exigir autenticación para toda operación. Cada usuario solo puede ver y modificar sus propias rutinas, ejecuciones y registros de peso corporal. La única excepción es el catálogo de ejercicios, que es compartido (RF-06).

**Catálogo de ejercicios**
- RF-06: El sistema debe ofrecer un catálogo de ejercicios **compartido** entre todos los usuarios, que al lanzamiento viene **precargado** con un set base de ejercicios.
- RF-07: Cada ejercicio debe tener: nombre, imagen, categoría (tren superior / tren inferior), uno o varios músculos relacionados, instrucciones y tipo de esfuerzo.
- RF-08: El tipo de esfuerzo define qué datos se piden al registrar una serie. Puede ser: solo peso (barra, discos o mancuernas), solo peso corporal (sin carga adicional), solo tiempo (en segundos, por ejemplo una plancha) o una combinación (peso + tiempo, peso corporal + tiempo).
- RF-09: Cualquier usuario autenticado debe poder crear ejercicios nuevos en el catálogo y editar los existentes.
- RF-10: Un ejercicio solo se puede eliminar si no tiene registros de ejecución asociados. Su tipo de esfuerzo tampoco se puede cambiar si ya tiene registros.

**Rutinas, días y series de ejercicio**
- RF-11: El usuario debe poder crear, editar y eliminar rutinas propias, cada una con nombre, objetivo y un indicador de "actual".
- RF-12: Solo una rutina por usuario puede estar marcada como actual. Al marcar otra, la anterior se desmarca automáticamente.
- RF-13: Dentro de una rutina, el usuario debe poder crear, editar, reordenar y eliminar días. Cada día tiene nombre (por ejemplo, "Pecho y tríceps" o "Día 1") y un orden.
- RF-14: Dentro de un día, el usuario debe poder crear, editar, reordenar y eliminar series de ejercicio. Cada una define: ejercicio del catálogo, cantidad de series planificadas, repeticiones planificadas por serie y orden dentro del día.

**Registro de ejecución durante el entrenamiento**
- RF-15: Al iniciar sesión, si el usuario tiene una rutina actual, el sistema debe llevarlo directo a ella. Si no tiene, lo lleva a su listado de rutinas.
- RF-16: Dentro de la rutina, el usuario debe poder elegir cualquier día para entrenar (no necesariamente en orden). Al hacerlo se crea una ejecución de ese día con fecha, por defecto la de hoy.
- RF-17: Al entrar a una serie de ejercicio, el sistema debe mostrar automáticamente el último registro de ese mismo ejercicio para ese usuario, sin importar en qué rutina o día se hizo. Para cada serie muestra repeticiones, peso y segundos (según el tipo de esfuerzo) y el esfuerzo calculado, junto con la fecha. Si no hay registro previo, debe indicar "sin registro previo".
- RF-18: El usuario debe poder registrar cada serie individual ejecutada hoy (serie 1, serie 2, serie 3…) con los datos que corresponden al tipo de esfuerzo: repeticiones, peso y/o segundos. Las series y repeticiones planificadas son una referencia: se pueden registrar más o menos series que las planificadas.
- RF-19: El usuario debe poder dejar una nota de texto libre en la ejecución de cada ejercicio del día (por ejemplo, "hoy me costó mucho" o "usé el banco inclinado a 30 grados").
- RF-20: El sistema debe mostrar el historial de ejecuciones del usuario, ordenado por fecha (más reciente primero) y paginado.
- RF-21: El sistema debe permitir ver el detalle de una ejecución: día, ejercicios, series con sus datos, esfuerzo, trofeos y notas.
- RF-22: El usuario debe poder editar una ejecución propia (agregar, quitar o modificar series y notas).
- RF-23: El usuario debe poder eliminar una ejecución propia.

**Cálculo de esfuerzo y detección de récord**
- RF-24: Por cada serie ejecutada, el sistema debe calcular automáticamente el esfuerzo como **peso × repeticiones × segundos**. Si el tipo de esfuerzo no usa alguno de esos factores (por ejemplo, un ejercicio de peso corporal no tiene "peso" y uno de tiempo no tiene "repeticiones"), ese factor vale **1**.
- RF-25: El esfuerzo calculado debe mostrarse junto a cada serie registrada.
- RF-26: El récord histórico de un ejercicio es el esfuerzo más alto que registró ese usuario en ese ejercicio, en cualquier rutina o día. Incluye las series ya guardadas de la misma ejecución.
- RF-27: Si el esfuerzo de una serie supera estrictamente el récord histórico, el sistema debe mostrar un **trofeo** visible junto a esa serie. La primera vez que el usuario registra un ejercicio (sin récord previo), esa serie también recibe trofeo.

**Peso y composición corporal**
- RF-28: El usuario debe poder registrar, con fecha, un registro por día con: peso (kg), % de agua, % de masa muscular y % de grasa. Si ya existe un registro para esa fecha, se edita en lugar de crear otro.
- RF-29: Al guardar un registro, el sistema debe calcular la variación de cada una de las cuatro métricas respecto al promedio de los registros de los 7 días anteriores a esa fecha. El promedio usa solo los días que tienen datos cargados: si hubo 3 registros, se divide por 3 y no por 7.
- RF-30: Si no hay registros en los 7 días anteriores, el sistema debe mostrar "sin datos para comparar" en lugar de una variación.
- RF-31: El sistema debe mostrar el listado histórico de registros de peso corporal, ordenado por fecha descendente, con la variación de las cuatro métricas en cada registro (por ejemplo, "+1 kg respecto al promedio de los últimos 7 días").

## Requerimientos No Funcionales

- RNF-01: La aplicación debe ser web, responsive y mobile-first, usable en pantallas de teléfono (ancho ≥ 360 px) y también en PC o notebook, sin instalar ninguna app nativa.
- RNF-02: Registrar una serie desde la pantalla del ejercicio no debe requerir más de 3 interacciones (por ejemplo: completar reps, completar peso, guardar), porque se hace entre series, con poco tiempo.
- RNF-03: Las pantallas de rutina actual, historial y detalle deben cargar en < 2 s (p95) con hasta 500 ejecuciones registradas.
- RNF-04: El historial de ejecuciones y el de peso corporal deben paginarse de a 20 registros por página.
- RNF-05: Las contraseñas deben almacenarse con hash seguro (bcrypt o argon2), nunca en texto plano.
- RNF-06: La sesión de usuario debe expirar tras 24 h de inactividad.
- RNF-07: El enlace para restablecer la contraseña debe ser de un solo uso y vencer a la hora.
- RNF-08: Ninguna credencial o secreto (claves, strings de conexión, credenciales del servicio de email) debe estar en el código. Todos se leen de variables de entorno.
- RNF-09: Rangos admitidos, con rechazo de cualquier valor fuera de ellos:
  - Peso por serie: 0–1000 kg.
  - Repeticiones: 1–100.
  - Segundos: 1–3600.
  - Peso corporal: 20–400 kg.
  - % de agua, masa muscular y grasa: 0–100.
- RNF-10: El historial completo de ejecuciones y de peso corporal debe conservarse de forma indefinida, porque es la base para calcular récords y variaciones.
- RNF-11: La interfaz debe estar en español.
- RNF-12: El sistema debe almacenar y mostrar una imagen por ejercicio (JPG, PNG o WebP, hasta 5 MB).

## Criterios de Aceptación

- AC-01 (RF-01): Dado un email no registrado, cuando una persona se registra con ese email y una contraseña válida, entonces se crea la cuenta y puede iniciar sesión con esas credenciales.
- AC-02 (RF-01): Dado un email ya registrado, cuando se intenta registrar de nuevo con ese email, entonces HTTP 409 y no se crea otra cuenta.
- AC-03 (RF-04, RNF-07): Dado un usuario que pidió restablecer su contraseña, cuando usa el enlace recibido dentro de la hora, entonces puede definir una contraseña nueva. Si vuelve a usar el mismo enlace, se rechaza.
- AC-04 (RF-05): Dado un usuario no autenticado, cuando intenta ver su rutina, su historial o su peso corporal, entonces HTTP 401 y no se muestran datos.
- AC-05 (RF-05): Dado el usuario A dueño de una rutina, una ejecución y un registro de peso, y el usuario B autenticado, cuando B intenta verlos o editarlos, entonces HTTP 403 y no se muestran ni se modifican. *(control de acceso — OWASP #1)*
- AC-06 (RF-06, RF-09): Dado que el usuario A crea el ejercicio "Hip thrust" (tren inferior, glúteos, tipo peso), cuando el usuario B abre el catálogo, entonces "Hip thrust" aparece disponible junto a los ejercicios precargados.
- AC-07 (RF-10): Dado un ejercicio con al menos una ejecución registrada, cuando alguien intenta eliminarlo o cambiar su tipo de esfuerzo, entonces HTTP 409 y el ejercicio no cambia.
- AC-08 (RF-11, RF-12): Dadas dos rutinas propias con la rutina 1 marcada como actual, cuando marco la rutina 2 como actual, entonces la rutina 2 queda actual y la rutina 1 deja de serlo.
- AC-09 (RF-15): Dado un usuario con una rutina actual, cuando inicia sesión, entonces entra directo a esa rutina sin pasos adicionales.
- AC-10 (RF-13, RF-14): Dada una rutina propia, cuando creo el día "Pecho y tríceps" (orden 1) y le agrego "Press banca, 4 series × 8 reps", entonces el día y la serie de ejercicio quedan guardados y visibles en ese orden.
- AC-11 (RF-17): Dado que la semana pasada registré "Press banca" con 3 series de 60 kg × 8, cuando entro a "Press banca" hoy (en cualquier rutina o día), entonces veo las 3 series (60 kg × 8, esfuerzo 480) con su fecha, sin buscarlas.
- AC-12 (RF-17): Dado un ejercicio que nunca registré, cuando entro a él, entonces se muestra "sin registro previo" y no se inventa ningún valor.
- AC-13 (RF-24, RF-25): Dadas tres series registradas, cuando se guardan, entonces se muestra el esfuerzo que corresponde a cada una:
  - "Press banca" (tipo peso) con 80 kg × 8 reps → esfuerzo 640.
  - "Dominadas" (tipo peso corporal) con 10 reps → esfuerzo 10.
  - "Plancha" (tipo tiempo) con 45 s → esfuerzo 45.
- AC-14 (RF-26, RF-27): Dado que mi récord en "Press banca" es 640, cuando registro una serie con esfuerzo 680, entonces aparece un trofeo junto a esa serie. Si registro una con esfuerzo 640 o menos, no aparece.
- AC-15 (RF-27): Dado un ejercicio que nunca registré, cuando guardo mi primera serie, entonces aparece un trofeo junto a esa serie.
- AC-16 (RF-19): Dada la ejecución de un ejercicio hoy, cuando dejo la nota "usé el banco inclinado a 30 grados", entonces la nota queda guardada y visible junto a ese registro en el detalle.
- AC-17 (RF-18, RNF-09): Dada una serie con peso = -5 kg, repeticiones = 0 o segundos = 0, cuando se intenta guardar, entonces HTTP 400 y no se guarda.
- AC-18 (RF-20, RNF-04): Dadas más de 20 ejecuciones, cuando se lista el historial, entonces se devuelven paginadas de a 20 (parámetros page/size) y ordenadas por fecha descendente.
- AC-19 (RF-23): Dada una ejecución propia, cuando la elimino, entonces desaparece del historial y su detalle devuelve HTTP 404.
- AC-20 (RF-28, RF-29): Dados solo dos registros de peso en los 7 días anteriores (80 kg y 81 kg), cuando registro 82 kg hoy, entonces la variación de peso mostrada es "+1,5 kg" (promedio sobre 2 días, no sobre 7). Lo mismo aplica a agua, masa muscular y grasa.
- AC-21 (RF-30): Dado que no tengo registros de peso en los 7 días anteriores, cuando registro mi peso hoy, entonces se muestra "sin datos para comparar" en las cuatro métricas.
- AC-22 (RF-28): Dado que ya registré mi peso hoy, cuando vuelvo a cargar otro valor para hoy, entonces se actualiza el registro existente y no se crea un segundo registro para el mismo día.
- AC-23 (RNF-01, RNF-02): Dado un celular con pantalla de 360 px, cuando registro una serie desde la pantalla del ejercicio, entonces todo se ve sin scroll horizontal y la carga se completa en 3 interacciones o menos.

## Fuera de Alcance

- **App mobile nativa** (iOS/Android): la v1 es solo web responsive.
- **Entrenamientos libres fuera de una rutina**: todo entrenamiento se registra como ejecución de un día de una rutina.
- **Integración con balanzas inteligentes, wearables o relojes** (Apple Watch, Garmin, pulseras, ritmo cardíaco): la carga de peso y composición corporal es manual.
- **Funcionamiento offline** (sin conexión a internet).
- **Notificaciones push o recordatorios** (por ejemplo, para registrar el peso diario).
- **Nutrición / dieta**: conteo de calorías, macros, planes de comida.
- **Red social / compartir**: compartir rutinas, seguir a otros usuarios, feed, rankings o comparación de progreso entre usuarios.
- **IA**: generación automática de rutinas, sugerencia del próximo peso, detección de estancamiento. *(La autenticación con cuentas individuales aisladas SÍ entra: RF-01 a RF-05.)*
- **Roles de administrador** para moderar el catálogo: todos los usuarios tienen el mismo nivel de permisos sobre el catálogo compartido.
- **Gráficos y analítica avanzada** (curvas por ejercicio, volumen por grupo muscular, reportes) más allá de la variación de peso corporal y el trofeo por serie: quedan como mejora futura.
- **Exportación de datos** a otros formatos (Excel, PDF, etc.).

## Riesgos y Dependencias

- Riesgo: *scope creep* hacia gráficos, IA o features sociales → mitigación: Fuera de Alcance explícito. La v1 se limita a rutinas + registro + último registro + esfuerzo/récord + peso corporal.
- Riesgo: fuga de datos entre usuarios (ver o editar datos ajenos) → mitigación: autorización por dueño en cada endpoint (RF-05) y su prueba (AC-05).
- Riesgo: contraseñas mal almacenadas o enlaces de recuperación reutilizables → mitigación: hash con bcrypt/argon2 (RNF-05), enlaces de un solo uso con vencimiento (RNF-07) y secretos fuera del código (RNF-08).
- Riesgo: carga incómoda en el gimnasio que haga abandonar la app → mitigación: mobile-first (RNF-01), máximo 3 interacciones por serie (RNF-02) y último registro automático (RF-17).
- Riesgo: el catálogo compartido es editable por todos, así que un usuario podría modificarlo por error o a propósito → mitigación: no se pueden borrar ejercicios con historial ni cambiarles el tipo de esfuerzo (RF-10). El riesgo residual se acepta para la v1, sin roles de administrador.
- Riesgo: la fórmula de esfuerzo no es comparable entre ejercicios distintos (un esfuerzo de 45 en plancha no equivale a 45 en press) → mitigación: el récord y la comparación son siempre dentro del mismo ejercicio (RF-26).
- Riesgo: al eliminar o editar una ejecución que tenía el récord, el récord cambia → mitigación: el récord se recalcula siempre sobre los datos existentes.
- Dependencia: un framework web full-stack (front + API) y una base de datos relacional (por ejemplo, SQLite en desarrollo y PostgreSQL en producción).
- Dependencia: un hosting que sirva la web y la API con variables de entorno para los secretos.
- Dependencia: un servicio de email transaccional para la recuperación de contraseña (RF-04).
- Dependencia: almacenamiento de imágenes para el catálogo (RNF-12).
- Dependencia: el contenido del catálogo precargado (ejercicios base con imagen, músculos, instrucciones y tipo de esfuerzo) tiene que prepararse antes del lanzamiento.
