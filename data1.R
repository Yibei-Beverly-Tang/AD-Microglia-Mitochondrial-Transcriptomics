#!/usr/bin/env Rscript

# Create small, non-expression summaries that are safe to review and version.
meta_path <- "data/raw/meta.rds"
if (!file.exists(meta_path)) stop("Missing data/raw/meta.rds")

meta <- readRDS(meta_path)
dir.create("results/tables", recursive = TRUE, showWarnings = FALSE)

summary <- data.frame(
  metric = c("cells", "subjects", "brain_regions", "nonAD_cells", "earlyAD_cells", "lateAD_cells"),
  value = c(
    nrow(meta),
    length(unique(meta$subject)),
    length(unique(meta$brainRegion)),
    sum(meta$ADdiag3types == "nonAD"),
    sum(meta$ADdiag3types == "earlyAD"),
    sum(meta$ADdiag3types == "lateAD")
  )
)
write.csv(summary, "results/tables/dataset_summary.csv", row.names = FALSE)

cluster_summary <- as.data.frame(table(meta$seurat_clusters, meta$ADdiag3types))
names(cluster_summary) <- c("cluster", "disease_group", "cells")
write.csv(cluster_summary, "results/tables/cluster_by_disease.csv", row.names = FALSE)

message("Wrote dataset inventory tables.")

