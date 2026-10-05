#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(Seurat))
obj <- readRDS("data/processed/object_mitochondrial.rds")
Idents(obj) <- obj$ADdiag3types

# NOTE: Cell-level Wilcoxon treats correlated cells as independent observations.
# TODO: Aggregate counts by donor x region x cell state and rerun with a pseudobulk model.
de <- FindMarkers(obj, ident.1 = "lateAD", ident.2 = "nonAD",
                  min.pct = 0.1, logfc.threshold = 0.25,
                  test.use = "wilcox")
de$gene <- rownames(de)
de <- de[order(de$p_val_adj, -abs(de$avg_log2FC)), ]
dir.create("results/tables", recursive = TRUE, showWarnings = FALSE)
write.csv(de, "results/tables/DEG_lateAD_vs_nonAD_cell_level.csv", row.names = FALSE)
message("Exploratory cell-level differential expression written.")
message("Interpretation must account for donor-level replication in later validation.")
