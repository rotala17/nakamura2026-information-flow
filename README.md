# nakamura2026-information-flow

This repository contains the code and data used to generate figures for:

**Nakamura, K., Fukuoka, H., Ishijima, A., Kobayashi, T.J.** "Quantification of Information Flow by Dual Reporter System and Its Application to Bacterial Chemotaxis" (2025) [arXiv:2506.15957](
https://doi.org/10.48550/arXiv.2506.15957).

## Repository Structure

```
├── note/                    # Jupyter notebooks for figure generation
├── data/                    # Precomputed data files
├── raw_data/                # Experimental data files
├── figure/                  # Generated figures output
├── src/                     # Simulation code
├── Project.toml            # Julia project dependencies
├── Manifest.toml           # Julia dependency manifest
└── README.md               # This file
```

## Generating Figures

All figures can be reproduced by running the corresponding Jupyter notebooks in the `note/` directory:

| Figure | Notebook |
|--------|----------|
| Figure 1,S4-S8 | `Fig1.ipynb` |
| Figures 2,S2,S3 | `Fig2.ipynb` |

## Data Generation

Data is generated directly within the figure notebooks when you run them. Some cells include computational time information as comments based on the specified hardware environment.

## Usage

1. Clone this repository
2. Open any notebook in the `note/` directory
3. Run the first cell to install dependencies:
   ```julia
   using Pkg
   Pkg.activate("../Project.toml")
   Pkg.instantiate()
   ```
4. Run the remaining notebook cells in order to generate figures and data

## Requirements

- Julia
- Jupyter Notebook with IJulia kernel
- Dependencies specified in `Project.toml` and `Manifest.toml` (automatically installed via first notebook cell)

## Computational Environment

This analysis was performed using:
- **Julia version**: v1.11.6
- **Platform**: macOS Sonoma 14.1.2
- **Hardware**: MacBook Pro 2021 with Apple M1 Max chip, 64 GB memory

*Note: While the code should work on other platforms and Julia versions, results may vary slightly due to numerical precision differences.*
