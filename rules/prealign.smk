rule map_to_mitochondria:
    input:
        ["data/trimmed/trimmed_{sample}.1.fastq", "data/trimmed/trimmed_{sample}.2.fastq"]
    output:
        temp("data/mapped/mitochondrial/{sample}.bam")
    threads: 4
    resources:
        mem_mb=8000,
        time="24:00:00"
    conda:
        "base"
    shell:
        "bowtie2 -x prealign_index/rCRSd -1 {input[0]} -2 {input[1]} -k 1 -D 20 -R 3 -N 1 -L 20 -i S,1,0.50 > {output}"

rule extract_unmapped_1:
    input:
        "data/mapped/mitochondrial/{sample}.bam"
    threads:2
    resources:
        mem_mb=4000,
        time="24:00:00"
    output:
        temp(["data/mapped/mitochondrial/{sample}.1.fastq","data/mapped/mitochondrial/{sample}.2.fastq"])
    conda:
        "../envs/cgat-apps.yaml"
    shell:
        "samtools collate -u -O {input} -@4 | samtools fastq -f 12 -1 {output[0]} -2 {output[1]} -@4"


rule map_to_rDNA:
    input:
        ["data/mapped/mitochondrial/{sample}.1.fastq", "data/mapped/mitochondrial/{sample}.2.fastq"]
    output:
        temp("data/mapped/rDNA/{sample}.bam")
    threads: 4
    resources:
        mem_mb=8000,
        time="24:00:00"
    conda:
        "base"
    shell:
        "bowtie2 -x prealign_index/human_rDNA -1 {input[0]} -2 {input[1]} -k 1 -D 20 -R 3 -N 1 -L 20 -i S,1,0.50 > {output}"

rule extract_unmapped_2:
    input:
        "data/mapped/rDNA/{sample}.bam"
    threads: 2
    resources:
        mem_mb=4000,
        time="24:00:00"
    output:
        temp(["data/mapped/rDNA/{sample}.1.fastq","data/mapped/rDNA/{sample}.2.fastq"])
    conda:
        "../envs/cgat-apps.yaml"
    shell:
        "samtools collate -u -O {input} -@4 |samtools fastq -f 12 -1 {output[0]} -2 {output[1]} -@4"


