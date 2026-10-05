#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(Seurat)
  library(ggplot2)
})
obj <- readRDS("data/processed/object_annotated.rds")

mt_genes <- grep("^MT-", rownames(obj), value = TRUE)
if (length(mt_genes) < 5) stop("Too few mitochondrial genes detected")
obj <- AddModuleScore(obj, features = list(mt_genes), name = "mitochondrial_score")

dir.create("results/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("results/tables", recursive = TRUE, showWarnings = FALSE)

summary_disease <- aggregate(cbind(percent.mt, mitochondrial_score1) ~ ADdiag3types,
                             data = obj[[]], FUN = median)
write.csv(summary_disease, "results/tables/mitochondrial_by_disease.csv", row.names = FALSE)

png("results/figures/mitochondrial_score_by_disease.png", width = 1800, height = 1200, res = 180)
print(VlnPlot(obj, features = c("percent.mt", "mitochondrial_score1"), group.by = "ADdiag3types", pt.size = 0, ncol = 2))
dev.off()

genes_to_plot <- intersect(c("MT-ND1", "MT-ND2", "MT-CO1", "MT-CO2", "MT-CO3", "MT-CYB", "MT-ATP6"), rownames(obj))
png("results/figures/mitochondrial_gene_dotplot.png", width = 1800, height = 1200, res = 180)
print(DotPlot(obj, features = genes_to_plot, group.by = "ADdiag3types") + RotatedAxis())
dev.off()

saveRDS(obj, "data/processed/object_mitochondrial.rds", compress = FALSE)
message("Mitochondrial scores and figures written.")
