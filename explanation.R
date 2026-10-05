#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(Seurat)
  library(Matrix)
})

counts <- readRDS("data/raw/counts.rds")
meta <- readRDS("data/raw/meta.rds")
stopifnot(identical(colnames(counts), rownames(meta)))

obj <- CreateSeuratObject(counts = counts, meta.data = meta, min.cells = 3)
# TODO: This pass plots QC distributions but does not filter cells.
# Choose thresholds only after checking sample and batch structure.
obj[["percent.mt"]] <- PercentageFeatureSet(obj, pattern = "^MT-")

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("results/figures", recursive = TRUE, showWarnings = FALSE)

png("results/figures/qc_violin.png", width = 1800, height = 1200, res = 180)
print(VlnPlot(obj, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"),
              ncol = 3, pt.size = 0))
dev.off()

saveRDS(obj, "data/processed/object_qc.rds", compress = FALSE)
qc_small <- obj[[]][, c("nCount_RNA", "nFeature_RNA", "percent.mt", "ADdiag3types", "brainRegion", "seurat_clusters"), drop = FALSE]
write.csv(qc_small, "results/tables/qc_metadata.csv")
message("QC object and figure written.")
