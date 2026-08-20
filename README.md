# Mechanical-Properties-Analyzers
MATLAB scripts for processing and analyzing mechanical testing data (converting raw force-stroke to stress-strain curves) from various testing methods (3-Point bending, Tensile Test, Compressive Test). The idea of this repository is to store a few scripts made to process xlsx or csv files obtained by different mechanical testing methods and extract the respective stress-strain curves and relevant mechanical properties (0.2% Offset YieldN Strength, UTS, Ductility/Elongation percentage, Young's Modulus and Fracture Point).

## Repository Structure
The repository is composed of folders according to each testing method, where each folder contains:
- **Analysis script:** The script for mechanical properties analysis.
- **Simulation script:** A script for simulating a raw data spreadsheet.
- **Simulated spreadsheet:** A pre-generated raw data spreadsheet obtained from running the simulation script.

## Requirements
- **MATLAB** R2020b or later.
- **Toolboxes:** Optimization Toolbox recommended for numerical fitting.
