# Piezoelectric Energy Harvesting: MATLAB/Simscape, LTspice, and PCB Models

Simulation, circuit and PCB design repository for investigating **piezoelectric energy harvesting (PEH)** interfaces under conventional vibration excitation and underwater acoustic excitation.

The work in this repository progresses from analytical/Simscape validation of standard piezoelectric harvesting interfaces to component-level LTspice simulations and PCB development.

---

## Repository overview

```text
piezo_matlab/
├── matlab/      MATLAB + Simulink/Simscape modeling and analysis
├── spice/       LTspice circuit models, component sweeps, and transformer sweeps
├── pcb/         KiCad PCB design and imported component libraries
```

---

# MATLAB / Simscape

Directory:

```text
matlab/
```

This has the higher level Simscape analysis which was best for numerical equations/ waveform comparisions and exact ideal switching.

It contains the piezoelectric equivalent circuit, SEH/ P-SSHI/ S-SSHI interface variants, waveform processing, equivalent-impedance calculations, paper-equation comparisons, power calculations, and load sweeps.

## `matlab/main.m`

**The main MATLAB analysis script.**

It:

1. chooses the harvesting interface (`SEH`, `PSSHI`, or `SSSHI`);
2. chooses the switching implementation (`Switch`, `BJT`, or `NoSwitch`);
3. selects the Liang/Liao vibration benchmark or underwater equivalent model;
4. calculates the equivalent source parameters and open-circuit voltage;
5. runs `simscape_model.slx`;
6. extracts steady-state signals;
7. isolates one final steady-state cycle;
8. fits the fundamental components of `vp` and `ieq`;
9. calculates `Zelec_sim = Vp,F / Ieq,F`;
10. calculates the corresponding Liang/Liao analytical impedance;
11. decomposes the electrical impedance into `Rh`, `Rd`, and `XE`;
12. calculates harvested and extracted power;
13. measures SSHI switching timing;
14. performs an `Rload` sweep;
15. finds the optimum load; and
16. produces waveform, impedance, and power plots.

### Main inputs

Set these before calling `main`, test scipt with these parameters in `matlab/tests/`:

```matlab
clear; clc; close all;
f_test = 42;
CrossCircuitTest = "Switch";
Type_test = "PSSHI";
WindingRatio_test = 1.0;

main;
```

**Important:** Setting CrossCircuitTest to "BJT" or "NoSwitch" is only for P-SSHI, for "SEH" and "S-SSHI" you must set CrossCircuitTest="Switch" or it will result in errors.

| Variable            | Meaning                                                        |
| ------------------- | -------------------------------------------------------------- |
| `f_test`            | Excitation frequency in Hz                                     |
| `Type_test`         | `"SEH"`, `"PSSHI"`, or `"SSSHI"`                               |
| `CrossCircuitTest`  | `"Switch"`, `"BJT"`, or `"NoSwitch"`                           |
| `WindingRatio_test` | Transformer secondary/primary winding ratio, set to 1 for none |

Inside `main.m`:

```matlab
useUnderwaterPaperModel = false;
```

Use `false` for the Liang/Liao vibration benchmark and `true` for the underwater acoustic equivalent model.

```matlab
fast_mode = true;
```

Use fast_mode `true` for running sim faster but slightly less accuracy.

```matlab
useNewModel = false;
```

This selects between the two equivalent underwater formulations used during development.

```matlab
SPL_dB = 230;
```

This sets the decibels sound level for the underwater model.

---

## `matlab/simscape_model.slx`

The main **Simulink/Simscape physical model**.

It contains the base piezo model and variants used for:

- SEH
- S-SSHI ideal synchronized switching
- P-SSHI ideal synchronized switching
- P-SSHI BJT/self-powered switching
- Inductor only in parallel Cp configuration
- transformer/matching configurations
- rectification
- storage capacitor and load

Signals read back by the MATLAB code include:

```text
vp_sim       piezoelectric terminal voltage
vcap_sim     switching capacitor voltage in BJT switching circuit
vstore_sim   rectified/storage voltage
ieq_sim      equivalent source current
irect_sim    rectifier current
ip_sim       interface current
flip_sim     ideal switch control signal
iL1_sim      SSHI inductor-branch current 1
iL2_sim      SSHI inductor-branch current 2
```

---

## `matlab/MyUtils.m`

Static utility class used by the main analysis.

It contains reusable functions for:

- reading Simulink signals;
- converting signal formats to time/data vectors;
- cleaning simulation data;
- extracting fundamental harmonic amplitude and phase;
- measuring open-circuit voltage;
- estimating rectifier conduction/blocked angle;
- zero-crossing detection;
- SSHI switch timing;
- underwater equivalent-circuit calculations; and
- simulation/result-processing helpers.

---

## `matlab/GetFiguresData.m`

Exports numerical data from open MATLAB figures to `Fig.mat`.

---

## `matlab/RegenFigure.m`

Reconstructs a waveform plot from `Fig.mat`.

---

## Generated MATLAB files

The `*.asv`, `*.slxc` and `slprj/` are generated/autosave files.

---

# LTspice

Directory:

```text
spice/
```

LTspice is used for faster component-level testing after the system-level Simscape work.

It is especially useful for:

- real semiconductor models
- large component sweeps
- diode/transistor comparisons
- transformer primary inductance/ turns ratio/ winding resistance
- practical switching circuits
- low-voltage underwater cases
- faster simulations and prototyping
- series and parallel testing

## `spice/peh.asc`

Main LTspice PEH schematic with self-powered PSSHI, transformer impedance matching, component sweeps and resistor/ inductor/ capacitor value sweeps.

Contains spice directives that include some \*.lib files for the equivalent model/ sweeps and also some direct code for PSSHI specific values, transformer with and without extra capacitor settings and single-run components.

Can go to previous commits for the parallel/ series circuit, active switching circuit and other tests.

---

## `spice/equiv_model.lib`

Defines the underwater piezoelectric equivalent source.

Main parameters:

```spice
* materialSel: 1 = PZT, 2 = PVDF
.param materialSel=1

* modelSel: 0 = old/original, 1 = updated Eq. (28)-(32)
.param modelSel=0

* Number of identical piezoelectric elements
.param N=1

* Piezo area, dB level and frequency
.param A=2e-3
.param SPL_dB=230
.param f=42
```

Similar to MATLAB/Simscape this spice library calculates:

```text
Req
Ceq
Leq
Cp
Veq
Voc
Zout
```

It also supports `N` identical piezos in series or parallel.

The current spice simulation doesn't contain this circuit configuration, can add it or go to previous commit [1a77436](https://github.com) or [c0e669c](https://github.com) (which also contains different configurations with series/parallel after individual rectifiers).

For series:

```text
Req_eqS → N Req
Leq_eqS → N Leq
Ceq_eqS → Ceq / N
Cp_eqS  → Cp / N
Veq_eqS → N Veq
```

For parallel:

```text
Req_eqP → Req / N
Leq_eqP → Leq / N
Ceq_eqP → N Ceq
Cp_eqP  → N Cp
Veq_eqP → Veq
```

---

#### `spice/transformer_sweep*.lib`, `component_sweep.lib`, `lowpow_sweep.lib`, `large_sweep.lib`, `combine_sweep.lib`

Real-transformer, NPN/PNP and diode sweeps.

#### `other_models.lib`, `tlv3691.lib`, `SSM3K35AFS_LTspice_20190314.mod`

Other non built-in custom defined models.

#### `cmp/` and `sym/`

Optional: Symlinks to default built-in LTspice component directories for easier direct viewing.

---

# PCB / KiCad

Directory:

```text
pcb/
```

## `pcb/PEH_PCB/`

Main KiCad project.

Important source files:

```text
PEH_PCB.kicad_pro   KiCad project containing general settings and metadata
PEH_PCB.kicad_prl   Local project settings
PEH_PCB.kicad_sch   Schematic
PEH_PCB.kicad_pcb   PCB layout
```

The directory also currently contains KiCad history, backup, and lock files.

```text
pcb/1035/
pcb/C0805C222F2GECTU/
pcb/R75GI410050H0J/
pcb/TIP31C/
pcb/TIP32C/
```

contain imported third-party items such as symbols, footprints and STEP / 3D models used in the main KiCad project.

---

# Software

- MATLAB Version 26.1 (R2026a)
- Simulink Version 26.1 (R2026a)
- Simscape Version 26.1 (R2026a)
- Simscape Electrical Version 26.1 (R2026a)
- LTspice XVII (64-bit), (17.0.37.0)
- KiCad: 10.0.5

