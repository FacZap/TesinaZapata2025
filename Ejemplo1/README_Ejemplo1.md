# Ejemplo1 — Descripción Detallada

---

## Scripts Principales de Control

### `script_imc.m`
Script base para diseño de controladores IMC (*Internal Model Control*). Carga el modelo `G_candidata`, calcula RGA, aplica ordenamiento diagonal de columnas `(1,2,3,7)`, crea estructuras `G_d` (Desc), `G_s` (Sparse) y `G_reo`, aplica ceros a elementos fuera de la diagonal para estructura Desc, calcula polos máximos, aplica Teorema de García-Morari para verificar estabilidad/robustez, define filtros diagonales `F_d`, calcula `Kimc_u = G⁻¹ × F_d` (controlador IMC), y convierte a controlador clásico `K_clasica`.

### `script_desc.m`
Script específico para estructura Descendente (Desc). Ejecuta `INI`, carga `G_candidata`, aplica el mismo análisis RGA y ordenamiento que `script_imc`, define filtro, calcula controlador IMC, define `select_area='d'`, y calcula parámetros PID usando `IMC_Controladores_HEN` para ambas estructuras.

### `script_spar.m`
Script para estructura Sparse. Análogo a `script_desc`.

### `script_PID.m`
Script dedicado al cálculo de controladores PID. Extrae `Kp` y `Tp` de la diagonal de `G_d` y `G_s`, usa `IMC_Controladores_HEN` con `Kc_per=0.1` y `Tp_per=1`, calcula `Kc`, `Taoi`, `Taod` para cada lazo diagonal `(i,i)`, y guarda resultados en matrices `Kc_d`, `Taoi_d`, `Taod_d` y versiones `_s` para Sparse.

### `script_rga_analysis.m`
Script de análisis RGA para selección de variables de control. Carga `G_candidata`, calcula RGA de la matriz de ganancias, genera todas las combinaciones de 4 entradas de 7 disponibles, calcula número de condición para cada combinación, analiza RGA de cada submatriz reducida, e identifica combinaciones óptimas.

---

## Inicialización

### `INI.m`
Script de inicialización de variables para simulación. Define:
- Condiciones iniciales de áreas (`area1_ini` a `area4_ini`)
- Puntos de operación (`area1` a `area4`)
- Tiempos característicos (`area_time`, `bypass_time`, `fcu_time`)
- Valores iniciales de VM: `uh112`, `uh211`, `uh222`, `uc112`, `uc211`, `uc222`, `fcu`
- Setpoints: `sp1=385`, `sp2=400`, `sp3=560`, `sp4=340`
- Vector `initials`
- Parámetros de simulación: `d_time=50`, `sim_time=300`
- Caso: `caso=3` → `RIC=1`

### `INI_identify.m`
Variante de `INI` para identificación de sistemas. Similar a `INI` pero incluye:
- Definición explícita de todas las variables `u1`–`u7` y `d1`–`d8` con valores inicial y final
- Inicialización de `u1`–`u3` con `initials(1-3)`
- `t_sp_change=0` para análisis de identificación

---

## Construcción de Modelos

### `build_tfs.m`
Función para construir funciones de transferencia del proceso (G). Extrae valores finales de salidas (`Thout1/2`, `Tcout1/2`), detecta qué salidas responden (> umbral de cambio), calcula ganancias estáticas `g_est_vector = (T_end - T_ini)/delta`, estima constantes de tiempo `t_corte` usando el tiempo donde se alcanza el 63.2% del valor final, y construye modelos de primer orden `G_modelo`.

### `build_tfs_d.m`
Similar a `build_tfs` pero para modelo de perturbaciones (D). Calcula `d_est_vector` para perturbaciones y construye `D_modelo(k, d_selected) = K/(τs+1)`.

---

## Cálculo de Controladores

### `Calculo_Simplificar_Controlador_Desc.m`
Script para extraer controladores PI simplificados desde Simulink. Ejecuta simulaciones con vectores de excitación unitarios, extrae `Kc` de la primera respuesta no-nula, calcula `Ti` mediante `polyfit` de la señal de control, construye matriz `Gc1_n` diagonal con funciones de transferencia PI: `Kc + Kc/(Ti·s)`, y guarda en `Gc1_desc_simplificado.mat`.

### `Calculo_Simplificar_Controlador_Spar.m`
Versión para estructura Sparse del cálculo de controladores. Similar a Desc pero con estructura de acoplamiento diferente.

### `ajuste_imc_desc.m`
Script de ajuste IMC específico para Desc. Carga `G_candidata` desescalado, ordena diagonalmente `(1,7,2,3)`, construye matriz `Gvn1` diagonal (Desc), verifica Teorema de García-Morari, calcula filtro con `filt=5`, deriva `Kimc1` y `Gc1` (controlador equivalente feedback), y calcula PID usando `IMC_Controladores_HEN`.

### `ajuste_imc_spar.m`
Versión de ajuste para estructura Sparse.

---

## Iteraciones y Simulación

### `iter_loops.m`
Script batch para ejecutar múltiples simulaciones variando variables. Itera sobre lista de nombres de variables (`var_names`) y valores, aplica operación (`multiply` o `add`), asigna nuevas variables al workspace, ejecuta simulación `Red_problema1_original.slx`, grafica resultados, y opcionalmente guarda figuras.

### `iter_loops_imc.m`
Variante de `iter_loops` para controladores IMC. Carga matrices IMC, usa `Simulink.SimulationInput` para personalización, ejecuta `Red_problema1_imc.slx`, grafica con `plot_salidas_imc`, y reinicia condiciones dinámicas entre iteraciones.

---

## Análisis de Resultados

### `error_sgnd.m`
Script para calcular error relativo con signo. Extrae valores finales de `yout` y calcula:

```
err_sgnd(k) = (y_final - sp_k) / sp_k × 100
```

para cada salida, y copia al portapapeles en formato tabulado.

---

## Otros Scripts

### `normalizar.m`
Script para normalizar matrices G y D. Extrae ganancias estáticas, normaliza columnas (`1–6 × 1/10` para bypass/temp, `columna 7 × 30/10` para fcu/temp), reordena columnas, y exporta a Excel `matrices_normalizadas.xlsx`.

### `pert_max.m`
Define perturbaciones máximas toleradas: `thin1=5`, `tcin1=-5`, `tcin2=-5`.

### `max_pert.m`
Script simple que llama a `pert_max` para cargar valores de perturbación máxima.

### `primer_orden_simple.m`
Script para identificación rápida de modelos de primer orden. Itera sobre `selected_outputs`, crea timeseries de `yout` y `u_exc`, llama `identification_P1_HEN(tout, y_f, u, 50, 0)` para obtener `Kp`, `Tp`, y setea a 0 las salidas no seleccionadas.

### `script_variar_vms.m`
Script de análisis de sensibilidad de VMs. Varía bypasses (`uh112`, `uh211`, `uh222`) y utilities (`uc112`, `uc211`, `uc222`, `fcu`), varía temperaturas de entrada (`thin1`, `thin2`, `tcin1`, `tcin2`), calcula errores relativos para cada combinación, y estudia respuesta dinámica de `uh112`.

---

## Archivos de Datos (`.mat`)

| Archivo | Descripción |
|---|---|
| `G_candidata.mat` | Modelo de funciones de transferencia identificado de la red. |
| `D_candidata.mat` | Modelo de funciones de transferencia entrada-perturbaciones. |
| `dynamic_inter_*.mat` | Estados estacionarios de intercambiadores. Necesario para que el modelo matemático de los intercambiadores funcione y las simulaciones se ejecuten correctamente. |
| `valores_entradas.mat` | Valores de entradas usados para identificar el modelo G obtenido. |

---

## S-Function de Simulink

### `Int_er.m`
Función S-function de Simulink para intercambiador dinámico.

---

## Archivos de Simulación (`.slx`)

| Archivo | Descripción |
|---|---|
| `Red_problema1_original` | Red a lazo abierto. |
| `Red_problema1_imc` | Red a lazo cerrado con controlador esquema IMC. |
| `Red_problema1_imc_Kclasica` | Red a lazo cerrado para simular el controlador clásico (convertido matemáticamente desde el IMC). |
| `Red_problema1_imc_Kclasica_nuevo` | Red a lazo cerrado con controlador clásico desglosado en dos bloques `[K_imc y G_imc]` (la última multiplicación matricial se realiza directamente en Simulink). |
| `Red_problema1_identify` | Red a lazo abierto con los modelos G y D corriendo en paralelo junto a la planta, conectados a un mismo scope para validar rápidamente los modelos. |
| `Red_problema1_rndm` | Red a lazo abierto con modelos G y D en paralelo, donde las entradas escalón fueron reemplazadas por un tren de pulsos aleatorio. |
| `Red_problema1_imc_rndm` | Red a lazo cerrado donde las perturbaciones escalón fueron reemplazadas por un tren de pulsos aleatorio. Representa un gran estrés para el controlador. |
