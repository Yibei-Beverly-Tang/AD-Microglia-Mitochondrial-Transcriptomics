#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(Seurat))
obj <- readRDS("data/processed/object_qc.rds")
obj <- NormalizeData(obj, normalization.method = "LogNormalize", scale.factor = 10000, verbose = FALSE)

# Marker basis: P2RY12/TMEM119/CX3CR1 for homeostatic microglia and APOE/TREM2/LPL for disease-associated microglia, following published microglia state definitions.
# No marker discovery is performed here; the released clusters remain the reference.
# The released metadata already contains the authors' cluster assignment.
# We preserve it and add transparent marker-based module scores rather than
# relabeling clusters as disease states without independent validation.
marker_sets <- list(
  homeostatic = intersect(c("P2RY12", "TMEM119", "CX3CR1", "C1QA", "C1QB", "C1QC"), rownames(obj)),
  disease_associated = intersect(c("APOE", "TREM2", "LPL", "CST7", "TYROBP", "GPNMB"), rownames(obj)),
  inflammatory = intersect(c("IL1B", "CCL3", "TNF", "NFKBIA", "CD83"), rownames(obj)),
  lipid_processing = intersect(c("APOE", "LPL", "ABCA1", "GPNMB", "FABP5", "CD9"), rownames(obj))
)
for (nm in names(marker_sets)) {
  if (length(marker_sets[[nm]]) >= 2) obj <- AddModuleScore(obj, features = list(marker_sets[[nm]]), name = paste0(nm, "_score"))
}

dir.create("results/figures", recursive = TRUE, showWarnings = FALSE)
png("results/figures/cluster_markers.png", width = 1800, height = 1200, res = 180)
print(DotPlot(obj, features = unique(unlist(marker_sets))) + RotatedAxis())
dev.off()

saveRDS(obj, "data/processed/object_annotated.rds", compress = FALSE)
message("Annotation object written. Cluster labels remain traceable to the source metadata.")
