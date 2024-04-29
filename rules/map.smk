#premap k 1 -D 20 -R 3 -N 1 -L 20 -i S,1,0.50 to mito, extract unmapped, map to rDNA, extract unmapped, map to hg38
#map -X 2000 --very-sensitive

rule map_with_bowtie2_and_dedup:
    input:
        sample=["data/mapped/rDNA/{sample}.1.fastq", "data/mapped/rDNA/{sample}.2.fastq"]
    output:
        temp("data/mapped/{sample}_unsorted.bam")
#        "data/mapped/{sample}_sorted_deduplicated.bam"

    log:
        "logs/bowtie2/{sample}.log",
    conda:
        "base"
    params:
        extra="",  # optional parameters
    threads: 4  # Use at least two threads
    resources:
        mem_mb=8000,
        time="24:00:00"
    shell:
        "bowtie2 -x index/GRCh38 -1 {input[0]} -2 {input[1]} -X 2000 --very-sensitive | samtools view -F 1548 -f 3 -q 30 -bS -  > {output}"

