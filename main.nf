#!/usr/bin/env nextflow

nextflow.enable.dsl=2

fastq_files = Channel.fromFilePairs(params.input_fastqs, type: 'file')
kraken_db = file(params.kraken_db)

workflow {
    kraken2_fastq(fastq_files, kraken_db, params.bracken_threshold)
    combine_bracken_outputs(kraken2_fastq.out.collect())
}


process kraken2_fastq {

    //errorStrategy 'ignore'
    publishDir params.out, mode: 'copy', overwrite: true
    memory '30 GB'
    cpus 4
    input:
    tuple val(name), file(fastq) 
    file(kraken_db)
    val(bracken_threshold)

    output:
    file("*.{kreport,bracken}")

    """
    kraken2 --db ${kraken_db} --threads 4 --memory-mapping --paired ${fastq[0]} ${fastq[1]} --report ${name}.kreport 
    bracken -d ${kraken_db} -i ${name}.kreport -o ${name}.bracken -t ${bracken_threshold}
    """
}

process combine_bracken_outputs {

    //errorStrategy 'ignore'
    publishDir params.out, mode: 'copy', overwrite: true
    memory '2 GB'
    cpus 1
    input:
    file(kraken_reports)

    output:
    file("combined_bracken_results.txt")

    """
    combine_bracken_outputs.py --files *.bracken -o combined_bracken_results.txt
    """
}
