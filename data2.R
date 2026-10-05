#!/usr/bin/env Rscript

# This script documents the data source and validates local input paths.
# Large files are intentionally kept out of Git history.

required_dirs <- c("data/raw", "data/processed", "results/figures", "results/tables")
for (d in required_dirs) if (!dir.exists(d)) dir.create(d, recursive = TRUE)

message("Data source: GSE227223")
message("Expected local files: data/raw/counts.rds and data/raw/meta.rds")
if (file.exists("data/raw/counts.rds") && file.exists("data/raw/meta.rds")) {
  message("Local inputs found.")
} else {
  message("Inputs not found. See data/README.md for provenance and download links.")
}
