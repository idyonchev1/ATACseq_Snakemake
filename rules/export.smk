rule sort_bowtie2_output:
    input:
        "data/mapped/{sample}_unsorted.bam"
    output:
        "data/mapped/{sample}_sorted_deduplicated.bam"
    threads: 4
    log: 
        out= "logs/sort_bowtie2_output/{sample}_sort.log",
        err = "logs/sort_bowtie2_output/{sample}_sort.err"
    resources:
        mem_mb=4000,
        time="24:00:00"
    shell:
        "samtools sort {input} -@ 4 -o {output} 2> {log.err} 1> {log.out}"

#-@ 4

rule index_bowtie2_output:
    input:
        "data/mapped/{sample}_sorted_deduplicated.bam"
    output:
        "data/mapped/{sample}_sorted_deduplicated.bam.bai"
    threads: 1
    resources:
        mem_mb=1000,
        time="24:00:00"
    shell:
        "samtools index {input}"

rule export_bedgraph_temp:
    input:
        ["data/mapped/{sample}_sorted_deduplicated.bam","data/mapped/{sample}_sorted_deduplicated.bam.bai"]
    output:
        temp("data/bigwigs/{sample}.bedgraph")
    threads: 1
    resources:
        mem_mb=8000,
        time="24:00:00"
    shell:
        "genomeCoverageBed -bg -ibam data/mapped/{wildcards.sample}_sorted_deduplicated.bam -g GRCh38.chrom.sizes 2> {output}.log | sort -k1,1 -k2,2n > {output}"

rule export_bigwig:
    input:
        "data/bigwigs/{sample}.bedgraph"
    output:
        "data/bigwigs/{sample}.bw"
#    conda:
#        "../envs/tools.yaml",
    threads:1
    resources:
        mem_mb=4000,
        time="24:00:00"
    shell:
        "bedGraphToBigWig {input} GRCh38.chrom.sizes {output} 2>>{output}.log "

