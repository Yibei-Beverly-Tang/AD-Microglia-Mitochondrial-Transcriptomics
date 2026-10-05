# Methods

## Input

data/raw/counts.rds is a sparse gene-by-cell or gene-by-nucleus count matrix. data/raw/meta.rds contains matching metadata. The inventory script checks that matrix column names and metadata row names match.

## Analysis steps

- 02_quality_control.R creates a Seurat object, calculates the fraction of transcripts from genes beginning with MT-, and writes a violin plot. No cell filter is applied in this version.
- 03_cell_annotation.R retains the released seurat_clusters and calculates four marker-module scores. It does not recluster or replace the released labels.
- 04_mitochondrial_analysis.R scores detected MT- genes and compares cell-level medians across ADdiag3types.
- 05_differential_expression.R compares late-AD and non-AD cells with Seurat FindMarkers using min.pct = 0.1 and logfc.threshold = 0.25.
- 06_pathway_enrichment.R tests GO Biological Process enrichment for genes with adjusted p < 0.05 and log2FC > 0.25.

## Definitions and limits

percent.mt = the fraction of measured RNA assigned to mitochondrial-encoded transcripts. It is not mitochondrial mass or respiratory activity. Nuclear preparation, cell damage, and ambient RNA can change this fraction.

The current QC output is descriptive. A later pass should inspect nFeature_RNA, library size, sample, and batch before selecting thresholds.

The differential expression test uses cells as the sampling units. Cells from one donor are correlated, so the p values are not donor-level evidence. The next model should aggregate counts by donor x region x cell state and use a pseudobulk method.

The GO test uses the current gene list. Its background is not yet restricted to genes detected in this dataset. The enrichment output is therefore exploratory.

A p value of 0 in exported tables is numerical underflow. It should be displayed as below machine precision in figures, while the source table should retain the computed value.
