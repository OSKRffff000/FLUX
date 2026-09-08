# Flux — sistemas avanzados GML

Abre `juegojuegojuego.yyp` y ejecuta `Room1` en GameMaker. La sala y GUI usan 720 × 1280. Mantén la flecha izquierda/derecha o pulsa la mitad izquierda/derecha de la pantalla para orbitar. Sin entrada, la nave se detiene; entradas opuestas se neutralizan. La nave dispara automáticamente. No hay salud para la nave: un impacto destruye, excepto si se consume el escudo o está activa Fase Fantasma.

## Archivos principales

- `objects/obj_hud/Draw_64.gml`: iconos monocromáticos y arcos de 360 a 0 grados según `remaining / duration`.
- `objects/obj_menu_arbol/Create_0.gml`: genera 30 nodos con trigonometría, cinco ramas separadas por 72 grados y seis niveles cada una.
- `objects/obj_menu_arbol/Step_0.gml`: cámara virtual en coordenadas GUI; arrastre, pellizco, rueda y botones +/−. La transformación inversa permite seleccionar nodos después del pan/zoom. Un arrastre no compra.
- `objects/obj_menu_arbol/Draw_64.gml`: pentágono, conexiones, requisitos, costos y acceso a evolución pospuesta.
- `objects/obj_game_manager/Create_0.gml`: catálogo, ramas, estadísticas, `evaluate_evolution`, compras y persistencia.
- `objects/obj_game_manager/Step_0.gml` y `Draw_64.gml`: menú de Aceptar/Posponer con vista previa de la nueva forma.
- `objects/obj_game_manager/Step_1.gml`: Begin Step actualiza buffs y escala temporal; temporizador de transición planetaria.
- `objects/obj_planeta/Step_0.gml` y `Draw_0.gml`: daño, anillo de salud, destrucción y ataques.
- `objects/obj_nave/Create_0.gml`, `Step_0.gml` y `Step_2.gml`: buffs, armas y colisiones en End Step. El escudo no acumula cargas.
- `scripts/flux_core/flux_core.gml`: enum de buffs, arcos, glifos, siluetas, explosiones y geometría de colisión.

## Ocho potenciadores

Aparecen fuera de cualquiera de los cuatro bordes y viajan al centro. Recoger uno renueva su duración; tipos distintos coexisten. Duración base: seis segundos multiplicados por Utilidad y mascota; Fantasma dura el 60% de esa duración.

| Buff | Efecto |
|---|---|
| Frenesí de Fuego | Cadencia ×2; para el láser continuo, daño por segundo ×2. |
| Munición Perforante | El proyectil continúa al atravesar el planeta; sólo lo daña una vez. El láser se prolonga hasta el otro lado. |
| Bombardeo Aleatorio | Proyectil adicional hacia el centro desde un ángulo aleatorio cada 0.18 s. |
| Escudo de Energía | Absorbe un golpe y elimina el peligro que lo produjo; expira si no se consume. Recoger otro renueva, no acumula. |
| Apagón Defensivo | Los láseres enemigos no se dibujan ni causan daño mientras dura. |
| Fase Fantasma | Inmunidad temporal; no consume el escudo. |
| Distorsión Temporal | Ataques, láseres, spawner y caída de buffs al 35% de velocidad; nave y armas conservan su velocidad. |
| Súper Imán | Atrae todos los puntos coleccionables hacia la nave. Cada punto recogido vale un crédito. |

Los láseres planetarios tienen un segundo de anticipación. Los puntos salen al destruir el planeta; los buffs siguen naciendo exclusivamente fuera de la pantalla.

## Árbol y evolución

Los niveles cuestan 1–6 puntos y requieren el nivel anterior de su rama. Los bonos son acumulativos y aumentan con la profundidad. Crítico suma puntos porcentuales. A partir de **15 puntos gastados** se ofrece la forma correspondiente a la rama con mayor inversión. Empates: orden de la tabla. No hay evolución automática.

| Rama dominante | Evolución aceptada |
|---|---|
| Potencia | Arsenal Pesado: tres balas simultáneas. |
| Frecuencia | Núcleo Energético: láser continuo hacia el planeta. |
| Maniobrabilidad | Nave Nodriza: duplica el bono de la mascota equipada. |
| Crítico | Bombardero Orbital: misiles con explosión de radio 160 que elimina proyectiles y láseres alcanzados. |
| Utilidad | Cosechador Cósmico: recoger cualquier buff genera una onda que limpia proyectiles enemigos. |

Aceptar fija la forma; compras posteriores no la sustituyen. Posponer conserva el disparo base y habilita `Ver evolucion` en el árbol. Al reabrir se evalúa la rama dominante actual. La forma aceptada y la decisión de posponer se guardan. Se generan seis sprites monocromáticos (base y cinco evoluciones) al dibujar por primera vez; Clean Up libera esos recursos.

Las mascotas sólo se compran: Eco 60 créditos (+15% daño), Pulso 90 (+20% cadencia), Luna 75 (+30% duración). Nodriza eleva estos bonos a 30%, 40% y 60%, respectivamente. Sólo una equipada.

## Planetas y persistencia

El anillo pegado al planeta representa `hp / max_hp`. Al agotarse, se elimina la instancia y sus ataques; el manager espera un segundo de tiempo activo sin planeta antes de crear el siguiente. Se usa un temporizador en segundos en lugar de una alarma ligada a frames. Distorsión no prolonga esa transición y los menús la pausan.

Cada planeta recibe un `image_blend` saturado aleatorio con un tono distinto del anterior. Planeta, ataques y sus partículas tienen color; nave, HUD, buffs, mascotas y fondo permanecen monocromáticos.

Destruir un planeta otorga 20 créditos, un punto de mejora y ocho puntos coleccionables adicionales. `flux_save.ini` conserva compras y progreso; las partidas anteriores de tres niveles se cargan con los nuevos niveles sin comprar. Reintentar limpia entidades y buffs, vuelve al planeta 1 y conserva compras.

## Validación

`node tests/flux_logic.cjs` comprueba funciones extraídas del GML cuya sintaxis comparte JavaScript: colisiones barridas, cruces de láser, prerrequisitos, umbral de evolución, posponer/reabrir, conservación de elección, saldo y efecto Nodriza. No emula eventos, renderizado ni la semántica completa del motor. También se comprobaron recursos, referencias, eventos y delimitadores.

Este entorno no tiene GameMaker/Igor; falta compilar y probar en el motor. Prueba manual sugerida:

1. Recoger los ocho buffs; revisar arcos, expiración, renovación y combinaciones. Dos impactos consecutivos con escudo deben consumirlo y luego destruir la nave.
2. Cruzar láseres con Apagón/Fantasma y comprobar el comportamiento al expirar. Comparar movimiento del nivel con y sin Distorsión.
3. Arrastrar y hacer pellizco/zoom en el árbol; comprar nodos fuera de la vista inicial. Verificar que un gesto no compra ni activa botones.
4. Alcanzar 15 puntos, posponer, reabrir, aceptar y reiniciar el juego. Probar cada rama dominante en partidas de prueba distintas.
5. Verificar las cinco armas/formas y Nodriza con cada mascota. Comprobar que la perforación no aplica daño cada frame.
6. Destruir un planeta: anillo vacío, desaparición, intervalo de un segundo y nuevo color. Reintentar durante la transición no debe crear planetas duplicados.
7. Probar en dispositivo móvil vertical, incluidos cambios de aplicación y rendimiento de partículas.

## Ajuste de dificultad: patrones avanzados

`obj_planeta/Create_0.gml` define `base_hp=600` y `health_multiplier=1.28`: la vida es `ceil(600 * power(1.28, stage - 1))` (600, 768, 984, 1259…). El exponente se limita a 200 para acotar valores en partidas extremas. La nave conserva su regla de un impacto letal.

`obj_planeta/Alarm_0.gml` se rearma cada frame con `alarm[0]=1`, pero cuenta los cooldowns en segundos con `flux_world_dt()`: los menús pausan y Distorsión ralentiza la máquina de estados. Primera ofensiva tras 0.8 s; descansos posteriores entre 0.65 y 1.4 s según nivel. La elección es aleatoria entre tres patrones y excluye repetir el anterior.

- **Espiral (4.5 s):** cuatro a ocho brazos según nivel; el emisor gira a 95 grados/s y las balas curvan ligeramente a 9 grados/s. Intervalo de salvas de 0.22 a 0.10 s.
- **Barrido (5.8 s):** un segundo de preaviso fijo y 4.8 s de láser continuo girando a 29.5–52 grados/s. Puede girar en ambos sentidos. Apagón, Fantasma, escudo y explosiones siguen funcionando.
- **Intercepción (4 s):** salvas de tres balas separadas siete grados, apuntadas al ángulo orbital futuro según distancia, velocidad del proyectil, dirección y velocidad de la nave. La predicción considera Distorsión; invertir después del disparo permite esquivarla. Intervalo de 0.65 a 0.32 s.

`obj_proyectil_espiral` hereda de `obj_ataque_planeta`: comparte colisiones, partículas, destrucción por ondas y limpieza al reintentar. Sus eventos Create y Step permiten configurar `heading`, `velocity` y `turn_rate`. Con `turn_rate=0` sirve para las salvas predictivas. Todos los ataques usan `image_blend` saturado, también en su dibujo por primitivas.

La colisión de `obj_laser_planeta` muestrea el giro y el desplazamiento de la nave entre frames, con una tolerancia de un píxel. Las pruebas aisladas incluyen un barrido que cruza la nave sin tocarla en ninguno de los dos rayos extremos. Queda pendiente probar el balance y compilar en GameMaker: no hay compilador del motor en este entorno.

## Borrar progreso

El menú principal incluye `obj_boton_reset`, con Create, Draw GUI y Step para ratón/toque sin sprite. Al pulsar **Borrar Datos**, llama a `scr_resetear_progreso()` y después a `game_restart()`.

La función elimina `flux_save.ini`, restablece créditos/puntos, los 30 nodos, mascotas, evolución y estadísticas base, y elimina las entidades temporales. No vuelve a guardar el archivo. Si la eliminación falla, devuelve `false`, conserva el progreso y muestra un mensaje sin reiniciar. Si el archivo no existe, el reseteo también funciona. Implementar este botón no elimina el guardado del desarrollador: el borrado ocurre sólo al pulsarlo durante el juego.
