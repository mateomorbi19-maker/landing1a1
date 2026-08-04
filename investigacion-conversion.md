# Investigación: landings de referencia y auditoría de teotec.org — versión final

> **Alcance y honestidad de fuentes.** Consolida 7 líneas de investigación con verificación cruzada. Marco explícitamente lo **refutado** (no se usa), lo **no verificable** (se usa con aclaración) y lo que es **heurística** propia. Todos los datos sobre el código los revalidé sobre `C:\Users\COMPU MARDEL\Desktop\Proyectos\landing 1 a 1\index.html` (57.042 bytes, 987 líneas), `Dockerfile` y `logo.png` (324.196 bytes) antes de escribir esto.
>
> **Convención `[CONFIRMAR]`:** todo copy propuesto que contenga un número que yo no pude verificar va marcado así. **Ninguna línea con `[CONFIRMAR]` sale a producción con mi número puesto.** Un dato inventado en una página que vende sinceridad es peor que el hueco.

---

## 1. Resumen ejecutivo

- **Antes de tocar el HTML faltan tres números y sin ellos todo lo demás es hipótesis.** Visitas/mes, agendas/mes y llamadas efectivamente realizadas/mes. No hay tracking (verificado por grep: cero coincidencias de gtag/analytics/fbq/plausible/umami/posthog/hotjar/clarity/matomo/sendBeacon/dataLayer), así que hoy nadie sabe si el cuello de botella es la landing o el tráfico. Si entran 40 personas por mes desde el link de la bio, ningún cambio de copy mueve la aguja y el trabajo está en Instagram, no acá. Detalle en §8.

- **Cuatro bugs cuestan reuniones y no cuestan copy.** (a) Los 3 CTAs tienen `href="#"` literal y el destino se lo pone JS en la línea 704: si el IIFE revienta, los botones no hacen nada **y** 34 bloques con `.reveal{opacity:0}` (línea 302) quedan invisibles. (b) El `<h1>` (443) vive dentro de `.reveal` con `opacity:0` y espera al script del final del `<body>`: en **toda carga normal** el elemento más importante aparece con casi un segundo de fade — eso es el LCP. (c) El iframe de Calendly usa `load` como señal de éxito (722), que también disparan la página de error y el frame bloqueado. (d) En mobile el CTA del nav está oculto (`@media(max-width:560px){.nav .btn-nav{display:none}}`, línea 73): quedan dos puntos de conversión separados por cuatro secciones.

- **La brecha #1 es identidad y se cierra hoy, en veinte minutos.** La página usa la primera persona 7 veces sin decir jamás quién habla. "Mateo" aparece **una sola vez en todo el archivo**: dentro de la URL de Calendly en la línea 689, que el visitante nunca ve. El único ser humano con nombre propio en la landing es **"Sofi", la administrativa ficticia del script demo de Facebook** (línea 859). Y el contenido de la bio tiene que ser verificable —qué construiste, para qué negocio, con qué stack, hace cuánto, con algo que se pueda mirar hoy—; una bio de adjetivos no cierra la brecha, la decora.

- **El H1 vende la actividad y sesga hacia una sola audiencia.** "Aprendé a construir…": el verbo principal es esfuerzo, no beneficio, y al dueño de local "aprender" le suena a trabajo. El `<title>` (línea 6) ya dice **"Construí tu agente de IA"** — la versión que vende ya está escrita y está en el tab del navegador. **Lo que no hay que hacer es cambiarla por una promesa de resultado con plazo**: en una mentoría donde el alumno construye, el resultado depende del alumno, y prometerlo es exactamente el tono prohibido con vocabulario sobrio.

- **La página nunca dice 30 minutos, ni "sin costo", ni con quién.** Verificado por grep: "gratis", "sin costo", "30 min" e "inversión" tienen **cero ocurrencias** en las 987 líneas. Toda esa información vive detrás del click, o sea que sólo la ve el que ya se decidió. Es el arreglo más barato de la lista.

- **El embudo no termina en "agendó".** Call gratuita de 30 minutos, tráfico frío de Instagram, 3 a 7 días de espera: el no-show es el agujero grande y no está cubierto por ninguna decisión de copy. Recordatorios nativos de Calendly + un mensaje humano por WhatsApp el día antes cuestan una tarde en n8n. Detalle en §8.

- **Hay tres objeciones que deciden la compra y la página no responde ninguna:** qué pasa el día 91 cuando "no me necesitás a mí ni a nadie" (quedo con un sistema en producción que si se rompe un sábado no sé arreglar), cómo se paga en Argentina (pesos o dólares, transferencia o tarjeta, cuotas, factura), y —para la audiencia (b)— a quién le vendo y qué cobro. Detalle en §9.

- **La prueba social no es la palanca que parece.** El folklore del "+34% por testimonios" viene de empresas que venden widgets de prueba social. El número más creíble que encontré es una mediana de **+2,3% en un meta-análisis de 6.700 experimentos online** (dato de calidad media: leído citado en un agregador, no en el estudio original — **no lo uso para justificar ninguna decisión**). El argumento se sostiene sin la cifra: no hace falta esperar testimonios para optimizar, y no hay ningún upside que justifique inventarlos.

- **De basdonax hay cuatro cosas que valen y una que envenena.** Copiar: el FAQ con objeciones en primera persona, la escasez con razón operativa, el cierre de dos puertas y la técnica del símbolo en vez de la cifra inventada. **No copiar nada de facundocorengia.com** — misma autoría, tono opuesto, testimonios titulados con la facturación mensual de cada alumno.

- **356 KB recuperables sin tocar una palabra.** `logo.png` son 324.196 bytes / 1241×326 px para renderizarse a 34px de alto; nginx sirve sin gzip (medido: 57.042 → 16.691 bytes con `gzip -9`); y el `<link>` de Google Fonts pide 10 pesos de los cuales **3 no se usan en ninguna regla CSS** (verificado). Y no hay una sola etiqueta Open Graph en una landing cuyo link viaja por WhatsApp y DM de Instagram.

---

## 2. Qué hace basdonax.com

**Qué se leyó y qué no.** Se descargó el HTML crudo de basdonax.com (HTTP 200, 421.664 bytes) y de su landing hermana facundocorengia.com (HTTP 200, 875.264 bytes). Ninguna es SPA: one-pagers server-side con el builder de GoHighLevel/LeadConnector sobre Nuxt. Todas las citas están verificadas verbatim contra el HTML. **No se leyó**: el contenido de los videos de YouTube, los destacados de Instagram, ni los campos del formulario de "recursos gratis" (`api.basdonax.com/widget/form/kKJTCQAbYvLaaPyprNoM`, que en reverificación devolvió 200 con HTML real de LeadConnector — se pudo haber leído y no se leyó; no sé qué campos pide).

### Arquitectura (13 bloques)

| # | Bloque | Qué hace |
|---|---|---|
| 00a | Barra sticky superior | Escasez + CTA en la misma línea: *"Trabajamos solo con 3 empresas por mes. Aplicá →"* |
| 00b | Header sticky | Logo 28px (única imagen del sitio) + 4 ítems, el último **es** el CTA |
| 01 | Hero | Eyebrow con prueba (*"En producción · +30 casos… en empresas de 8 países"*) → H1 en dos líneas → caja de escasez justificada → dos CTAs (duro + blando) → 3 bullets. **Cero prueba visual.** |
| 02 | Tira de números | 5 métricas, de las cuales 2 no son resultados sino atributos del formato (3 fases / 0 licencias renovables) |
| 03 | 01 / EL PROBLEMA | Los 3 caminos rotos (agencia / SaaS / empleado técnico) |
| 04 | 02 / LA TRANSFORMACIÓN | Tabla A→B, 6 vs 6 |
| 05 | 03 / CÓMO TRABAJAMOS | 3 fases con nombre y plazo. El método recién acá |
| 06 | 04 / QUÉ IMPLEMENTAMOS | 6 tarjetas de catálogo |
| 07 | 05 / EL PROGRAMA | Oferta con nombre propio + Para quién sí / NO + ficha técnica de 7 filas |
| 08 | 06 / RESULTADOS | 4 métricas + 4 casos con empresa, rubro y provincia |
| 09 | 07 / POR QUÉ BASDONAX | Tabla comparativa de 6 filas |
| 10 | 08 / GARANTÍA | Promesa acotada + el porqué |
| 11 | 09 / PREGUNTAS | 5 objeciones en primera persona, entre comillas |
| 12 | 10 / PRÓXIMO PASO | Doble puerta: decidido / todavía lo estoy viendo |
| 13 | Footer | Copyright + 4 links sociales |

**Regla de posición de la prueba, observada en las dos landings del autor:** en basdonax la prueba va en la posición 8 de 13; en facundocorengia sube a la 1, justo después del hero. Si la prueba es fuerte va arriba; si es débil, va después de construir el argumento. TEOTEC no tiene prueba, así que su equivalente (la demo) sólo aguanta el hero si es real.

### Hero, prueba y precio

- Hero de puro texto, cero imágenes. **Funciona porque tiene autoridad acumulada afuera de la página** (YouTube, Instagram, LinkedIn, podcast) que le trae tráfico tibio. TEOTEC recibe tráfico frío desde el link de la bio: un hero de puro texto lo dejaría indefenso. Por eso la demo del hero de TEOTEC no se saca.
- basdonax.com tiene **exactamente 2 etiquetas `<img>`**, ambas el mismo logo en base64. Cero fotos de personas, cero logos de clientes. facundocorengia.com tiene 27 imágenes: 19 miniaturas hotlinkeadas de `img.youtube.com` y 8 webp en base64.
- **Cero `<iframe>` y cero `<video>` en las dos páginas.** Los testimonios en video son `<img>` de la miniatura envueltos en un `<a>` a YouTube. Se ve como galería de video y no carga un solo reproductor. **Copiar esta técnica el día que haya video propio.**
- En basdonax.com no hay ninguna cifra de precio, ni rango, ni "desde", ni "inversión" — cero ocurrencias de la palabra "precio". (En facundocorengia sí aparece 3 veces, dos dentro de su propio FAQ. Lo que es cierto en ambas: el precio del programa no se publica.)
- Basdonax no justifica la ausencia: la **reemplaza por un filtro de encaje** y se cubre con dos cosas: (a) el alcance es variable ("3 a 6 meses según el alcance acordado"), así que no puede haber precio de lista; (b) la llamada es un filtro bidireccional. **A TEOTEC le sirve (b) y no le sirve (a)**, porque su oferta es fija: 3 meses, 12 sesiones, precio único. Ese hueco lo tapa el FAQ (§9).

### CTA y tono

10 links de conversión: 7 a `wa.me/5491127619724` y 3 al formulario. Cero Calendly. La calificación entera ocurre a mano dentro de WhatsApp. **La decisión de TEOTEC de usar Calendly es correcta y no hay que revertirla**: Basdonax puede permitirse WhatsApp porque tiene equipo detrás. Lo transferible no es el canal sino que el primer mensaje ya declara intención.

El dinero se menciona sólo como costo que el cliente **ya paga**, nunca como ingreso prometido. Cuando no tiene un número duro, pone un símbolo en vez de inventar la cifra (*"↑ Más ventas"*, *"Min. Tiempo de respuesta"*) y acota los rangos voluntariamente: *"40-70% menos tiempo operativo — En los procesos automatizados"*, más *"El ahorro depende del stack actual de cada empresa."*

La escasez viene con razón operativa: *"Tomamos solo 3 empresas por mes. Es trabajo directo con tu equipo, no plantillas. Por eso abrimos pocos lugares."* Verificado: **no hay countdown, ni contador de lugares, ni fecha límite** (las dos ocurrencias de "timer" son clases CSS muertas del builder). La escasez es puramente textual. **Se repite 5 veces: copiar el argumento una vez, no la repetición** — cinco veces ya es packaging.

### Qué copiar, exacto

1. **El FAQ.** Es el mejor activo del sitio y lo que más le falta a TEOTEC. Pregunta redactada como la diría el prospecto, entre comillas, respuesta directa. Bajada que le da procedencia: *"Las dudas reales que aparecen en cada llamada. Te las contestamos de frente."*
2. **La escasez con razón operativa.** TEOTEC ya la tiene a medias ("Trabajo con pocas personas a la vez", línea 630) pero sin la razón y como título de cierre.
3. **El cierre de dos puertas.** Los botones nombran el estado mental del visitante, no la acción: *"Quiero aplicar — escribime"* / *"Todavía lo estoy viendo — recursos gratis"*.
4. **La técnica del símbolo en vez de la cifra inventada**, y la acotación voluntaria que le baja el aire a la propia métrica.
5. **El posicionamiento por negación en ritmo ternario:** *"No es una agencia. No es una suscripción. No es un empleado."*

### Qué NO copiar

- **Toda la arquitectura de facundocorengia.com.** Testimonios titulados con facturación: *"Rodrigo Bustos · US$15.000/mes"*, *"Lautaro Puebla · US$4.500 en 45 días"*. Son dos landings del mismo autor con tonos opuestos; copiar la equivocada arruina el posicionamiento entero.
- Promesas de estilo de vida ("Libertad geográfica y financiera", "Ventas high ticket") y superlativos no verificables (*"la consultora de IA más grande de LATAM"*, dos veces).
- Pegarle a la competencia con vulgaridad: *"A las comunidades de Skool les chupa un huevo si te va bien."*
- El texto pre-cargado del WhatsApp (*"…antes de que cierren los cupos del mes"*): urgencia puesta en la boca del prospecto. No reintroducirla en el copy del modal.
- El emoji del reloj y la etiqueta "Cupos limitados". El argumento sí, el packaging no.
- **La densidad de CTAs.** 10 links de conversión tiene sentido cuando el CTA es un WhatsApp. Para una reunión de 30 minutos se lee como desesperación.
- **El peso.** basdonax 421 KB, facundocorengia 875 KB, sin un solo `loading="lazy"`. TEOTEC son 57 KB.
- El emoji como iconografía: TEOTEC ya tiene 5 símbolos SVG inline (`<use href="#i-wa">` etc.), más liviano y sin depender del render de cada SO.
- La garantía de resultado tal cual: en Basdonax el entregable depende del proveedor; en una mentoría donde el alumno construye, depende del alumno.

---

## 3. El panorama: qué hacen las landings comparables en español

Se leyeron 10 landings con WebFetch. **Dos no se pudieron leer y no sostienen ningún hallazgo** (fallos reproducidos de forma independiente): `aokitech.com.ar` (SPA que devuelve sólo el `<title>`) y `catalisis.ai/mentoria.html` (error de certificado).

| Landing | Promesa del hero | Prueba social | Precio visible | CTA |
|---|---|---|---|---|
| **nacaia.com/servicios/mentoria** (comp. más directo) | "Aprende n8n, Claude Code e IA. **Directamente del experto.**" (sin decir quién) | **Cero** | Sí: 110€/sesión, 440€ pack 5 | Checkout Stripe |
| **joinmentoria.com** | 4 rutas por rol/equipo | 3 co-founders con foto y bio + métricas agregadas | No | Google Calendar |
| **growitschool.com/agentes-con-ia** | Programa de agentes | 4 graduados, 4.9/5, mentor Iván Monells ("Profesor en ESADE") | Sí: 897€ | Checkout + urgencia por fecha |
| **ecommerce.institute** | Programa Agentes de IA | Cero | Sí: ARS 2.250.000 | "Añadir al carrito" |
| **aihispania.com** | "Agencia n8n — Automatizaciones con IA para Empresas" | Cero | No | Formulario + widget WA |
| **iagents.com.ar** | "Responden como lo haría tu mejor vendedor, 24/7" | Métricas agregadas | No | WhatsApp + formulario |
| **baigency.com/agentes-ia/instagram** | Evitar perder mensajes y leads | 3 testimonios con nombre + "+50 Proyectos" | No | Formulario + widget WA |
| **soyagentia.com/argentina** | "Asistentes virtuales que venden, asesoran y atienden 24/7" | Cero | No | "Prueba gratis" |
| **formulacreatuagencia.com/programa** | Challenge de 30 días | Sección "Casos reales" **vacía en el HTML** | Sí: US$47 | Checkout + WhatsApp guiado |
| **skool.lety.ai** | "de cero a $1.8 millones de usd recurrentes… en 12 meses" | **Prestada**: logos de Papa John's, Guess, KIA, Yamaha (clientes del CEO, no resultados de alumnos) | Sí: 19 y 199 USD | Checkout |

### Patrones

- **El corte de precio es limpio: las agencias lo ocultan, las formaciones lo muestran.** 4 de 4 agencias sin precio, 5 de 5 formaciones con precio. La única formación que no lo muestra es joinmentoria (B2B) y manda a calendario. **TEOTEC queda del lado agencia siendo formación.** Eso no invalida la decisión —joinmentoria demuestra que se sostiene— pero significa que el visitante llega al Calendly con una pregunta abierta que nadie más de su categoría le deja abierta. Por eso el FAQ tiene que tocar el tema aunque no publique el número (§9).
- **En mentorías 1 a 1 el mercado siempre pone nombre y cara** (joinmentoria, growitschool, skool.lety.ai). **La excepción es nacaia —que vende casi exactamente lo mismo: mentoría 1:1 de n8n, IA y Claude Code— y es también la que no tiene ninguna prueba social.** Resuelve el hero con "Directamente del experto" sin decir quién es el experto. Es la trampa donde TEOTEC está parado hoy: suena a autoridad y comunica cero.
- **5 de 10 landings tienen cero prueba social de cualquier tipo.** No tener testimonios no es una anomalía en esta categoría: es la mitad del mercado.
- **La garantía acotada es el sustituto estándar cuando no hay testimonios.** La mejor del set es la de nacaia —que tampoco tiene un testimonio—: *"Si al acabar la primera sesión no ves valor, te devuelvo el 100% del importe. Sin preguntas."* Acota el riesgo a la primera sesión, deja el criterio en el comprador y **no promete ningún resultado de negocio**. La peor es la de formulacreatuagencia: devolución condicionada a no haber conseguido cliente habiendo hecho todos los pasos.
- **El bloque de descalificación NO es "cero de diez".** formulacreatuagencia tiene, bajo *"¿Para quién es este Challenge?"*, una lista explícita: *"Buscas dinero rápido"*, *"No quieres aplicar"*, *"Solo quieres teoría"*. Sigue siendo minoritario y sigue siendo un activo diferencial de TEOTEC, **pero el argumento "nadie se descalifica" es falso y no se puede usar.**
- **La FAQ está en 5 de 10**, no es universal. Los conteos de preguntas del reporte original no se replican y las cifras de longitud en palabras son **no verificables**: no usar ninguna para justificar decisiones de extensión.
- **Todo el mercado hispano está anclado en n8n.** La única página del set que nombra Claude Code en el hero es nacaia, y lo pone tercero. **Claude Code como herramienta única es un diferenciador sin competencia y a la vez un riesgo de descubrimiento**: nadie lo busca en español todavía, así que no puede ser el gancho del hero.

### Dónde está el hueco

Nadie combina las cuatro cosas: **descalificación honesta + producto mostrado funcionando + identidad del mentor + manejo explícito del precio**. La única con demo interactiva es iagents (chatbot embebido); las otras 9 describen el agente con adjetivos intercambiables. Ese es el terreno libre y TEOTEC tiene tres de las cuatro piezas a medio construir.

---

## 4. Qué hacen las landings de alto ticket con "agendá una llamada"

Se leyeron 12 páginas (10 dominios). Cuatro no se pudieron leer y no sostienen ningún hallazgo: `aaaaccelerator.com` (403) y `marketingexamples.com/copywriting/proof` (500), ambos reproducidos. **Dos claims quedaron refutados y no se usan**: que `recurse.com/about` y `fractalbootcamp.com` estaban caídos (cargan bien). `saasacademy.com` hoy redirige 301 a `precision.co/saasacademy`, página de anuncio de adquisición: valor de referencia bajo.

1. **El artefacto ejecutable reemplaza al testimonio.** Retell AI pone *"Try Our Live Demo"* al lado de *"Contact Sales"*: la demo pide caso de uso, nombre y teléfono, y el visitante **recibe una llamada real del agente**. La demo entrega la prueba, la llamada entrega la venta; no compiten. Julian Shapiro lo formula sobre los GIFs de flujo real de HelloSign: el efecto es *"de-risking our time investment and removing the uncertainty"*.

2. **El filtro que descalifica de verdad tiene un número.** Acquisition.com: *"If you are under 250k/yr this is not a fit (yet.)"* y *"If you haven't made at least $5k from the free content, don't do it."* El `(yet.)` evita el desprecio: no te rechaza como persona, te ubica en el tiempo. El contraejemplo es anajmnez.com, cuyo "NO ES PARA TI SI" lista actitudes (*"Te da miedo salir de tu zona de confort"*): **eso no descalifica a nadie, nadie se autoexcluye por tener miedo.** Es venta disfrazada de honestidad. **Regla operativa para TEOTEC: cada línea de "Esto no es para vos si" tiene que ser verificable por el lector en 3 segundos, no una actitud.**

3. **Escasez anclada a un objeto verificable.** Fractal Accelerator (bootcamp de 12 semanas con llamada de admisión, el comp más cercano en formato) publica fechas de cohorte y cupo numérico justificado en el FAQ: *"15 engineers maximum"*, porque asegura acceso directo al instructor. Sin cuenta regresiva. (El sitio se contradice: la home dice 20 y el FAQ 15. Lo reporto porque hasta las buenas referencias tienen agujeros.)

4. **Transparencia radical del modelo como sustituto de prueba.** Recurse Center: *"There is no tuition or other fees. RC is free because we run an integrated recruiting agency…"*. Designjoy (USD 4.995/mes, una sola persona): *"Designjoy is run entirely by Brett"* y *"Designjoy doesn't hire extra designers or outsource work"*. **Ambos convierten la debilidad aparente en la razón para confiar.** Es prueba por coherencia, y es directamente traducible al "La llamada es conmigo" que TEOTEC ya usa, extendido a toda la mentoría.

5. **Agenda explícita de la llamada, con salida admitida.** Fractal: *"Estimate your job and salary prospects, get your questions answered, and see if Fractal is right for you."* El tercer ítem admite explícitamente que podés salir sin comprar.

6. **El FAQ es el basurero honesto de la página.** Fractal publica ahí *"$18,000 total"*, *"60 hours per week for 12 weeks"*, *"macOS is required"*, prerequisitos y quién no debería aplicar. **TEOTEC no tiene que publicar los 997, pero sí replicar el patrón para lo demás: horas por semana, requisitos, medios de pago, y cuándo exactamente se habla de precio.**

7. **Reframe del nombre de la llamada.** Ninguna la llama "llamada de venta": "llamada de admisión", "intro call", "Growth Session". TEOTEC ya usa "Sesión de Consultoría" en Calendly **y no lo dice en la landing**.

8. **Microcopy logístico pegado al botón.** GoPoint pone bajo el CTA tres elementos separados: "30 MIN", "GOOGLE MEET", "SIN COSTO". (La versión con separadores del reporte original es reconstrucción, no cita literal. La afirmación de que su calendario "revela cuántos huecos quedan" es **inferencia no comprobada**: la página es SPA y lo único legible es "Cargando horarios disponibles".)

9. **Reversión de riesgo que no requiere historial.** Designjoy: *"Try it for a week: Get 75% back, no questions asked"*. Fractal ofrece garantía de resultado con número ("100% placement rate"): **ese modelo no sirve para TEOTEC porque requiere datos que no tiene. El modelo Designjoy sí: es una promesa que se puede hacer el día uno.**

10. **Regla de posición.** La credibilidad (quién enseña) va **arriba**, debajo del hero. El bloque de filtrado va **abajo**, justo antes del CTA final, nunca antes de generar deseo. El FAQ es siempre la penúltima sección.

11. **Un solo CTA, repetido literal.** Fractal repite "Apply Now →", Precision "Book a Growth Session", Ana Jiménez "AGENDA UNA REUNIÓN DE ADMISIÓN CON ANA". Ninguna alterna el texto del CTA principal. **Confirma la decisión de TEOTEC de repetir "Agendar reunión".**

12. **Doble audiencia con bloques paralelos rotulados, después del hero.** Precision bifurca en "For Operators" / "For Coaching Businesses" con un solo hero y un solo CTA. **Valida exactamente lo que TEOTEC ya hace.**

---

## 5. Confianza sin prueba social

**El reencuadre que cambia la prioridad.** La evidencia disponible **no** respalda que agregar prueba social sea la palanca más grande. Los "+34%", "+270%", "+70% Matillion" que circulan vienen de ProveSrc, NotificationX y TrustRadius: empresas que venden widgets de prueba social o las reseñas que se insertan. Conflicto de interés directo, sin metodología publicada. La cifra más creíble que encontré (mediana +2,3% sobre 6.700 experimentos online) es **de segunda mano y no la uso como ancla de nada**. Los dos corolarios prácticos se sostienen sin ningún número: **(a)** no hace falta esperar a tener testimonios para optimizar la página; **(b)** no hay ninguna justificación para inventarlos — en una mentoría 1 a 1 la reputación es literalmente el producto.

### Nivel 0 — hoy, sólo editando `index.html`

1. **Poner el nombre (20 minutos, la brecha #1).** Find-and-replace de las tres apariciones de "conmigo": línea 447 (`La llamada es conmigo`), 633 (`La llamada es conmigo, personalmente`) y la línea nueva del CTA. Más el bloque de identidad de §6. **Condición de calidad: todo lo que diga tiene que ser verificable.** Qué agentes construiste, para qué negocio concreto, con qué stack, hace cuánto, y un link a algo que se pueda mirar hoy. Sin eso es decoración.

2. **Rotular la demo.** Hoy el header dice "Agente · WhatsApp" sin marca de negocio, así que se lee como el chat de soporte de TEOTEC. Declarar que es un ejemplo **sube** la confianza, porque muestra que no estás tratando de hacerla pasar por real. Copy exacto y líneas en §6.

3. **Transparencia del modelo (patrón Designjoy/Recurse).** Decir antes de que el visitante lo note: que sos una sola persona, que por eso son pocas personas a la vez, y **que todavía no hay testimonios publicados**. Que el visitante lo note solo lo convierte en señal de fraude; decirlo vos lo convierte en señal de honestidad.

4. **Microcopy de la llamada** (línea 447): *"30 minutos, por videollamada · Sin costo · Hablás con Mateo, no con un vendedor"*.

5. **Nombrar la razón de la escasez.** "Trabajo con pocas personas a la vez" (630) flota como afirmación. Anclada a su causa aritmética —12 sesiones semanales por alumno más WhatsApp diario— deja de ser escasez y pasa a ser matemática que el lector verifica solo. Una vez, no cinco.

### Nivel 1 — esta semana

6. **Foto y 4 líneas de bio**, dentro del bloque "Quién te va a acompañar" (copy en §6).
7. **FAQ de 7 preguntas** (§9).
8. **Garantía de encaje** — decisión de negocio, no de copy. No de resultado: *"Si después de la primera sesión ves que esto no es para vos, cortamos ahí y te devuelvo lo que pagaste."* Es el modelo nacaia/Designjoy. **Si no se puede sostener operativamente, mejor ninguna que una tibia**: una garantía con letra chica es peor que nada para una marca que vende sinceridad.
9. **Captura real de Claude Code** (§6, bloque "Así se construye"): instrucción en castellano arriba, resultado abajo. Prueba la mentoría en vez del servicio, mata la objeción "Claude Code es para programadores", y es lo único de la página que un competidor no puede copiar mirando un screenshot.

### Nivel 2 — cuando haya material (semanas, no días)

10. **Demo viva**: un número de WhatsApp público donde el visitante chatea **ahora** con un agente real. Es el patrón Retell. **Tres condiciones no negociables:** (a) tratarla visualmente como demo y no como segundo botón de conversión — no puede competir con el Calendly, que fue una decisión explícita (commit `e157a8f`); (b) hay que monitorearla, porque si falla en vivo la prueba juega en contra; (c) el propio agente puede empujar al Calendly.
11. **Grabación de 40-60 segundos**: el agente respondiendo en un WhatsApp real, o un fragmento de sesión con permiso del alumno. Sin testimonio, sólo el artefacto.
12. **Miniatura enlazada** (técnica basdonax) el día que haya video: peso visual sin reproductor ni tracking de terceros.

---

## 6. Auditoría de mensaje: qué texto va en qué línea

**Sobre reordenar la página.** El borrador proponía un orden nuevo de 13 secciones. **Lo bajo de prioridad**: es el cambio de mayor riesgo (rompe el hilo narrativo, no es reversible por partes) con el respaldo más débil (NN/g 2018, eyetracking con 120 participantes y 130.000+ fijaciones, mide **distribución de atención**, no conversión; los propios autores aclaran que el análisis ignora el largo máximo de página). El movimiento con costo/beneficio claro es otro y es chico: **dejar el orden como está y poner en el hero dos links de auto-selección**. Resuelve "¿esto es para mí?" arriba del fold sin mover un bloque. El reorden completo queda como fase 4 opcional (§10).

### Regla de saldo: por cada bloque que entra, uno que sale o se comprime

Entran 3 (identidad, qué pasa en la llamada, FAQ). Salen o se comprimen 3:

- **Se comprime "Cómo lo hacemos"** (544-588): las tarjetas 03 y 04 se fusionan en una sola, "03 — PUBLICACIÓN Y AJUSTE". Cuatro etapas de metodología es más de lo que el comprador necesita antes de una llamada de 30 minutos.
- **Se recorta "Qué te llevás"** (598-604): los bullets 2 y 3 (12 sesiones / WhatsApp diario) repiten literalmente los tres `facts` de la línea 494-496, separados por cuatro secciones. Se van de acá y el panel pasa a hablar sólo del día 91.
- **No se crean** los dos bloques que el borrador proponía y que no van: la sección "Tres caminos y por qué ninguno cierra" (TEOTEC compite contra una sola alternativa —"lo hago yo mirando YouTube"— y ya la responde en la línea 611 y en el statement de 622; el contraste entra como pregunta del FAQ) y el panel "Qué tenés que poner vos" (duplica dos preguntas del FAQ y agrega un tercer filtro consecutivo antes del CTA, que es justo el defecto que le señalo al CTA final actual).

### Sección por sección

**HERO — eyebrow (línea 442).** Actual: `Formación 1 a 1 · 3 meses · En vivo`. "Formación" es sinónimo de curso en el oído del lector, y dos secciones después la página se define como *"Una mentoría, no un curso"* (490): se etiqueta a sí misma como aquello que después niega ser. Además "Formación uno a uno" se repite en el subtítulo tres líneas abajo.
→ **`Mentoría 1 a 1 · 12 sesiones en vivo · 3 meses`**

**HERO — H1 (línea 443).** Actual: *"Aprendé a construir agentes de IA que atienden y venden por WhatsApp, Instagram y Facebook."* Problemas: el verbo principal es "Aprendé" (esfuerzo, no beneficio); el resultado le pasa al agente, no al lector; sesga hacia la audiencia (b); son ~110 caracteres que en mobile a `clamp(32px,4.6vw,52px)` ocupan 5-6 líneas; y el `<title>` ya tiene la versión buena.
→ **`Construí tu <span class="grad">agente de IA</span> para WhatsApp, Instagram y Facebook.`** (61 caracteres). Imperativa: el que construye es el lector, no hay promesa de entrega con plazo. **Lo que no va: cualquier variante del tipo "En tres meses vas a tener un agente atendiendo tus canales"** — es garantía de resultado sobre algo que produce el alumno, exactamente lo que §4.9 descarta.
→ **Alternativa de mínimo cambio si no querés tocar la estructura:** dejar el H1 actual y agregarle una palabra — *"…que atienden y venden **solos** por WhatsApp, Instagram y Facebook."* "Solos" inyecta el beneficio (sin vos encima) sin prometer nada.

**HERO — subtítulo (línea 444).** Actual repite el eyebrow, mete la bifurcación en la línea 3 después de un guion largo, y deja el dato más vendedor de la oferta ("12 sesiones") enterrado en la línea 601.
→ **`Doce sesiones uno a uno, en vivo, con Mateo. El agente lo construís vos sobre un caso real — tu negocio, o el de un cliente al que le querés vender el servicio.`**

**HERO — assurance (línea 447).** Actual: *"Elegís día y horario · La llamada es conmigo"* (puramente logístico y anónimo).
→ **`30 minutos, por videollamada · Sin costo · Hablás con Mateo, no con un vendedor`**

**HERO — links de auto-selección (nuevo, después de la línea 448).** Agregar `id="para-negocio"` al `<article>` de la línea 508 y `id="para-habilidad"` al de la 516, y debajo del assurance:
```html
<p class="hero-pick"><a href="#para-negocio">Tengo un negocio que vende por chat</a> · <a href="#para-habilidad">Quiero la habilidad para vender el servicio</a></p>
```
Como es un `index.html` estático se puede ir más lejos barato: un parámetro de URL (`?v=negocio` / `?v=habilidad`) que intercambie H1 y subtítulo, con un link distinto por pieza de Instagram. **Heurística, sin dato que la respalde** — pero cuesta 15 líneas de JS.

**HERO — la demo multicanal (452-482).** Ocupa ~45% del ancho del fold en desktop y una pantalla entera en mobile: es lo que más comunica de la página. Y **comunica lo contrario de la oferta**: "acá hay un bot ya construido", que es lo que la página niega en *"No es un curso grabado ni un servicio llave en mano"* (491) y en *"Querés que te lo hagan y no aprender nada"* (611). El bloque "Qué te llevás" llega a decir *"Tu agente funcionando en tu canal — no una demo"* (600) tres pantallas debajo de una demo. **No se saca** —es el único activo de prueba de la página— se resuelve en cuatro movimientos:

1. **Nombre de negocio ficticio verosímil en el header.** Hay que editar cuatro lugares, no uno: la línea 471 (valor inicial) y los campos `who:` de las líneas 835, 845 y 855, porque `setChannel()` los sobrescribe. → `"Tienda Norte · WhatsApp"`, `"Estudio Bellamar · Instagram"`, `"Vidrios del Sur · Facebook"`.
2. **Micro-label de capacidad por tab.** El comentario del propio JS (828-832) dice qué demuestra cada canal —vender, calificar y agendar, derivar— **y esa información, que es la que convierte, está en un comentario de código que ningún visitante lee.** El usuario percibe "el mismo bot en tres lugares" (redundante) en vez de "tres cosas distintas que voy a saber hacer" (acumulativo). Agregar `cap:` a cada objeto de `CHANNELS` (`"Vende y cobra"` / `"Califica y agenda"` / `"Deriva a una persona"`), un `<div class="chat-cap" id="chatCap">` debajo del `.chat-head` (línea 474) y una línea en `setChannel()` al lado de la 926.
3. **Caption debajo del `.chat`** (después de la línea 482):
   `Conversación de ejemplo — es lo que vas a saber construir. Contesta a las 3 de la mañana igual que a las 3 de la tarde, y exactamente lo que vos le dijiste que conteste.`
   (Sustituye a la "escena del después" que proponía el borrador: *"entran cuarenta mensajes… tres reservas hechas"* son cifras inventadas presentadas como resultado esperable. **Esa línea no va.**)
4. **Reescribir el script de Instagram (847-852).** Hoy replica el propio funnel de TEOTEC (califica al lead y ofrece una llamada de 15 min), así que se lee como "el que me va a atender cuando agende es un bot", justo cuando el CTA promete "La llamada es conmigo". Y es el más vago: *"cómo funciona el servicio?"* no ancla en ningún rubro.
   ```
   user: "Hola! Hacen depilación definitiva?"
   bot:  "¡Hola! Sí. ¿Es la primera vez o ya te hiciste sesiones en otro lado?"
   user: "Ya me hice 3 el año pasado"
   bot:  "Entonces vas por mantenimiento. Te reservo una valoración sin cargo: mañana 15:30 o jueves 11:00."
   ```
   Dos detalles menores: los bots de WA e IG abren los dos con "¡Hola!" (sacarlo del de WhatsApp, línea 839) y `tienda.com/campera-cuero` (839) se lee como placeholder → `nortestudio.com.ar/campera-cuero`.

El script de WhatsApp es el mejor de los tres (*"Sí, me queda una en M. Sale $89.900 y va en 3 cuotas sin interés"*: precio, stock y financiación en una línea) y el de Facebook demuestra la capacidad más tranquilizadora, que el agente sepa cuándo **no** responder. Los dos quedan.

**"QUÉ ES ESTO" (487-499).** *"Una mentoría, no un curso"* define por contraste con la categoría que el visitante ya tiene en la cabeza, en cuatro palabras. *"vos construís, yo te guío"* (491) es la línea con mejor relación densidad/claridad de toda la página. **No tocar.** Los tres `facts` (494-496) se quedan como resumen de entrega; lo que se recorta es su duplicado de la línea 601-602.

**"PARA QUIÉN ES" (502-525).** El mejor bloque en estructura. Dos arreglos:
- La tarjeta A (512) tiene la única frase que roza el dolor del dueño y lo hace bien: *"querés que la atención funcione sin vos encima de cada mensaje"*. Describe un estado sin acusar al lector. **Es el modelo de calibración para todo lo demás.**
- La tarjeta B (520) tiene la peor frase de la página: *"Querés incorporar una capacidad concreta y demandada, y ofrecerla como servicio a negocios que la necesitan."* "Concreta" es la palabra menos concreta del castellano; "demandada" afirma un mercado sin sustento; "incorporar una capacidad" es lenguaje de consultora.
  → **`Querés aprender a construir esto de punta a punta y ofrecerlo a negocios que hoy contestan cada mensaje a mano, sin depender de una plantilla ni de un programador.`**
  Y la línea 521 (`who-out`) suma la parte honesta que hoy falta (§9.1): → **`Salís sabiendo construir un agente de punta a punta, y con el primero hecho para mostrar. La parte comercial la ponés vos.`**

**"QUÉ VAS A SABER HACER" (528-541).** *"Al terminar, esto lo hacés solo"* (531) es el mejor título de la página: la única promesa de resultado que hay, formulada como capacidad adquirida en vez de plata prometida. **No tocar.** Tres arreglos en los bullets:
- Línea 536, *"Construirlo con Claude Code, sin ser programador"*: **el desactivador de la objeción #1 está como cola de un ítem de lista.** Un dueño de local que googlea "Claude Code" encuentra una herramienta de línea de comandos para desarrolladores y se autodescalifica antes de agendar. → **`Le hablás en castellano y él escribe el código. Vos decidís qué tiene que hacer el agente, no cómo se escribe.`**
- Línea 535, *"Diseñar el cerebro del agente… y no invente"*: el "no invente" ataca el miedo #1 de cualquiera que vio una IA alucinar delante de un cliente. → **`Escribirle las instrucciones y cargarle tu catálogo, tus precios y tus reglas — para que responda como respondés vos, y no invente.`**
- Línea 538, *"Medir, corregir y mejorar el agente vos mismo"* (¿medir qué?): → **`Ver qué preguntas no supo contestar, corregirlo y volver a publicarlo — vos, el mismo día, sin escribirle a nadie.`**

**"CÓMO LO HACEMOS" (544-588).**
- Etapa 01 (554): *"tu negocio o el de tu primer cliente"* **da por sentado que el de la audiencia (b) ya tiene un primer cliente.** La mayoría no lo tiene: está evaluando la mentoría justamente para poder salir a buscarlo. → **`Arrancamos por lo concreto: tu negocio, o —si todavía no tenés cliente— un caso real que definimos en la primera sesión y que te queda hecho para mostrar.`**
- Etapa 02 (561): *"Es la herramienta desde la que se apalanca toda la formación"* es jerga en pasiva refleja. → **`Es la herramienta con la que construimos todo. La vas a manejar vos, no yo.`**
- Etapas 03 y 04: se fusionan en `03 — PUBLICACIÓN Y AJUSTE`, con la línea 584 reescrita: *"corregimos lo que falla"* → **`Leemos conversaciones reales de tu agente, marcamos las respuestas que estuvieron mal y las arreglás vos mientras te miro.`**
- **El chip animado que tipea `claude construí el agente` (línea 963) está trabajando en contra del copy**: la fuente mono con cursor de terminal refuerza visualmente la objeción que "sin ser programador" intenta desactivar. Cambiar `CC_LINE` a una instrucción en castellano llano: **`"hacé que el agente reserve turnos y avise cuando no hay lugar"`**. Es un cambio de una string y probablemente la mejor relación impacto/esfuerzo de toda la página. **El upgrade de eso es reemplazar el chip por una captura real de pantalla de Claude Code** —instrucción en castellano arriba, respuesta abajo— bajo el título "Así se construye lo de arriba".

**"QUÉ TE LLEVÁS / ESTO NO ES PARA VOS SI" (591-617).** El bloque negativo es un activo real. *"Querés que te lo hagan y no aprender nada — para eso contratá una agencia"* (611) manda a un competidor sin ironía y compra credibilidad instantánea. **No tocar una coma.** Tres arreglos:
- Línea 612, *"Esperás que funcione sin poner horas de trabajo"*, **instala el miedo y no lo resuelve**: avisa que cuesta horas y no dice cuántas, así que el lector completa el hueco con su peor estimación. → **`No podés poner [CONFIRMAR: X] horas por semana además de la sesión.`** — este es el número que reemplaza al panel "Qué tenés que poner vos" que no se construye.
- El panel "Qué te llevás" pierde los bullets 2 y 3 (duplican los facts) y pasa a hablar del día 91:
  `Tu agente contestando en tu número, no una demo` / `Todo el sistema en tus cuentas y a tu nombre — no hay nada mío que se pueda apagar` / `Las instrucciones y el prompt de tu agente, en un archivo que es tuyo y podés editar` / `El criterio para construir el próximo sin mí`
- El cuarto bullet nuevo es el que le da respuesta al miedo del día 91 (§9.2).

**STATEMENT (línea 622).** *"Nadie te construye una caja negra que no podés tocar. Construís vos, con guía. Al terminar, no me necesitás a mí ni a nadie."* Es el mejor párrafo de la página y es tan bueno como el mejor de Basdonax. **No moverlo** (la posición antes del CTA es correcta). Pero es simultáneamente la mejor línea y la peor amenaza — ver §9.2.

**CTA FINAL (627-636).** Actual: h2 *"Trabajo con pocas personas a la vez."* + p *"Es uno a uno, tres meses, con acceso diario. Agendá una reunión y vemos si tiene sentido para tu caso."* **Es el tercer filtro consecutivo de la página** (después de "Esto no es para vos si" y de la escasez) sin una sola afirmación de valor: el último título antes del botón es un título de filtro y el lector llega al botón sin una razón para querer entrar.
→ h2: **`Doce sesiones, uno a uno, y salís sabiendo hacerlo.`**
→ p: **`Trabajo con pocas personas a la vez porque las doce sesiones las doy yo y contesto el WhatsApp todos los días. Agendá 30 minutos y vemos si tu caso encaja.`**
→ nota (633): **`30 minutos, sin costo. Te atiendo yo, el mismo que da las 12 sesiones.`**

**BLOQUE NUEVO — Quién te va a acompañar** (después de "Cómo lo hacemos"; rompe además la monotonía visual del tramo medio):
> QUIÉN TE VA A ACOMPAÑAR
> **Soy Mateo Morbiducci.**
> Construyo agentes de IA para negocios que venden por chat: `[CONFIRMAR: qué construiste, para qué negocio concreto, con qué stack, hace cuánto]`. `[Link a algo que se pueda mirar hoy]`.
> En los tres meses hablás conmigo. No hay equipo, no hay asistente, no hay comunidad donde te pierdas: las 12 sesiones las doy yo.
> Todavía no publico casos de alumnos. Cuando los tenga, van acá.

**BLOQUE NUEVO — Qué pasa en la llamada** (antes del CTA final). Es el bloque de mayor retorno por línea escrita de toda la lista: maneja el precio sin publicarlo, convierte la llamada en algo útil y baja el miedo al call de venta.
> 30 minutos por videollamada, sin costo y sin compromiso.
> Me contás tu caso: tu negocio, o el tipo de cliente al que le querés vender el servicio.
> **En los primeros diez minutos te digo cuánto sale y cómo se paga**, antes de que me cuentes nada más.
> Te digo si con esto se resuelve. Si no se resuelve, te lo digo ahí mismo y no te hago perder tres meses.
> No hay presentación grabada ni te va a atender un vendedor.

(La versión del borrador decía *"y recién ahí hablamos de la inversión"*. **No va**: "inversión" es eufemismo de vendedor y "recién ahí" suena a emboscada, o sea exactamente lo contrario de lo que el bloque busca.)

---

## 7. Auditoría técnica

Severidad: **CRÍTICO** = cuesta conversiones hoy · **ALTO** = costo medible · **MEDIO** = deuda · **BAJO** = higiene.

### CRÍTICO

**7.1 — Los tres CTAs quedan muertos si el JS no corre, y con ellos toda la página.** Verificado: líneas 432, 446, 632 y 672 tienen `href="#"` literal; el destino lo asigna la línea 704 (`a.href = CAL_URL`). El comentario de las líneas 686-688 afirma lo contrario (*"si el JS no corre o el iframe queda bloqueado, el botón sigue llevando al calendario"*) — **un comentario que garantiza algo que el código no cumple desactiva la sospecha del que revise después.**

El radio de explosión es total: hay 34 elementos con `class="reveal"` y `.reveal{opacity:0}` (302). El `<noscript>` de la línea 12 los desoculta, **pero `<noscript>` sólo aplica cuando el scripting está deshabilitado** — si el JS está habilitado y el IIFE tira una excepción, quedan invisibles para siempre: el h1, el subtítulo, el chat, los facts, las tarjetas, las skills, las etapas, los paneles y el statement. Página en blanco con botón muerto.

*Fix, en tres partes (importa el orden):*
1. Hardcodear `href="https://calendly.com/mateomorbi19/sesion-de-consultoria"` en las líneas 432, 446, 632 y 672, y **borrar la línea 704**.
2. Invertir el reveal: línea 302 → `.js .reveal{opacity:0;transform:translateY(28px);transition:…}` y línea 303 → `.js .reveal.in{…}`. **La clase `.js` NO va en un `<script>` del `<head>`** —si el IIFE revienta después, la clase ya está puesta y los 34 bloques siguen invisibles, o sea el mismo bug con otra ropa—: va **adentro del bloque de reveal**, en la línea inmediatamente anterior a instanciar el `IntersectionObserver` (línea 810). Si el JS explota antes de esa línea, nunca se ocultó nada. Con eso el `<noscript>` de la línea 12 sobra y se borra.
3. Cinturón, después del `io.observe`: a los 2500 ms, si `document.querySelectorAll('.reveal.in').length === 0` (o sea que el observer nunca disparó ni una vez), agregar `in` a todos. Acotado así no mata la animación de scroll de los bloques de abajo.

**7.2 — El `<h1>` arranca invisible en toda carga normal.** No es sólo un modo de falla: el `<h1>` (443) vive dentro de `.reveal` con `opacity:0`, `translateY(28px)` y transición de 0.8 s, y sólo se destapa cuando corre el IIFE del final del `<body>`. El elemento más importante de la página aparece con casi un segundo de fade después del script — eso es el LCP y es literalmente el primer segundo del scroll.

*Fix:* sacar la clase `reveal` de los cinco elementos que ya están en pantalla al cargar: líneas **442, 443, 444, 445 y 452**. Lo que ya está en el viewport no se anima al entrar.

**7.3 — El fallback del iframe de Calendly nunca se muestra en el caso para el que fue escrito.** `mountCal()` engancha `addEventListener("load", ready)` (722) y arma un timeout de 15 s (726). Pero `load` también lo disparan la página de error y el frame bloqueado: entonces `ready()` corre, esconde el spinner, cancela el timeout, y el usuario queda mirando una caja negra vacía sin spinner, sin error y sin link de escape.

*Fix:*
- Borrar el listener de `load` (722). `ready()` lo llama únicamente el handler de `postMessage` (796), donde ya está: Calendly emite `calendly.profile_page_viewed` apenas inicializa.
- Bajar el timeout de `15000` a `7000` (726). Quince segundos de spinner en mobile es abandono garantizado.
- Como sin el `load` el `fail()` depende sólo del timeout, **mover el link de escape al estado de carga**: agregar dentro de `#calLoading` (666-669) `<a class="cal-esc" data-cal-out href="…" target="_blank" rel="noopener">¿Tarda? Abrilo en otra pestaña →</a>`, visible desde el segundo cero en cuerpo chico.
- Sacar `payment` y `camera; microphone` del `allow` de la línea 721: un calendario no los necesita.

*Contexto sobre por qué falla:* calendly.com **no** está en las listas de bloqueo por defecto de uBlock ni Brave, así que el escenario "bloqueador" es menos probable de lo que suena. El escenario probable es otro: **el WebView in-app de Instagram en iOS particiona el storage de terceros (ITP)** y el embed de Calendly necesita storage para inicializar. O sea que falla exactamente en el canal por donde llega el tráfico.

**7.4 — Bypass del modal en el WebView de Instagram/Facebook.** Arreglar el fallback es reactivo: el usuario igual come el spinner antes de ver la salida. Proactivo, tres líneas dentro del listener de la línea 780, antes del `e.preventDefault()`:
```js
if (/(FBAN|FBAV|Instagram)/.test(navigator.userAgent)) return;  /* que el <a> abra Calendly directo */
```
Ese user agent es prácticamente todo el tráfico del link-in-bio, y Calendly cargado como página propia es first-party: el problema de storage desaparece.

**7.5 — En mobile hay un solo CTA hasta cuatro secciones más abajo.** Línea 73: `@media(max-width:560px){.nav .btn-nav{display:none}}`, sumado a que todas las grillas colapsan a una columna (306-319). El visitante que se convence leyendo "Qué vas a saber hacer" tiene que scrollear cuatro secciones enteras para encontrar dónde clickear.

*Fix:* un CTA de texto intermedio después de "Qué vas a saber hacer" (línea 541), con el mismo copy del botón principal. **No usar cajas grandes tipo `final-box` en el medio**: rompen el ritmo y se leen como publicidad. Sobre la barra sticky inferior en mobile: es la recomendación de CRO más copiada del mundo, tapa la demo en el fold y un botón pegado a la pantalla es packaging de infoproducto — **no la recomiendo hasta que el dato de §11 diga que la gente llega al final y no clickea**.

*Sobre el dato de mobile:* Unbounce Conversion Benchmark Report 2024 (57M+ conversiones, 41.000 landings, mediana no promedio, metodología publicada) reporta conversión menor en mobile que en desktop, **pero lo hace por industria y "mentoría 1-a-1 de IA" no es una de sus industrias**. La cifra existe; la atribución a esta categoría la puse yo y no la sostengo. El argumento cualitativo —"la única puerta está a cuatro secciones de distancia"— se sostiene solo.

### ALTO

**7.6 — Sin Open Graph, el link pegado en un WhatsApp no muestra nada.** Grep confirmado: cero `property="og:"`, cero `name="twitter:"`, cero `rel="canonical"`, cero `rel="icon"`, cero `theme-color`, cero `application/ld+json`. **Esto no es SEO, es distribución, y es irónico en una landing que vende agentes para WhatsApp**: el link va a viajar por WhatsApp, DM de Instagram y Facebook, y los tres scrapean Open Graph. Sin `og:image` aparece como URL pelada.

*Fix, al `<head>` después de la línea 7:*
```html
<link rel="canonical" href="https://teotec.org/">
<meta name="theme-color" content="#05070F">
<meta property="og:type" content="website">
<meta property="og:url" content="https://teotec.org/">
<meta property="og:locale" content="es_AR">
<meta property="og:title" content="Construí tu agente de IA para WhatsApp, Instagram y Facebook">
<meta property="og:description" content="Mentoría 1 a 1 de 3 meses. Doce sesiones en vivo con Mateo: el agente lo construís vos, sobre tu caso real.">
<meta property="og:image" content="https://teotec.org/og.png">
<meta name="twitter:card" content="summary_large_image">
<link rel="icon" href="/favicon.svg" type="image/svg+xml">
<link rel="apple-touch-icon" href="/apple-touch-icon.png">
```
`og.png` de 1200×630 y bastante menos de 300 KB (WhatsApp no renderiza imágenes pesadas). **URLs absolutas obligatorias** en `og:url` y `og:image`. Y agregar los `COPY` al `Dockerfile`, que hoy sólo copia `index.html` y `logo.png` — verificado. Hoy además cada primera carga dispara un 404 a `/favicon.ico`.

**7.7 — nginx sirve sin gzip.** Medido acá: `index.html` = 57.042 bytes, `gzip -9` = 16.691 bytes (ratio 3,42x). El `Dockerfile` es `FROM nginx:alpine` + dos `COPY`, sin `nginx.conf` propio, y la imagen oficial trae `gzip` comentado por defecto. Son **40.351 bytes de más en la ruta crítica**, y el HTML es render-blocking por definición.

*Antes de tocarlo, confirmar en producción* (Easypanel puede tener Traefik adelante comprimiendo):
```
curl -s -H "Accept-Encoding: gzip" -I https://teotec.org | grep -i content-encoding
```
*Si no aparece `gzip`,* agregar `nginx.conf`:
```nginx
gzip on;
gzip_comp_level 6;
gzip_min_length 256;
gzip_types text/plain text/css application/javascript image/svg+xml;
location ~* \.(png|webp|svg|woff2)$ { expires 1y; add_header Cache-Control "public, immutable"; }
location = /index.html { add_header Cache-Control "no-cache"; }
```
más `COPY nginx.conf /etc/nginx/conf.d/default.conf` en el `Dockerfile`.

**7.8 — `logo.png`: 324.196 bytes, 1241×326 px, renderizado a 34px de alto.** Verificado. A 34px el ancho renderizado es ~129px; incluso a DPR 3 alcanza con 388×102. Se sirve una imagen con ~10x el área de píxeles necesaria, en PNG de 32 bits: **es ~19 veces el HTML comprimido**. *Corrijo el brief original:* el logo **no** produce CLS medible — el CSS fija `height:34px` (69) y `.nav-in` es flex con `space-between`, así que crece hacia la derecha sin empujar nada. El problema es peso puro.

*Fix, por preferencia:* (1) si es wordmark vectorial → SVG inline (la página ya tiene 5 símbolos SVG inline, el patrón existe): 1-3 KB y cero requests; (2) si tiene que ser raster → 388×102 en WebP q85 = 4-8 KB, ahorro del 97%; (3) agregar `width`/`height` en las líneas 430 y 643 igual, por el preload scanner.

**7.9 — El `<link>` de fuentes pide 10 pesos y 3 no se usan.** Línea 10: Space Grotesk ×4, Inter ×4, JetBrains Mono ×2 — render-blocking, en un tercer origen. Verificado por grep sobre todas las reglas CSS: los únicos pesos declarados son 500 (×2), 600 (×12) y 700 (×4), más el 400 por defecto del `body`. Space Grotesk (`--f-display`) sólo se usa en 600 y 700; Inter (`--f-body`) en 400, 500 y 600; JetBrains Mono en 400 y 500.
*(Corrijo la hipótesis de que JetBrains Mono existe sólo para el chip de terminal: `--f-mono` se usa en 13 reglas — eyebrow, assur, chat-status, lnk, sec-eyebrow, who-tag, step-n, cc-txt, panel h3, final-note, footer small, cal-sub. La familia se queda.)*

*Fix, línea 10:*
```
family=Space+Grotesk:wght@600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500
```
De 10 archivos a 7. El upgrade real, cuando haya tiempo: self-hostear los woff2 en el contenedor y matar los dos `preconnect` a Google (líneas 8-9), con lo cual la ruta crítica deja de depender de un tercer origen.

**7.10 — La embed URL de Calendly no propaga UTMs.** `embedUrl()` (708-714) arma `embed_domain`, `embed_type`, `hide_gdpr_banner` y los tres colores, y no lee `location.search`. Cuando entra una reunión agendada, **no hay forma de saber si vino de la bio, de una story, de un DM o de un anuncio.**

*Fix, 5 líneas dentro de `embedUrl()`:*
```js
var qs = new URLSearchParams(location.search), keep = "";
["utm_source","utm_medium","utm_campaign","utm_content","utm_term"].forEach(function(k){
  if (qs.get(k)) keep += "&" + k + "=" + encodeURIComponent(qs.get(k));
});
```
y concatenar `keep` al return. Calendly los acepta nativamente, los guarda en el evento y aparecen en la notificación y en el webhook de n8n. **Esto vale más que el analytics**: son 5 líneas y contestan la única pregunta de atribución que importa.

**7.11 — Cero tracking, y lo que se puede pedirle es menos de lo que parece.** Grep sobre gtag, googletagmanager, analytics, fbq, plausible, umami, posthog, hotjar, clarity, matomo, sendBeacon, dataLayer, `fetch(`, XMLHttpRequest: **cero coincidencias**. Hoy es imposible distinguir si la gente no agenda porque no abre el modal, porque no elige horario o porque se cae en las preguntas de calificación.

*Fix:* Umami self-hosted en el mismo Easypanel donde ya corre n8n (~2 KB, sin cookies, sin banner de consentimiento, dato propio). **No GA4**: 45+ KB, cookies, banner e impacto en INP para responder tres preguntas. Eventos y líneas exactas en §11.

**Advertencia de expectativa, importante:** con una mentoría 1 a 1 que necesita 5-10 alumnos, el denominador de cualquier ratio del embudo es de un dígito por mes. **El analytics acá es un diagnóstico binario —¿alguien abre el modal?, ¿alguien llega al último bloque?— no un sistema de optimización, y no puede responder si las preguntas de calificación de Calendly ayudan o rompen.** Eso se responde llamando por teléfono a las personas que ya agendaron.

### MEDIO

**7.12 — El chat demo corre en loop infinito sin pausa.** `run()` se reprograma a sí misma en la línea 916 (`setTimeout(run, delay + 3400)`), ciclo de ~9 segundos, con `clearChat()` (876) borrando y reconstruyendo el DOM cada vuelta. El `IntersectionObserver` hace `chatIO.disconnect()` (956) apenas arranca, o sea que **no hay forma de pausarlo**: sigue corriendo con el usuario cuatro secciones más abajo y en pestaña de fondo.

Además es **fallo WCAG 2.2.2 (Pause, Stop, Hide), nivel A**: contenido que se actualiza automáticamente, arranca solo, dura más de 5 segundos, convive con otro contenido y no tiene mecanismo de pausa. Y como `clearChat()` elimina nodos, con lector de pantalla el contenido desaparece bajo el cursor cada 9 segundos.

*Crédito donde corresponde:* `prefers-reduced-motion` está bien manejado — la línea 902 hace early return antes de los `setTimeout`, así que bajo reduced-motion el chat se pinta estático.

*Fix:* no llamar a `disconnect()` en la 956; usar el observer para pausar cuando sale del viewport (`clearTimers()`) y reanudar al volver; agregar `document.addEventListener("visibilitychange", …)` con lo mismo; y agregar un botón de pausa accesible en el `.chat-tabs`.

### BAJO

**7.13 — Higiene.** La clase `.mono` (línea 50) está definida y **no se usa ni una vez** en el HTML (verificado): borrarla. El `aria-live="off"` del `#chatBody` (476) es correcto dado el loop, pero deja de ser suficiente si se agrega el botón de pausa. Y el `<html lang="es">` podría ser `es-AR` para que los lectores de pantalla usen la prosodia rioplatense.

---

## 8. El embudo completo: lo que pasa antes y después de la landing

**Esta sección va antes que cualquier edición de `index.html`.**

### 8.1 — Arriba: cuánto tráfico hay (30 minutos, sin código)

No hay una sola línea de dato sobre visitas/mes, fuente, ni cuántas reuniones entran hoy. **Sin eso, todo este informe optimiza una conversión sin haber establecido nunca que el cuello de botella sea la conversión.**

Tres números, hoy, de donde salgan (insights de Instagram, panel de Calendly, memoria):

| Número | Dónde está | Qué decide |
|---|---|---|
| Visitas/mes a teotec.org | Insights de IG: clicks al link de la bio | Si son < ~100/mes, ningún cambio de copy mueve nada y el trabajo está en Instagram, no acá |
| Reuniones agendadas/mes | Panel de Calendly | Es el numerador de todo lo demás |
| Llamadas efectivamente realizadas/mes | Calendario propio | La diferencia con la anterior es el no-show, que probablemente sea el agujero más grande |

**Heurística, no dato:** si agendan menos del 2% de las visitas, el problema está en la página (§6). Si agendan bien pero no aparecen, el problema está en 8.2 y editar copy es tiempo perdido.

### 8.2 — Abajo: el no-show (una tarde en n8n)

El evento que este informe optimiza (agendó) no es el que factura (se presentó). Call gratuita de 30 minutos, tráfico frío de Instagram, 3 a 7 días de espera entre que agenda y habla: es la combinación de mayor no-show que existe. Tres acciones concretas, ninguna toca `index.html`:

1. **Recordatorios nativos de Calendly a 24 h y 1 h.** Es una casilla en la configuración del event type, no hay que programar nada.
2. **Mensaje humano por WhatsApp el día antes.** Calendly ya pide el WhatsApp en las preguntas de calificación y ya hay n8n corriendo en el mismo Easypanel: webhook de Calendly → espera hasta 24 h antes → mensaje. **Escrito como lo escribiría Mateo, no como plantilla**, y terminando en una pregunta abierta ("¿seguís pudiendo mañana a las X?") para que la conversación exista antes de la llamada.
3. **"Qué traer a la llamada" en la pantalla de confirmación de Calendly y en el mail.** Una línea: *"Traé pensado qué preguntas te repiten más tus clientes por chat. Con eso arrancamos."* Le da tarea al prospecto, y el que hace la tarea se presenta.

Además, la línea 797 del `index.html` ya reescribe el subtítulo del modal cuando llega `calendly.event_scheduled` (*"Listo — te llega la confirmación por mail"*). Ese es el único lugar de la página que le habla al que ya agendó: aprovecharlo → **`Listo. Te llega la confirmación por mail y te escribo por WhatsApp el día antes.`**

### 8.3 — La landing como pieza del funnel de Instagram

El visitante llega desde una pieza concreta de contenido y la página no continúa ninguna conversación: arranca de cero como si el link viniera de Google. Dos movimientos baratos:
- **UTMs en todos los links** que se peguen en bio/stories/DM (`?utm_source=ig&utm_medium=bio`, `…&utm_medium=story&utm_content=<nombre-del-reel>`), que con el fix 7.10 llegan hasta el evento de Calendly.
- **Variante de hero por URL** (`?v=negocio` / `?v=habilidad`), un link distinto por tipo de contenido. Es la versión barata del reorden que §6 desaconseja.

---

## 9. Las tres objeciones que la página no responde

Ninguna de las tres está en el HTML hoy. Las tres deciden la compra.

### 9.1 — "Me enseñás a construirlo, ¿y a quién se lo vendo?" (audiencia b)

La página promete "ofrecerla como servicio a negocios" (520) y la mentoría enseña a **construir**, no a **vender**. A quién le vende, cómo consigue el primer cliente y qué cobra no aparecen ni una vez. **La respuesta honesta es también la que protege la marca**, y va en la línea 521 y en el FAQ:

> *"Te enseño a construirlo, no a venderlo. Salís con el sistema hecho y con una demo real para mostrar; la parte comercial la ponés vos."*

Si eso espanta a la mitad de esa audiencia, mejor ahora que en la sesión 8. Si Mateo **sí** quiere cubrir la parte comercial, entonces es una sesión del programa y tiene que estar en "Qué te llevás" — pero no puede quedar implícito.

### 9.2 — "El día 91 quedo solo con un sistema en producción"

*"Al terminar, no me necesitás a mí ni a nadie"* (622) es el mejor párrafo de la página **y la amenaza más grande para un dueño de negocio**: si se rompe un sábado y la atención de su local depende de eso, está solo. El borrador mandaba esta objeción a las "candidatas de reserva" del FAQ. Va entre las tres primeras, y tiene que decir tres cosas concretas: qué se lleva escrito, si hay alguna vía de consulta después, y qué pasa si Meta cambia la API en el mes 5. Se apoya en el bullet nuevo de "Qué te llevás" (*"Las instrucciones y el prompt de tu agente, en un archivo que es tuyo y podés editar"*).

### 9.3 — "¿Cómo se paga esto en Argentina?"

USD 997 a mercado argentino: pesos o dólares, transferencia o tarjeta, cuotas, factura. **Para este mercado esas preguntas bloquean más que el número.** "Se define en la llamada" no toca ninguna. La resolución no requiere publicar el precio: requiere publicar el **procedimiento** (FAQ #2 abajo y el bloque "Qué pasa en la llamada" de §6).

### El FAQ: 7 preguntas, con reglas

Cuatro de las siete líneas de investigación recomiendan FAQ; una (la de evidencia CRO) recomienda no agregarlo, porque no encontró ninguna fuente con metodología que respalde su impacto en conversión de páginas de servicio y porque Unbounce mide una extensión óptima de 275-745 palabras para esa categoría. **Resolución: el FAQ va.** El argumento de la extensión aplica a landings de PPC de servicios genéricos, no a una oferta de alto ticket sin precio publicado cuyo evento de conversión es una reunión — que es justo el caso donde todas las referencias de alto ticket (Fractal, Acquisition.com, basdonax) usan el FAQ como el lugar de lo incómodo. Reglas estrictas:

- **Máximo 7 preguntas. Cada respuesta ≤ 40 palabras.**
- **Cada pregunta tiene que aportar información que hoy no está en ningún otro lado de la página.** Si repite algo del cuerpo, no va.
- Redactadas como las diría el visitante, en primera persona.
- `<details>/<summary>` nativo, sin JS (coherente con el fix 7.1: nada crítico dependiendo del script).

1. **"¿Necesito saber programar?"** → No. Vas a escribir instrucciones en castellano y Claude Code hace el código. Si sabés armar una planilla y explicar cómo atendés vos, alcanza.
2. **"¿Cuánto sale y cómo se paga?"** → El precio te lo digo en los primeros diez minutos de la llamada, antes de que me cuentes nada más. Es un pago único, no una suscripción. `[CONFIRMAR: pesos/dólares, transferencia/tarjeta, cuotas, factura]`.
3. **"Cuando terminan los tres meses, ¿quedo solo?"** → Sí, y esa es la idea: el sistema está en tus cuentas y las instrucciones en un archivo que podés editar. `[CONFIRMAR: si hay alguna vía de consulta después y por cuánto tiempo]`.
4. **"¿Cuánto tiempo por semana me lleva?"** → La sesión es una hora. Aparte contá `[CONFIRMAR: X]` horas de trabajo tuyo. Si esa semana no las tenés, no arranques.
5. **"¿Me enseñás también a conseguir clientes?"** → No. Te enseño a construirlo y salís con uno hecho para mostrar. La parte comercial la ponés vos.
6. **"¿Qué necesito tener, y qué me sale mantenerlo prendido?"** → WhatsApp Business, Meta Business verificado y un número dedicado — usamos la API oficial, que es justamente lo que evita el baneo. Las APIs se pagan aparte: `[CONFIRMAR: X por mes para un negocio chico]`. Te lo digo ahora y no en la sesión 8.
7. **"¿Por qué no lo hago solo con YouTube?"** → En YouTube está la información. No está el orden, ni el diagnóstico de tu caso, ni alguien que te desatasque el martes a las 3 cuando la API de Meta devuelve un error que no está en ningún video.

*(La #7 absorbe el contraste competitivo: por eso no se construye la sección "Tres caminos".)*
*Reserva, si alguna de las 7 sobra:* si las sesiones quedan grabadas; horarios y zona horaria; qué pasa si en seis meses cambia la herramienta.

---

## 10. Plan de ejecución

**Regla de saldo:** por cada bloque nuevo que entra, uno que sale o se comprime (detalle en §6). La página tiene que quedar más útil, no más larga.

### Fase 0 — hoy, 30 minutos, sin tocar código
- [ ] Los tres números de §8.1: visitas/mes, agendas/mes, llamadas realizadas/mes.
- [ ] Recordatorios nativos de Calendly a 24 h y 1 h (una casilla).
- [ ] Llamar a las últimas personas que agendaron y preguntar qué las hizo agendar y qué casi las frena. Es la única fuente de datos que hoy tiene volumen suficiente.

### Fase 1 — hoy, 2 horas de código (todo en `index.html`)
- [ ] **7.1** — hardcodear los 4 `href`, borrar la línea 704, invertir `.reveal` con `.js` puesta adentro del bloque de reveal, cinturón a 2500 ms, borrar el `<noscript>`.
- [ ] **7.2** — sacar `reveal` de las líneas 442, 443, 444, 445, 452.
- [ ] **7.3 / 7.4** — borrar el listener de `load`, timeout a 7000, link de escape dentro del spinner, limpiar el `allow`, bypass por user agent para IG/FB.
- [ ] **Identidad**: "conmigo" → "con Mateo" (447, 633) + bloque "Quién te va a acompañar".
- [ ] **Microcopy de la llamada** (447): 30 minutos · sin costo · con Mateo.
- [ ] **`CC_LINE`** (963) a castellano llano.
- [ ] **7.6** — Open Graph + canonical + favicon + `COPY` en el `Dockerfile`.
- [ ] **7.10** — UTMs en `embedUrl()`.

### Fase 2 — esta semana (copy)
- [ ] Eyebrow, H1, subtítulo, links de auto-selección (§6).
- [ ] Demo: nombres de negocio (471, 835, 845, 855), micro-labels por tab, caption, reescritura del script de Instagram.
- [ ] Tarjeta B (520-521), bullets de "Qué vas a saber hacer" (535, 536, 538), etapas 01/02, fusión de 03+04.
- [ ] "Esto no es para vos si" con el número de horas `[CONFIRMAR]`; "Qué te llevás" reescrito al día 91.
- [ ] Bloque "Qué pasa en la llamada" + CTA final reescrito.
- [ ] FAQ de 7 preguntas.
- [ ] CTA de texto intermedio después de la línea 541.

### Fase 3 — esta semana (fuera del HTML)
- [ ] Mensaje humano de WhatsApp el día antes, por n8n (§8.2).
- [ ] "Qué traer a la llamada" en la confirmación y el mail de Calendly.
- [ ] `nginx.conf` con gzip y cache headers (confirmando antes con `curl` si Traefik ya comprime).
- [ ] `logo.png` → SVG inline o WebP 388×102.
- [ ] Línea 10: 10 pesos de fuente → 7.
- [ ] Umami en Easypanel + los 6 eventos de §11.
- [ ] Foto y bio verificable; captura real de Claude Code.

### Fase 4 — cuando lo anterior esté medido
- [ ] Garantía de encaje, si es sostenible operativamente (§5.8).
- [ ] Reorden de secciones (subir "Para quién es"): alto riesgo, respaldo débil, sólo si Fase 2 no movió nada.
- [ ] **Puerta blanda.** basdonax cierra con dos puertas y hoy la única salida de TEOTEC es agendar 30 minutos con un desconocido, desde tráfico frío, para un producto de cuatro cifras: el que no está listo se va y no vuelve. Dos opciones, en orden de preferencia: **(A)** el bloque "Así se construye" con la captura real de Claude Code como destino blando (*"Todavía lo estoy viendo → mirá cómo se construye"*, link de texto que scrollea, sin cambiar de canal); **(B)** un link de texto —nunca un botón— en el CTA final: *"Todavía lo estoy viendo — escribime la duda por WhatsApp"*. **B tiene un costo real y hay que decirlo: reintroduce el canal que el commit `e157a8f` sacó a propósito, y sólo funciona si lo contesta Mateo el mismo día.** Sin esa condición, no hacerlo.
- [ ] Demo viva en un número público (§5.10), con sus tres condiciones.
- [ ] Barra sticky mobile: sólo si el dato dice que llegan al final y no clickean.

---

## 11. Qué medir, y en qué línea va cada cosa

Umami self-hosted (~2 KB, sin cookies, sin banner). Guard obligatorio para que un bloqueador nunca rompa la página:

```js
function track(n, d){ try { if (window.umami) umami.track(n, d); } catch(e){} }
```

| Evento | Dónde va exactamente | Qué contesta |
|---|---|---|
| `cta_click` | dentro del listener de la línea 780, con `d.pos` = nav / hero / final | Cuál de los tres botones trabaja |
| `modal_open` | primera línea de `openCal()` (759) | Si el problema es antes o después del click |
| `cal_evento` | dentro del handler de `message` (792), mandando `d.event` como nombre | El embudo interno de Calendly: `profile_page_viewed` → `event_type_viewed` → `date_and_time_selected` → `event_scheduled` |
| `cal_fallo` | dentro de `fail()` (729) | Cuántos comen el spinner y ven el error — es el único modo de saber si el ITP de Instagram está costando reuniones |
| `demo_tab` | dentro del listener de la línea 939, con la clave del canal | Si la demo se toca o se mira |
| `llego_al_final` | dentro del callback del `IntersectionObserver` (812), cuando `e.target` tenga la clase `final-box` | Separa "no le interesó" de "le interesó y no encontró dónde clickear" |

**Cómo leer esto, dado el volumen.** Con un puñado de agendas por mes, ningún ratio de estos es estadísticamente nada. Sirven como **diagnóstico binario**, y sólo tres preguntas se pueden responder honestamente con ellos:

1. ¿Alguien abre el modal? (`modal_open` = 0 → el problema es la página o el tráfico, no el calendario)
2. ¿Alguien llega al final? (`llego_al_final` bajo respecto a las visitas → el problema es el tramo medio)
3. ¿El embed se rompe? (`cal_fallo` > 0 → 7.3 y 7.4 son urgentes, no teóricos)

**Lo que estos datos NO pueden responder, y hay que dejar de esperar que respondan:** si las preguntas de calificación de Calendly ayudan o rompen. Ese denominador es de un dígito por mes. Esa pregunta se responde llamando a las personas que ya agendaron y preguntándoles.


---

# Anexo A — Teardown completo de facundocorengia.com (la landing hermana)

Antes que nada, una aclaración que cambia cómo hay que leer todo lo demás: **facundocorengia.com y basdonax.com no son dos referencias, son una sola.** Misma persona, mismo número de WhatsApp (5491127619724, confirmado 14 veces en el HTML de cada una), mismo hosting (GoHighLevel), misma plantilla de secciones numeradas, misma tabla Punto A → Punto B, misma fórmula de garantía, mismo footer. El `<title>` de facundocorengia.com es literalmente "Basdonax AI | Pack Standard — Facundo Corengia". La diferencia es la audiencia: facundocorengia.com le vende mentoría a individuos (B2C), basdonax.com le vende consultoría a empresas (B2B).

Esto importa porque no hay consenso de dos fuentes independientes: hay un autor con dos versiones de la misma página. Pero también sirve de otra manera, y esta es la lección más útil del teardown: **el mismo tipo ordena la landing distinto según lo que tiene para mostrar.** Cuando tiene 8 testimonios en video, arranca con los casos. Cuando no los tiene (basdonax.com), arranca con el problema. TEOTEC está hoy en la segunda situación.

### Arquitectura de la página

11 `<section>`: hero + 10 secciones numeradas con barra + footer. El orden verificado:

`01 / CASOS DE ÉXITO` → `02 / EL PROBLEMA` → `03 / LA TRANSFORMACIÓN` → `04 / PARA QUIÉN ES` → `05 / LOS 3 PILARES` → `06 / QUÉ INCLUYE` → `07 / DIFERENCIADORES` → `08 / GARANTÍA` → `09 / PREGUNTAS` → `10 / PRÓXIMO PASO`

Es la inversión del manual clásico: la prueba va antes que el problema. La numeración con barra no es decoración: le da al visitante una sensación de recorrido finito, sabe cuánto falta.

Por dentro, todo es **un solo documento HTML autocontenido** metido en un bloque custom-code de GoHighLevel, con Tailwind v3.4.19 compilado a CSS estático e inline (hay un comentario del desarrollador que lo explica: no depende de CDN). 875.617 bytes, de los cuales ~175 KB son imágenes base64; las 22 miniaturas restantes se hotlinkean a img.youtube.com, o sea peso cero en su servidor. Dark-only forzado (`<html lang="es-AR" class="dark">`, cero `prefers-color-scheme`). Sin `loading="lazy"` en ninguna imagen. Un solo elemento sticky: el nav.

Detalle relevante para TEOTEC: **quedaron comentarios de desarrollo en producción**, incluida una nota interna con cita y fecha del cliente (`// Las visitas ya se miden en GHL (Facu 15/07: "yo lo tengo trackeado en High Level")`) y las instrucciones de cómo pegar el link del VSL. También: **cero pixel de Meta, cero GA, cero GTM.** Un solo script de terceros. Eso confirma que no está corriendo ads pagos sobre esta landing — el tráfico es orgánico desde YouTube e Instagram, y la página asume un visitante que ya lo conoce.

### Hero

Cuatro elementos, en este orden:

1. **Píldora clickeable arriba del H1**: "Nuevo · +50 alumnos cerrando contratos con empresas". Es un `<a href="#testimonios">` real. El primer clic posible de la página te manda a la prueba social.
2. **H1 a tres líneas**: "Conseguí clientes de IA todos los meses. Sin regalar tu trabajo." La tercera línea va en gris más claro y peso menor — el contraste tipográfico separa la promesa de la anti-promesa.
3. **VSL con patrón facade**: `data-video` apunta al video, pero no se inserta ningún iframe de YouTube hasta que hacés clic (verificado: 0 iframes en el HTML servido).
4. **Dos CTAs + barra de confianza de 3 ítems.**

Y debajo, una **barra de 5 métricas**: +50 Alumnos activos | Decenas Casos | +15 Módulos | 12 Meses 1:1 | 3 Clases semanales.

Esa barra es el hallazgo más aprovechable para TEOTEC hoy mismo. Fijate la composición: **un solo número de resultado** (+50), martillado cinco veces en toda la página (píldora, subheadline, barra de confianza, barra de métricas, tabla comparativa). Las otras cuatro cifras son **números de formato** — describen el producto, no un resultado, y por lo tanto son verificables por definición. Y donde no tiene un número duro, es deliberadamente vago: "Decenas de casos", no "37 casos".

### Prueba social

La sección más larga de la página, aproximadamente un tercio del total. 23 piezas en cuatro formatos apilados:

- **8 testimonios en video de YouTube**, cada uno con miniatura servida por img.youtube.com (no una imagen que él subió), badge, nombre y apellido, cifra en dólares y titular de transformación: Rodrigo Bustos US$15.000/mes, Alfredo US$12.000/mes, Andy Cruz US$8.000/mes, Juan García 7.500€/mes, Rodrigo Giudice US$5.000/mes, Lautaro Puebla US$4.500 en 45 días, Ramiro Blanco US$2.000/mes, Francisco Spina 2 clientes × US$3.000.
- **2 Shorts verticales** (Pablo Arce, Nicolás Magunacelaya).
- **4 capturas de resultados** embebidas en base64.
- **Un widget que replica la UI de historias destacadas de Instagram**: avatar de @facundocorengia + 6 círculos con el degradado de IG que linkean a highlights reales, más 9 miniaturas de testimonios.

**El detalle decisivo: ninguna de las 23 piezas es texto entrecomillado.** No hay un solo testimonio escrito. Todo es video, captura o link a una plataforma externa donde el visitante puede ir a verificarlo. Él sabe que un testimonio en texto adentro de tu propio HTML vale cero, y por eso no puso ninguno.

El principio transferible no es "conseguí testimonios" — es **la prueba tiene que ser verificable afuera de tu landing**. Cuando TEOTEC tenga sus primeros 2-3 alumnos, la instrucción es grabar video (aunque sea un Loom de 90 segundos con nombre y apellido), subirlo a YouTube o publicarlo en IG y linkearlo. Un video real vale más que diez tarjetas de texto.

Y acá está **la trampa más grande de esta referencia**: el slot #2 es el de mayor valor de la página, y TEOTEC no tiene nada de esto para poner ahí. Copiar el orden sería dejar un hueco visible. Pero TEOTEC tiene un activo que Facundo **no tiene y no puede tener**: la demo multicanal funcionando. Facundo no puede mostrar el producto porque su producto es acompañamiento; el producto de TEOTEC es un agente que atiende y vende por WhatsApp, Instagram y Facebook, y eso se puede tocar en vivo. Un agente respondiendo delante del visitante es **prueba de mecanismo** — otra categoría de prueba, pero prueba al fin, y la única que TEOTEC puede poner en el slot #2 hoy sin inventar nada.

### El creador como persona

Prácticamente no aparece. De las 27 `<img>` de la página, **ninguna es un retrato de Facundo** (los alts son "Caso Ricardo", "Testimonio {nombre}", "Basdonax AI"). No hay sección "sobre mí", ni bio, ni historia de origen, ni años de experiencia, ni clientes propios listados.

Su presencia se sostiene en tres cosas, y las tres son baratas:

1. **El VSL del hero**, un video a cámara sin siquiera thumbnail personalizado (el atributo `data-portada` quedó vacío, usa la miniatura por defecto de YouTube).
2. **Primera persona machacada en todo el copy**: "12 meses de coaching 1 a 1 conmigo", "Acceso a mí para preguntarme 24/7", "estás conmigo y vamos por tu resultado", "te acompaño hasta que lo logres".
3. **Una sola credencial, repetida dos veces**: "Construido desde la consultora de IA más grande de LATAM". Sin fuente, sin número, sin nada que la respalde.

Los puntos 1 y 2 son gratis y directamente copiables. El 3 es exactamente lo que TEOTEC no debe hacer: un superlativo sin respaldo.

Lo más importante de acá: **pasar el copy de "se enseña" a "te enseño / vas a trabajar conmigo"** es la conversión más barata de una landing genérica a una mentoría 1 a 1 creíble. No cuesta nada y no requiere ni un caso.

### Precio y CTA

**Cero precio y cero escasez en toda la página.** Verificado por conteo: "cupo"/"cupos" 0, "countdown" 0, "contador" 0, "temporizador" 0, "inversión" 0, "descuento" 0, "limitad" 0, "plazas" 0. Las únicas 4 menciones de "precio" están en el FAQ y hablan del precio que el **alumno** le va a cobrar a sus clientes. Tampoco hay cohortes: el ingreso es continuo.

El contraste con basdonax.com es la parte interesante. **La landing hermana del mismo dueño SÍ usa escasez**: "Trabajamos solo con 3 empresas por mes", y el prefill del WhatsApp dice literalmente "antes de que cierren los cupos del mes". O sea: usa cupos donde la restricción es operativa y real (una consultora no puede tomar más de 3 empresas por mes), y no los usa donde serían inventados (una mentoría 1 a 1 escalable). Esa disciplina es exactamente el tono que TEOTEC pidió. **Copiar el criterio, no el mecanismo.**

El CTA: **5 botones apuntando al mismo `wa.me` con el mismo mensaje pre-escrito.** Lo que cambia es el texto del botón según el contexto de la sección ("Aplicar" en el nav, "Quiero aplicar al Pack Standard" en el hero, "Quiero entrar al programa" después de qué incluye), no el destino. Cero calendario, cero checkout, cero formulario de aplicación al programa pago (verificado: 0 apariciones de "calendly", "booking", "checkout", "Agendar", "Reservar"; 0 etiquetas `<form>`). El único formulario es el del lead magnet.

Dos cosas para separar acá:

**Lo que NO aplica a TEOTEC**: WhatsApp directo funciona porque tiene un canal de YouTube que le manda tráfico caliente, gente que ya lo escuchó hablar dos horas. El WhatsApp es la continuación de una relación existente. TEOTEC no tiene eso — el Calendly con preguntas de calificación es la decisión correcta para tráfico frío, porque filtra.

**Lo que SÍ aplica**: (a) un solo destino repetido con el texto del botón adaptado a la sección; (b) **el microcopy debajo del CTA que dice qué va a pasar después**: "Arrancamos con una llamada 1 a 1 para armar tu plan." TEOTEC hoy manda a un Calendly sin decirle al visitante qué esperar en esos 30 minutos, y eso cuesta conversiones.

Y el patrón más aprovechable de todos: **el CTA final se bifurca por temperatura.** No un botón, dos, rotulados por el estado mental del visitante: "Ya lo tengo decidido — escribime" vs "Todavía lo estoy midiendo — recursos gratis". El mismo par se repite en el hero y después de los casos. TEOTEC hoy tiene una sola puerta; el que no está listo para una llamada de 30 minutos con un desconocido se va y no vuelve.

(El lead magnet, además, no termina en un PDF: es un embudo de 3 pasos — landing propia `/recursos` → formulario → `/gracias` rotulada "Paso 2 de 3" con barra al 70% — y el bonus final es la entrada a una comunidad de WhatsApp. El imán no te da un archivo, te mete en un canal donde te puede seguir hablando. TEOTEC no necesita replicar el embudo, pero sí el principio: si agrega la segunda puerta, que termine en un canal, no en un archivo.)

### Objeciones y FAQ

**El activo más copiable de toda la página.** 7 acordeones `<details>`/`<summary>` nativos, sin JavaScript. Las 7 preguntas están escritas **entre comillas, en primera persona, con voz de prospecto**, no como preguntas neutras de FAQ:

> "Ya pagué cursos y mentorías antes y no me movieron la aguja. ¿Por qué esto sería distinto?"
> "No sé programar tanto / no domino n8n. ¿Igual me sirve?"
> "Me da cosa mostrarme. ¿Quién me va a ver?"
> "No sé cuánto cobrar y termino regalando mi trabajo."
> "El momento que más miedo me da es dar el precio en la llamada."
> "No tengo testimonios ni casos para mostrar todavía."

**Ninguna es logística.** Nada de "¿cuánto dura?", "¿hay grabaciones?", "¿qué pasa si falto?". Todas son objeciones de venta reales y emocionales. La bajada de la sección lo declara: "Las dudas reales que aparecen en cada llamada inicial. Te las contesto de frente."

Copiable al 100% en estructura, 0% en contenido. TEOTEC tiene dos audiencias, así que le corresponden dos familias de objeciones, y escribirlas en rioplatense entre comillas es la mejora de conversión más barata que puede hacer esta semana.

Relacionado: la sección `04 / PARA QUIÉN ES` resuelve el problema de doble audiencia sin diluir el headline. En vez de hablarle a todos, abre **4 puertas nombradas** con emoji, título y párrafo de punto de partida: "El que arranca de cero", "El programador / Full Stack", "El freelancer / consultor", "El emprendedor con negocio propio". Y la bajada enmarca la ambigüedad como beneficio: "El sistema se adapta a tu punto de partida." Cierra con **descalificación explícita**: "Esto NO es para vos si: buscás dinero rápido sin esfuerzo, o esperás que el programa haga todo solo."

Este es el hallazgo más directamente aplicable al problema estructural de TEOTEC. La doble audiencia hoy es una debilidad del mensaje; esta solución la convierte en fortaleza.

Sobre la garantía: la estructura es buena — **la condición va en la misma oración que la promesa**, no en letra chica, y hay una segunda línea que justifica por qué la puede ofrecer ("Ofrecemos garantía porque el sistema está validado. Quienes aplican y hacen el trabajo, cierran."). Eso convierte la garantía en argumento de prueba en vez de truco de cierre. Pero su razón se apoya en 8 testimonios; TEOTEC no puede decir "está validado" sin mentir. Si TEOTEC quiere garantía, tiene que ser una que sostenga con lo que sí tiene.

### Tono

Hay que separar dos capas, porque la página es limpia en una y derrapa fuerte en la otra.

**Mecánica: impecable.** Sin cuenta regresiva, sin cupos falsos, sin precio tachado, sin "últimas horas", sin cohorte que cierra. Y con dos declaraciones anti-gurú explícitas: "No te vendo magia: te acompaño hasta que lo logres" y la descalificación de la sección 04.

**Vocabulario y promesa: derrapa.** Los puntos exactos:

- Toda la muralla de testimonios está construida sobre **income claims en dólares como titular de cada tarjeta**.
- "Libertad geográfica y financiera" como resultado a 12 meses.
- "high ticket" usado 3 veces; "Cómo cobrar caro con confianza" como bullet de pilar.
- Ataque a la competencia con vulgaridad: "A las comunidades de Skool les chupa un huevo si te va bien."

Y la landing del lead magnet (`/recursos`) es varios grados peor: "no las boludeces que te muestra tu gurú favorito de Skool", "Por qué ser solo técnico te mantiene pobre", "Cómo dejar de ser un descremado eterno en IA", "el video de oferta que vende por vos mientras dormís".

**La referencia es útil en estructura y peligrosa en voz.** Eso funciona para Facundo porque es su voz de YouTube y el visitante ya la conoce de antes; en una landing sin audiencia previa que la contextualice, sonaría impostado.

Un último eje que sí vale la pena robar entero: **el argumento central no es el temario, es la relación 1 a 1.** Aparece en el subheadline, en la barra de métricas, como primer ítem de qué incluye, como fila de la tabla comparativa, en la primera respuesta del FAQ y en el cierre. El enemigo declarado no es "no saber IA", es "el curso grabado que te deja solo". Y acá TEOTEC puede hacer ese argumento **con más honestidad que él**: 12 sesiones en vivo 1 a 1 en 3 meses + asistencia diaria por WhatsApp es una densidad de contacto mayor que repartir el 1 a 1 a lo largo de 12 meses con clases grupales. Ese argumento no necesita un solo testimonio: se sostiene con la estructura del producto.

---

**Nota de verificación:** los conteos finos de CTAs ("9 botones, 5 a WhatsApp, 4 al formulario") y de enlaces no se pudieron reproducir con exactitud — el bloque custom-code de GHL aparece duplicado en el HTML, así que todo conteo textual queda inflado; la dirección del claim es correcta pero los números exactos no. Tampoco se pudo leer el contenido de YouTube ni LinkedIn de Facundo (devuelven la shell de la SPA), ni confirmar el dato de "empresas de 5 a 50 empleados" de basdonax.com.

---

## Copiar

1. **Barra de métricas en el hero, con números de formato**: `3 meses · 12 sesiones en vivo · 1 por semana · asistencia diaria por WhatsApp · 1 a 1`. Cero afirmaciones de resultado, cero riesgo, y le da a la landing la textura de concreción que hoy no tiene. Es el reemplazo más directo de la prueba social ausente y se puede poner mañana.
2. **Orden de basdonax.com, no el de facundocorengia.com**: problema → demo multicanal → para quién es → qué incluye → garantía → FAQ → próximo paso. El día que TEOTEC tenga 2-3 videos de alumnos, ese bloque sube al slot #2. Ese es el plan de migración.
3. **La demo multicanal en el slot #2**, donde Facundo pone los casos. Un agente respondiendo en vivo por WhatsApp/Instagram/Facebook delante del visitante — prueba de mecanismo, la única categoría de prueba que TEOTEC puede dar hoy sin inventar nada, y que la referencia no puede dar nunca.
4. **Sección "Para quién es" con 2 perfiles nombrados**: "El dueño de negocio que vende por chat" y "El que quiere aprender la habilidad para venderla como servicio", cada uno con emoji, punto de partida y qué cambia. Convierte la doble audiencia de debilidad en feature. Cerrar con descalificación explícita ("Esto no es para vos si...") — es lo que hace que todo lo demás suene honesto.
5. **FAQ de 7 objeciones entre comillas, en primera persona y en rioplatense**, con `<details>`/`<summary>` nativos. Nada logístico. Al dueño de negocio: "¿No me conviene contratar a alguien que me lo arme?", "¿Y si mis clientes se dan cuenta de que es un bot?", "¿Esto no lo hace cualquier chatbot?". Al que quiere aprender: "No sé programar", "¿En un año no lo va a hacer la IA sola?", "¿Tres meses alcanzan?". Bajada: "Las dudas que aparecen en cada llamada. Te las contesto de frente."
6. **Pasar todo el copy a primera persona**: de "se enseña a construir agentes" a "te enseño / vas a trabajar conmigo / te contesto por WhatsApp todos los días". Gratis, y es lo que hace creíble que sea una mentoría 1 a 1.
7. **VSL de 2-4 minutos a cámara en el hero, con patrón facade** (miniatura + botón de play, sin cargar el iframe de YouTube hasta el clic). Es la forma más barata de poner al mentor en la página sin bio, sin foto de estudio y sin credenciales.
8. **Microcopy debajo de cada CTA diciendo qué va a pasar**: "Son 30 minutos, 1 a 1, para ver si tu caso da para esto." Hoy el Calendly aparece sin contexto y eso frena clics.
9. **El mismo destino repetido, variando solo el texto del botón** según la sección: "Agendar reunión" en el nav, "Quiero ver si esto es para mí" después de la demo, "Agendemos y lo vemos" al final.
10. **Segunda puerta al final, rotulada por temperatura**: "Ya lo tengo decidido — agendemos" vs "Todavía lo estoy viendo — [algo chico y honesto]". No hace falta una carpeta de 23 recursos: alcanza con una guía de qué se puede y qué no se puede automatizar en la atención por chat. Y que termine en un canal (comunidad, lista), no en un archivo.
11. **El eje "no vas a estar solo mientras lo construís"** repetido en subheadline, métricas, qué incluye, FAQ y cierre. Es el argumento más fuerte de TEOTEC y no necesita ni un caso para sostenerse.
12. **Higiene técnica**: hotlinkear miniaturas de YouTube en vez de subir imágenes, `loading="lazy"` en todo lo below-the-fold, y revisar que el `index.html` de TEOTEC no tenga comentarios de desarrollo ni notas internas en producción — la referencia dejó los suyos a la vista.

## No copiar

1. **El orden con la prueba social en el slot #2.** Sin testimonios eso deja un hueco visible que grita "nadie compró esto todavía". Ese slot va para la demo.
2. **Testimonios en texto entrecomillado.** La referencia no puso ni uno, y tiene 23 piezas de prueba. Si TEOTEC no puede linkear a algo verificable afuera (video en YouTube, post de IG), no va nada.
3. **Cualquier income claim.** Ni de alumnos, ni del mentor, ni "los agentes recuperan X ventas". Es el pilar de toda la prueba de Facundo y es exactamente el tono prohibido de TEOTEC.
4. **El vocabulario de gurú**: "high ticket", "cobrar caro", "libertad financiera", "vende por vos mientras dormís", "escalá tu agencia". Ninguna de esas frases entra al `index.html`.
5. **Atacar a la competencia, y menos con vulgaridad.** El párrafo sobre Skool funciona para su voz de YouTube; en una landing sin audiencia previa suena impostado y barato.
6. **Credenciales superlativas sin respaldo**, tipo "la consultora de IA más grande de LATAM". Si TEOTEC no tiene un número que pueda sostener, no va ningún superlativo.
7. **Escasez de cualquier tipo**: cupos, cohortes que cierran, contadores, fechas límite. El propio autor no las usa en su landing B2C — las usa solo en la B2B, donde "3 empresas por mes" es una restricción operativa real. Criterio, no mecanismo.
8. **Garantía de resultados.** "Extendemos hasta que lo logres" requiere casos que la respalden. La versión honesta para TEOTEC: si en la primera sesión el alumno ve que no es para él, no sigue y no paga el resto. Verificable, sostenible, y no necesita ningún caso previo.
9. **Cambiar el Calendly por WhatsApp directo.** El WhatsApp le funciona a Facundo porque su tráfico llega caliente desde YouTube. Con tráfico frío, el formulario de calificación filtra y protege la agenda.
10. **Dark-only forzado.** La referencia no respeta `prefers-color-scheme`; con público LATAM mayoritariamente móvil, conviene soportar ambos.
11. **El registro de `/recursos`.** Si TEOTEC hace un lead magnet, el tono de esa página tiene que ser el mismo que el de la landing. En la referencia son dos voces distintas y la del lead magnet es la peor de todo el sitio.
12. **Poner el precio.** Confirmado: la referencia no lo pone en ningún lado. La decisión de TEOTEC de definir los USD 997 en la llamada es la correcta.

