# README: Processing Fungal Nanopore Sequences

## Overview
This document summarizes the workflow for processing fungal Nanopore sequencing data. The analysis includes demultiplexing, quality assessment, ITS region extraction, taxonomic classification, and post-processing to generate a curated dataset.

## 1. Preprocessing
- Demultiplexing and reverse-complementing are performed to correct read orientation and indexing issues.
- Cutadapt and SeqKit are used to process raw reads.
- A custom Python script automates these steps and outputs demultiplexed FASTQ files.

## 2. Read Quality Assessment
- Nanopore sequencing quality scores differ from traditional Phred scores and are estimated from the basecalling model.
- Quality scores are extracted and visualized to assess sequencing performance.

## 3. ITS Region Extraction and Trimming
- ITSxpress is used to extract the full ITS region.
- Cutadapt filters out short sequences.
- Problematic FASTQ headers are fixed to ensure compatibility with downstream tools.

## 4. QIIME 2 Workflow
- Reads are imported into QIIME 2 and dereplicated.
- OTUs are clustered at 97% identity, and rare features are filtered.
- Chimeric sequences are identified and removed.

## 5. Importing Data to R
- Feature tables and metadata are imported into R as a TreeSummarizedExperiment (TSE) object.
- Taxonomic classification is performed using a reference database.
- Non-fungal taxa are filtered out to retain only relevant sequences.

## 6. Post-processing
- Processed data is saved in multiple formats, including feature tables, taxonomy tables, representative sequences, and metadata.
- Summary statistics and sequence length distributions are generated for quality control.

## Conclusion
This workflow provides a structured approach for processing fungal Nanopore reads, ensuring quality control, taxonomic classification, and reproducibility. The analysis file includes all necessary code for replication.

