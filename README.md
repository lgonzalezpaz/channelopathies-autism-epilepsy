# Sodium-Channelopathies-ASD-DEE

Code, empirical datasets, and derived results for:

> González-Paz L., Alvarado Y.J., Quintero M., Cardozo-Urdaneta A., Lossada C., Marrero-Ponce Y., Martinez-Rios F., Pérez-Castillo Y., Delgado A.  
> **Cell-type-specific biophysical modeling reveals modifier-dependent phenotypic divergence in sodium channelopathies: a computational framework for the autism-epilepsy spectrum.** (2026, submitted)

This study addresses the central dilemma in excitable membrane channelopathies: **how the same pathogenic mutation in a voltage-gated sodium channel (*SCN1A*, *SCN2A*, *SCN8A*) produces autism spectrum disorder (ASD) in some individuals and severe developmental and epileptic encephalopathy (DEE) or intellectual disability (ID) in others.**

While canonical frameworks classify mutations into a binary gain-of-function (GOF) versus loss-of-function (LOF) dichotomy, recent clinical cohorts demonstrate that electrophysiological LOF mechanisms do not predict the presence, onset, or severity of epilepsy. This repository establishes a multiscale biophysical and transcriptomic framework that confronts three interdependent levels of regulation:

| Level of Regulation | Biophysical Mechanism | Main Computational Tests & Metrics |
|---|---|---|
| **Cellular Stoichiometry** | Cell-type-specific $\alpha$-subunit distribution (excitatory pyramidal vs. inhibitory interneurons) | Transcriptomic normalization ($E_{\text{norm}}$, Eq. 5), weighted conductance scaling ($\bar{g}_{\text{Na}, c}$, Eq. 6), Excitability Perturbation Index ($\text{EPI}_c$, Eq. 7) |
| **Kinetic Microheterogeneity** | Non-inactivating persistent sodium currents ($I_{\text{NaP}}$) vs. transient gating shifts ($\Delta V_{1/2,\text{act}}$) | 2D parametric sweeps, non-linear bifurcation boundary ($\text{PDI} = 0$), inversion of depolarizing LOF to DEE when $f_{\text{NaP}} \ge 6\%$ |
| **Epistatic Modifier Buffering** | Postsynaptic GABAergic sensitivity (*Gabra2*) and low-threshold calcium channels (*Cacna1g*) | Modifier compensation factor ($\kappa_{\text{GABA}}$, Eq. 9), modified divergence index ($\text{PDI}_{\text{mod}}$, Eq. 11), mouse strain projection (B6 vs. 129S6) |

Everything runs on a standard laptop in **≈ 2–3 minutes** using freely available public datasets (no GPU, no specialized cluster required).

---

## Quick start

```bash
git clone https://github.com/lgonzalezpaz/Sodium-Channelopathies-ASD-DEE.git
cd Sodium-Channelopathies-ASD-DEE
conda env create -f environment.yml && conda activate sodium-channelopathies-asd-dee
# or: pip install -r requirements.txt
bash run_all.sh
```

`run_all.sh` verifies input checksums (`data/checksums.sha256`) and executes the full pipeline, regenerating every result table (`results/`), publication figure (`figures/`), and the Supplementary Data workbook (`results/Supplementary_Data.xlsx`).

---

## Pipeline

| Script | Purpose | Main Outputs |
|---|---|---|
| `code/00_download_data.py` | Validates local raw input datasets and verifies cryptographic SHA-256 hashes | `data/checksums.sha256` |
| `code/01_biophysical_model.py` | Single-cell action potential simulations and rheobase thresholding | Terminal diagnostics |
| `code/02_stoichiometry_and_expression.py` | HPA tissue nTPM and single-cell nCPM stoichiometric normalization ($E_{\text{norm}}$, Eq. 5) | `results/Table1_regional_expression.tsv`, `results/Table4_single_cell_excitability.tsv` |
| `code/03_parametric_sweeps.py` | 2D sweeps across $\Delta V_{1/2,\text{act}}$ and $f_{\text{NaP}}$; computes bifurcation manifold | `results/Table3_2d_parametric_landscape_pdi.tsv`, `results/fine_grid_pdi_landscape.tsv` |
| `code/04_phenotypic_divergence.py` | Simulates canonical SCN2A GOF and LOF variants; computes $\text{EPI}_c$ and $\text{PDI}$ | `results/Table2_gof_excitability_divergence.tsv` |
| `code/05_modifier_epistasis.py` | Models epistatic buffering by *Gabra2* and *Cacna1g* across Dravet mouse strains | `results/Table5_modifier_buffering_dravet.tsv` |
| `code/06_sensitivity_analysis.py` | Global variance decomposition (first-order $S_i$ and total-order $S_{Ti}$ Sobol indices) | `results/Table7_sobol_sensitivity.tsv` |
| `code/08_supplementary_tables.py` | Parses BrainSpan ontogeny (Table 6) and creates the Excel Supplementary Data workbook | `results/Table6_ontogenetic_brainspan.tsv`, `results/Supplementary_Data.xlsx` |
| `code/07_figures.py` | Generates publication-ready figures (Figures 1–5, S1) in vector PDF and 300-dpi PNG | `figures/Figure1`–`Figure5`, `figures/FigureS1` |
| `code/biophys.py` | Core mathematical library implementing Equations 1–11 of the manuscript | — |

---

## Data sources

| Data | Description | Source / Reference |
|---|---|---|
| **Regional Brain Expression (nTPM)** | RNA-seq consensus tissue metrics for cortex, thalamus, hippocampus, and cerebellum | The Human Protein Atlas (v23); Uhlén et al. 2015, *Science* 347:1260419; proteinatlas.org |
| **Single-Cell Transcriptomics (nCPM)** | Single-cell scRNA-seq expression across pyramidal, interneuron, and glial lineages | The Human Protein Atlas (v23); proteinatlas.org |
| **Developmental Ontogeny (RPKM)** | Temporal trajectory across 5 human neurodevelopmental epochs (8 pcw to 40 yrs) | BrainSpan Atlas of the Developing Human Brain; Li et al. 2018, *Science* 362:eaat7615; brainspan.org |
| **Epistatic Modifier Ratios** | *Gabra2* and *Cacna1g* quantitative expression in C57BL/6J and 129S6 strains | Hawkins et al. 2016, *PLoS Genet* 12:e1006398; Rubinstein et al. 2015, *PLoS Genet* 11:e1005596 |
| **Biophysical Patch-Clamp Parameters** | Calibrated $V_{1/2}$, slope factors, and persistent currents for WT, GOF, and LOF channels | Ben-Shalom et al. 2017, *Biol Psychiatry* 82:224; Liu et al. 2019, *Brain* 142:376; Hodgkin & Huxley 1952 |

No new human or animal experiments were performed; all inputs derive from publicly available, de-identified databases and verified electrophysiological literature.

---

## Key Reproducibility Benchmarks

The execution of the pipeline verifies the following exact numerical milestones:
- **Regional Stoichiometry (Table 1):** Cerebral cortex maintains balanced parity between *SCN1A* ($48.7\ \text{nTPM}$, $E_{\text{norm}} = 0.812$) and *SCN2A* ($46.2\ \text{nTPM}$, $E_{\text{norm}} = 0.770$), whereas thalamus exhibits severe total sodium channel scarcity ($85.0\ \text{nTPM}$ vs. $136.4\ \text{nTPM}$ in cortex, $P = 0.0028$).
- **Cell-Type Asymmetry (Table 4):** Excitatory neurons express $332.6\ \text{nCPM}$ *SCN2A* vs. $98.4\ \text{nCPM}$ *SCN1A*; inhibitory interneurons express $382.1\ \text{nCPM}$ *SCN1A* vs. $64.5\ \text{nCPM}$ *SCN2A*.
- **SCN2A GOF vs. LOF Divergence (Table 2):** GOF-3 variant increases pyramidal firing to $61.8\ \text{Hz}$ ($\text{EPI}_{\text{Exc}} = +1.082$) with minimal interneuron effect ($\text{EPI}_{\text{Inh}} = +0.131$), driving $\text{PDI} = +0.430$ (severe DEE). In contrast, LOF-1 haploinsufficiency selectively suppresses pyramidal firing to $34.4\ \text{Hz}$ ($\text{EPI}_{\text{Exc}} = -0.205$), yielding $\text{PDI} = -0.147$ (ASD spectrum).
- **Non-Linear LOF Inversion (Table 3):** Under a depolarizing shift of $+4.0\ \text{mV}$, elevating persistent current from $f_{\text{NaP}} = 1\%$ to $10\%$ completely flips $\text{PDI}$ from $-0.144$ (ASD) to $+0.208$ (DEE).
- **Epistatic Modifier Rescue (Table 5):** Under *SCN1A* haploinsufficiency ($\alpha_{1A} = 0.50$), low *Gabra2* reserve ($0.50\times$, B6 background) yields $\text{PDI}_{\text{mod}} = +0.368$ (lethal status epilepticus), whereas 2.0-fold *Gabra2* upregulation (129S6 background) yields $\text{PDI}_{\text{mod}} = -0.284$ (seizure-free state).
- **Sobol Variance Decomposition (Table 7):** Persistent current fraction ($S_{Ti} = 0.442$) and cellular subunit weighting ($S_{Ti} = 0.365$) account for over $68\%$ of divergence variance.

---

## Licence

- **Code:** MIT License (`LICENSE`).
- **Derived data, results tables, and figures:** Creative Commons Attribution 4.0 International License (CC BY 4.0, `LICENSE-DATA`).
- **Third-party input datasets:** Retain original licensing from respective providers (The Human Protein Atlas, BrainSpan).

---

## Citation

Please cite `CITATION.cff` and the associated manuscript:

```bibtex
@article{gonzalezpaz2026channelopathies,
  title={Cell-type-specific biophysical modeling reveals modifier-dependent phenotypic divergence in sodium channelopathies: a computational framework for the autism-epilepsy spectrum},
  author={Gonz{\'a}lez-Paz, Lenin and Alvarado, Ysa{\'i}as J. and Quintero, M{\'a}ximo and Cardozo-Urdaneta, Arlene and Lossada, Carla and Marrero-Ponce, Yovani and Martinez-Rios, F{\'e}lix and P{\'e}rez-Castillo, Yunierkis and Delgado, Ariana},
  journal={Submitted},
  year={2026}
}
```
