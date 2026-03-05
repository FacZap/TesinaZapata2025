# Ejemplo7 — Descripción Detallada

---

## Scripts Principales de Control

### `SUPER_SCRIPT_7.m`
Script batch principal que ejecuta todas las simulaciones del problema 7. Verifica carpeta correcta y ejecuta 12 simulaciones: 3 estructuras (Desc/Spar/Full) × 4 perturbaciones (a/b/c/d). Para cada simulación: limpia variables, llama `script_desc`/`script_spar`/`script_full`, define filtro IMC (`filt=100`), ejecuta `imc_d`/`imc_s`/`imc_f`, define perturbaciones (`d_temp`, `d_flow`), corre `sim('Red_problema7_imc_v2021.slx')`, llama `univ_plotter`, `save_univ_plotter`, `indices_universales`, y guarda métricas. Al final genera timestamp y guarda datos en `SUPER_SCRIPT_DATA_timestamp.mat`.

### `script_IMC_ej7.m`
Script base para diseño de controladores IMC. Carga modelo `G_modelo`, selecciona columnas según estructura:
- **Desc:** `8, 9, 10, 11`
- **Spar:** `5, 9, 10, 11`
- **Full:** `2, 8, 9, 10`

Reordena para diagonalización, elimina elementos que deben ser cero (`Gd(1,2,4,3)=0`, `Gs(1,3)=0`), aplica Teorema de García-Morari, define filtros (`filt=10`, más agresivo que Ej6), calcula `Kimc_u = G⁻¹ × F_d`, deriva `K_clasica`, y setea `switch_var` (`0=Desc`, `1=Spar`, `2=Full`) junto con parámetros `aE` de áreas.

### `script_PID_ej7.m`
Script para calcular controladores PID usando `IMC_Controladores_HEN`.

### `script_desc.m` / `script_spar.m` / `script_full.m`
Scripts específicos por estructura. Llaman `ini_comun`, setean `RIC=7`, definen `nominales_u` específicos, cargan modelos `G_modelo` y `salida_pt_op`, inicializan entradas y áreas (`ej7`), calculan IMC con filtros específicos (`filt=100`), calculan PID, y setean `select_area`.

---

## Inicialización

### `ini_comun.m`
Script de inicialización común. Similar a Ej6 pero con diferencias clave: `sim_time=30000` (vs `60000`) y `t_step=2000` (vs `20000`). Define datos de corrientes (`Thin1=543K`, `Thin2=493K`, `Tcin1=323K`, `Tcin2=433K`), setpoints y flujos nominales.

### `script_ini_ej7.m`
Inicialización específica para Ejemplo7.

### `inicializar_areas_ej7.m`
Script que define áreas de intercambiadores para cada estructura. Diferencias principales respecto a Ej6:
- Valores de `aE` distintos (`aEhu2=81.14` vs `53.1` en Ej6)
- Asigna variables adicionales: `aE1`, `aE2`, `aE3`, `aE4` según estructura
- **Desc:** usa `a112_d`, `a121_d`, `a213_d`, `a222_d`
- **Spar:** usa `a112_s`, `a121_s`, `a213_s`, `a222_s`
- **Full:** usa `a112_f`, `a121_f`, `a213_f`, `a222_f`

### `inicializar_entradas_ej7.m`
Inicializa valores de entrada `u1`–`u11` y perturbaciones `d1`–`d8`. Asigna `initials(i)` a `u*_in`/`u*_end`, y `0` a `d*in`/`d*end`.

---

## Validación y Visualización

### `validacion.m`
Script de validación. Itera sobre cada VM (`u1`–`u11`), aplica cambio escalón, ejecuta `sim('Red_problema6')`, llama `save_plot_validacion`. Parámetros: `t_step=500`, `sim_time=3000`.

### `save_plot_validacion.m`
Script para guardar figuras de validación. Genera figura con 4 subplots (`Th_o1`, `Th_o2`, `Tc_o1`, `Tc_o2`), grafica salida (rojo), setpoint (verde) y salida adicional (negro, columnas 5–8), y guarda como `area_u_selected_validacion.fig`.

### `vm_plot.m`
Script flexible para graficar según `vm_plot_number`. Quedó en desuso tras la creación de `univ_plotter.m`.

---

## Análisis RGA

### `script_RGA.m`
Compartido con Ej6. Script de análisis RGA exhaustivo para selección de variables de control. Ver Ejemplo6 para descripción detallada.

---

## Otros Scripts

### `script_build_tfs.m` / `build_tfs_d.m`
Funciones para construir modelos de funciones de transferencia del proceso y perturbaciones. Ver Ejemplo6 para descripción detallada.

### `todo_nom_desc.m` / `todo_nom_spar.m` / `todo_nom_full.m`
Scripts que setean valores nominales según estructura para Ej7.

### `todo_in.m`
Script simple que setea todas las entradas y perturbaciones a `0` o valores iniciales.

### `pert_max.m`
Definiciones de perturbaciones máximas toleradas.

---

## Diferencias Clave entre Ej6 y Ej7

| Aspecto | Ejemplo6 | Ejemplo7 |
|---|---|---|
| Filtro IMC | `filt=300` | `filt=100` |
| `sim_time` | `60000` | `30000` |
| `t_step` | `20000` | `2000` |
| Columnas Desc | `2, 9, 10, 11` | `8, 9, 10, 11` |
| Columnas Spar | `3, 8, 9, 10` | `5, 9, 10, 11` |
| Modelo Simulink | `Red_problema6_imc.slx` | `Red_problema7_imc_v2021.slx` |

---

## Archivos de Datos (`.mat`)

| Archivo | Descripción |
|---|---|
| `G_modelo_desc_v1.mat`, `G_modelo_spar_v1.mat`, `G_modelo_full_v1.mat` | Modelos de funciones de transferencia del proceso. |
| `salida_pt_op_desc.mat`, `salida_pt_op_spar.mat`, `salida_pt_op_full.mat` | Puntos de operación por estructura. |
| `D_desc_v1.mat`, `D_spar_v1.mat`, `D_full_v1.mat` | Modelos de perturbaciones. |
| `Gc1_desc_simplificado.mat`, `Gc1_spar_simplificado.mat`, `Gc1_full_simplificado.mat` | Controladores PI simplificados. |
| `dynamic_inter_*.mat` | Estados estacionarios de intercambiadores. |
| `xInitial.mat` | Estado inicial del sistema. |
| `data_ini.mat` | Datos de inicialización. |

---

## Archivos de Simulación (`.slx`)

| Archivo | Descripción |
|---|---|
| `Red_problema7_imc_v2021.slx` | Red a lazo cerrado con controlador IMC. |
| `Red_problema7_Kclasica.slx` | Red a lazo cerrado con controlador clásico. |
| `Red_problema7_lazo_abierto_v2021.slx` | Red a lazo abierto. |
