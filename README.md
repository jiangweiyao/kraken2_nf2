# Kraken2/Bracken Nextflow Workflow

### Dependencies:
1. [Nextflow](https://www.nextflow.io/)
2. [Docker](https://www.docker.com/) - if you select to use the -profile docker option. Otherwise, Kraken2 and Bracken needs to be installed and available in the environment. 
3. [Conda](https://docs.conda.io/en/latest/) - if you select to use the -profile conda option. This workflow has been tested with Miniconda.

### Input Parameters:
The params.json in the repo shows the parameters needed by the workflow. 
1. Paired end Fastq files containing metagenomic sequences you want to analyze (input_fastqs). You can find some sample files [here](https://singular-public-repo.s3.us-west-1.amazonaws.com/microbiome/RM8376_2Million.tar). This file need to untar-ed before use.
2. Output location (out) where you want the output files to be sent to.
3. The Kraken2 [database](https://benlangmead.github.io/aws-indexes/k2) folder (kraken_db). The reference needs to be untar-ed before use. Note: reference databases can be large in size. 
4. The Bracken count threshold (bracken_threshold). Bracken disregards all taxa with counts under this threshold for analysis. Default is set to 200.

### Usage: 
You can run the workflow using the following command with your valid parameter (files). 
```
nextflow run kraken2_nf2/main.nf -params-file kraken2_nf2/params.json [-profile docker|conda]
```

### What the workflow is doing:
There are 2 processes to the workflow. The first step runs Kracken2 and then Bracken2 analysis on your input paired end Fastq files. The second step aggregates the Bracken2 outputs for each file into a single table for downstream analysis. 
