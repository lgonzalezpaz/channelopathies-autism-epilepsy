#!/usr/bin/env bash
# Reproduce every result, table, and figure of the study (about 2-3 min on a standard laptop).
set -euo pipefail
cd "$(dirname "$0")"

echo "======================================================================"
echo " Running Full Pipeline: Sodium-Channelopathies-ASD-DEE"
echo "======================================================================"

python code/00_download_data.py               # Data ingestion & SHA-256 verification
python code/01_biophysical_model.py           # Single-cell AP simulation & rheobase
python code/02_stoichiometry_and_expression.py # Tables 1 & 4 (HPA nTPM & nCPM)
python code/03_parametric_sweeps.py           # Table 3 (2D PDI landscape & bifurcation)
python code/04_phenotypic_divergence.py       # Table 2 (SCN2A GOF & LOF excitability)
python code/05_modifier_epistasis.py          # Table 5 (Gabra2 & Cacna1g buffering)
python code/06_sensitivity_analysis.py        # Table 7 (Sobol global sensitivity)
python code/08_supplementary_tables.py        # Table 6 (BrainSpan ontogeny) & Excel workbook
python code/07_figures.py                     # Figures 1-5 & S1 (PDF + 300-dpi PNG)

echo "======================================================================"
echo " Done. All results saved in results/, all figures in figures/."
echo "======================================================================"
