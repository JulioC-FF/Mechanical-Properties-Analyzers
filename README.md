# Mechanical-Properties-Analyzers
MATLAB scripts for processing and analyzing mechanical testing data (converting raw force-stroke to stress-strain curves) from various testing methods (3-Point bending, Tensile Test, Compressive Test). The idea of this repository is to store a few scripts made to process xlsx or csv files delivered by different mechanical testing methods and delivering the respective stress-strain curves and relevant mechanical properties (0.2% Offset Yielding Strength, UTS, Ductilty/Elongation percentage, Young's Modulus and fracture point).

## Repository Structure
The repository is composed by folders according to each testing method, each folder contains:
- The script for mechanical properties analysis.
- A script for simulating a raw data spreadsheet.
- A pre-generated spreadsheet obtained from running the simulation script.


## Requirements
**MATLAB** MATLAB R2020b or later.
**Toolboxes:** Optimization Toolbox recommended for numerical fitting.
