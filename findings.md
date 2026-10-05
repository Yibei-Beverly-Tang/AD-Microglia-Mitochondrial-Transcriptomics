# Preliminary findings

The analysis uses the processed GSE227223 count matrix and metadata.

| Metric | Value |
| --- | ---: |
| Cells or nuclei | 174,420 |
| Donors | 425 |
| Brain regions | 6 |
| Non-AD cells or nuclei | 94,705 |
| Early-AD cells or nuclei | 49,743 |
| Late-AD cells or nuclei | 29,972 |

Median cell-level percent.mt was 0.534% in non-AD, 0.545% in early-AD, and 0.692% in late-AD samples. The values are reported in results/tables/mitochondrial_by_disease.csv.

The late-AD versus non-AD cell-level comparison included mitochondrial-encoded genes. The upregulated gene list was enriched for cellular respiration, electron transport chain, and oxidative phosphorylation terms. Results are available in results/tables/DEG_lateAD_vs_nonAD_cell_level.csv and results/tables/GO_lateAD_upregulated.csv.

These findings require donor-level analysis. The next analysis will aggregate counts by donor, brain region, and cell state before testing disease-group differences.
