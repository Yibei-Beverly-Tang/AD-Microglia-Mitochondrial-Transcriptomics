# Mitochondrial transcripts in AD-associated microglia

## Question

Do mitochondrial transcript features in human microglia differ across non-AD, early-AD, and late-AD groups?

## Data

The project uses the processed matrix and metadata from Sun et al., *Human Microglial State Dynamics in Alzheimer's Disease Progression*.

- GEO: GSE227223
- Matrix: 16,228 genes by 174,420 cells or nuclei
- Metadata: 425 donors, six brain regions
- Groups: non-AD 94,705; early-AD 49,743; late-AD 29,972 cells or nuclei
- Source links and input instructions: data/README.md

The large matrix is not included in the repository. The six source papers are mapped to the project in docs/literature_context.md.

## Analysis

1. Match matrix columns to metadata rows.
2. Calculate standard RNA metrics and the fraction of reads assigned to MT- genes.
3. Score four microglial marker modules.
4. Compare mitochondrial transcript fractions and scores across AD groups.
5. Run an exploratory late-AD versus non-AD cell-level differential expression test.
6. Run GO Biological Process enrichment on the upregulated genes.

Scripts are numbered in execution order. Figures are in results/figures and tables are in results/tables.

## Preliminary result

Median percent.mt is 0.534% in non-AD, 0.545% in early-AD, and 0.692% in late-AD. The exploratory late-AD gene list is enriched for cellular respiration, electron transport chain, and oxidative phosphorylation terms.

This is cell-level analysis. Treat the p values as exploratory; the next comparison should aggregate counts by donor, region, and cell state before DESeq2. The current result describes a change in mitochondrial transcript fraction. It does not measure mtDNA mutation, heteroplasmy, copy number, or respiratory activity.

## Reproduce

Install Seurat, Matrix, ggplot2, clusterProfiler, and org.Hs.eg.db. Put counts.rds and meta.rds in data/raw, then run:

    Rscript scripts/00_dataset_inventory.R
    Rscript scripts/01_download_data.R
    Rscript scripts/02_quality_control.R
    Rscript scripts/03_cell_annotation.R
    Rscript scripts/04_mitochondrial_analysis.R
    Rscript scripts/05_differential_expression.R
    Rscript scripts/06_pathway_enrichment.R

01_download_data.R checks the local input files. It does not download them. 07_make_final_figures.R is reserved for later figure assembly.

## Next analysis

Aggregate counts by donor x brain region x cell state and fit a pseudobulk model with DESeq2. Include age, sex, brain region, and sequencing batch when those variables are available. Test the workflow on an independent dataset before treating the signal as reproducible.

## Working notes

- The first marker-scoring run failed because the object did not contain the normalized data layer. Running NormalizeData before AddModuleScore fixed the error.
- A first saved QC object used xz compression and was not readable in the target setup. The pipeline now writes the object without that compression setting.
- No cell-level QC filter has been applied yet. The current QC output shows distributions; thresholds should be chosen after checking sample and batch structure.
- The released seurat_clusters are retained. This pass adds module scores and does not claim a new cell-state taxonomy.
