# Ejemplo6 — Descripción Detallada

---

## Scripts Principales de Control

### `SUPER_SCRIPT_6.m`
Script principal batch que ejecuta todas las simulaciones del problema 6. Verifica que esté en la carpeta correcta y ejecuta 12 simulaciones: 3 estructuras (Desc/Spar/Full) × 4 perturbaciones (a/b/c/d). Para cada simulación: limpia variables, llama `script_desc`/`script_spar`/`script_full`, define filtro IMC (`filt=300`), ejecuta `imc_d`/`imc_s`/`imc_f`, define perturbaciones (`d_temp`, `d_flow`), ejecuta `sim('Red_problema6_imc')`, llama `univ_plotter`, `save_univ_plotter`, `indices_universales`, y guarda métricas en tablas. Al final genera timestamp y guarda datos.

### `script_IMC.m`
Script base para diseño de controladores IMC. Carga modelo `G_modelo`, selecciona columnas según estructura:
- **Desc:** `2, 9, 10, 11`
- **Spar:** `3, 8, 9, 10`
- **Full:** `2, 8, 9, 10`

Reordena para diagonalización, elimina elementos que deben ser cero, aplica Teorema de García-Morari, define filtros (`filt1=filt2=800`), calcula `Kimc_u = G⁻¹ × F_d`, deriva `K_clasica = (I - Kimc_u × G⁻¹) × Kimc_u`, y setea `switch_var` (`0=Desc`, `1=Spar`, `2=Full`) junto con parámetros `aE` de áreas.

### `script_PID.m`
Script para calcular controladores PID. Extrae `Kp` y `Tp` de la diagonal de `Gd`/`Gs`/`Gf`, usa `IMC_Controladores_HEN` con parámetros `(Kc_per, Tp_per)`, construye matrices `PID_d`/`PID_s`/`PID_f` con `tf(pid(Kc, Taoi))`, inicializa matrices a cero para estructuras no usadas, y calcula `Taod`, `Taoi`, `Kc` para cada estructura.

### `script_desc.m` / `script_spar.m` / `script_full.m`
Scripts específicos por estructura. Llaman `ini_comun`, setean `RIC=6`, definen `nominales_u` según estructura, cargan modelos `G_modelo_v*` y `salida_pt_op`, inicializan entradas y áreas, calculan IMC con filtros específicos (`filt1=filt2=300`), calculan PID, y setean `select_area`.

---

## Inicialización

### `ini_comun.m`
Script de inicialización común. Limpia variables, inicializa `G_modelo(4×11)` a `tf(0)`, define variables globales de límites, datos de corrientes, setpoints y flujos:

| Variable | Valor |
|---|---|
| `Thin1` | 543 K |
| `Thin2` | 493 K |
| `Tcin1` | 323 K |
| `Tcin2` | 433 K |
| `Tcuin` | 288 K |
| `Thuin` | 523 K |
| `sp1` | 433 K |
| `sp2` | 333 K |
| `sp3` | 483 K |
| `sp4` | 483 K |
| `fcu1` | 1.45 |
| `fcu2` | 5 |
| `fhu2` | 15 |
| `sim_time` | 60000 |
| `t_step` | 20000 |

### `script_ini_ej6.m`
Inicialización específica para Ejemplo6.

### `inicializar_areas.m`
Script que define áreas de intercambiadores para cada estructura. Define valores nominales de `aE` (áreas efectivas) y coeficientes para cada estructura: `_d` (Desc), `_s` (Spar), `_f` (Full). Asigna según `select_area`: `aE112`, `aE121`, `aE213`, `aE222`, `aEcu1`, `aEcu2`, `aEhu2`.

### `inicializar_entradas.m`
Inicializa valores de entrada `u1`–`u11` y perturbaciones `d1`–`d8`. Asigna `initials(i)` a `u*_in` y `u*_end`, y `0` a `d*in`/`d*end`.

---

## Validación y Construcción de Modelos

### `validacion.m`
Script de validación del modelo. Para cada VM (`u1`–`u11`): aplica cambio escalón, ejecuta `sim('Red_problema6')`, llama `save_plot_validacion`. Define `nom_ini` y `nom_fin` para cada variable, usa `t_step=500`, `sim_time=3000`.

### `script_build_tfs.m`
Script completo para construir funciones de transferencia G y D. Inicializa todo, define nominales para Desc/Spar/Full, corre simulaciones de lazo abierto para cada VM y perturbación, guarda `salida_pt_op_*`, llama `build_tfs` y `build_tfs_d` para cada cambio, reconstruye G y D reordenando columnas según mapeo:

```
MV3  MV4  MV1  MV2  MV7  MV8  MV5  MV6  MV9  MV10  MV11
```

y guarda en `G_D_modelo_lazo_abierto.mat`.

### `build_tfs.m` y `build_tfs_d.m`
Funciones para construir modelos de funciones de transferencia del proceso y perturbaciones respectivamente. Ver Ejemplo1 para descripción detallada.

---

## Análisis RGA

### `script_RGA.m`
Script de análisis RGA exhaustivo. Carga `G_modelo`, analiza submatrices, calcula RGA para matriz completa y reducidas, genera 330 combinaciones de 4 variables de 11 disponibles, calcula número de condición para cada combinación, busca combinaciones óptimas, y analiza estructura `2,9,10,11` como referencia.

---

## Otros Scripts

### `din_inter.m`
Función de dinámica de intercambiador de calor. Es necesaria para simular correctamente los intercambiadores. Parámetros de entrada: `u = (Thin, fh, hh, Tcin, fc, hc, Rd, Area)`. Calcula:
- Diferencias de temperatura (`dth`, `dtc`)
- Temperatura media (`delTref`)
- Coeficiente global `U`
- Calor transferido: `Q = Uf × aef × delTref`
- Balances de energía para cada rodaja

Retorna derivadas `dThoutdt`, `dTcoutdt`.

### `todo_nom_desc.m` / `todo_nom_spar.m` / `todo_nom_full.m`
Scripts que setean valores nominales según estructura. Asignan `nominales_u_desc`/`spar`/`full` a `u*_in`/`u*_end`, y `0` a `u9`–`u11` y todas las perturbaciones `d*`.

### `todo_in.m`
Script simple que setea todas las entradas y perturbaciones a `0` o valores iniciales.

### `pert_max.m` / `max_pert.m`
Definiciones de perturbaciones máximas toleradas. Ver Ejemplo1 para descripción detallada.

### `cambiar_estructura.m`
Script para cambiar entre estructuras Desc/Spar/Full.

### `data_run_lazo_abierto_simulink.m`
Script para correr simulaciones de lazo abierto.

---

## Archivos de Datos (`.mat`)

| Archivo | Descripción |
|---|---|
| `G_modelo_desc_v*.mat`, `G_modelo_spar_v*.mat`, `G_modelo_full_v*.mat` | Modelos de funciones de transferencia del proceso. |
| `salida_pt_op_desc.mat`, `salida_pt_op_spar.mat`, `salida_pt_op_full.mat` | Puntos de operación por estructura. |
| `D_desc_v1.mat`, `D_spar_v1.mat`, `D_full_v1.mat` | Modelos de perturbaciones. |
| `Gc1_desc_simplificado.mat`, `Gc1_spar_simplificado.mat`, `Gc1_full_simplificado.mat` | Controladores simplificados. |
| `dynamic_inter_*.mat` | Estados estacionarios de intercambiadores. |

---

## Archivos de Simulación (`.slx`)

| Archivo | Descripción |
|---|---|
| `Red_problema6.slx` | Red a lazo abierto. |
| `Red_problema6_imc.slx` | Red a lazo cerrado con controlador IMC. |
| `Red_problema6_PID.slx` | Red a lazo cerrado con controladores PID. |
| `Red_problema6_Kclasica.slx` | Red a lazo cerrado con controlador clásico. |
| `Red_problema6_rndm.slx` | Red a lazo abierto con entradas de tren de pulsos aleatorio. |

---

## Figuras de Validación

Archivos `s__validacion.fig` — 11 figuras correspondientes a cada variable manipulada (`u1`–`u11`).
