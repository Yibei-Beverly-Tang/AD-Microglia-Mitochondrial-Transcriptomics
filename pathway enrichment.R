#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(clusterProfiler)
  library(org.Hs.eg.db)
})
de <- read.csv("results/tables/DEG_lateAD_vs_nonAD_cell_level.csv")
# TODO: Set the GO universe to genes detected in this dataset rather than the full annotation.
# A p value of 0 is numerical underflow; floor only for display, not for the source table.
genes <- unique(de$gene[de$p_val_adj < 0.05 & de$avg_log2FC > 0.25])
mapped <- bitr(genes, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = org.Hs.eg.db)
if (nrow(mapped) == 0) stop("No genes could be mapped")
ego <- enrichGO(mapped$ENTREZID, OrgDb = org.Hs.eg.db, ont = "BP", readable = TRUE)
dir.create("results/tables", recursive = TRUE, showWarnings = FALSE)
write.csv(as.data.frame(ego), "results/tables/GO_lateAD_upregulated.csv", row.names = FALSE)
message("GO enrichment written.")
