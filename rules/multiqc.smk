rule fastqc:
    input:
        ["data/trimmed/{sample}.1.fastq", "data/trimmed/{sample}.2.fastq"]
    output:
        ["data/fastqc/pre_prealign/{sample}.1_fastqc.html","data/fastqc/pre_prealign/{sample}.2_fastqc.html"]
#    conda:
#        "../envs/qc.yml"
    params:
    threads: 1
    resources:
        mem_mb=4000,
        time="24:00:00"
    shell:
        "fastqc -o data/fastqc/pre_prealign -t 1 {input}"

rule fastq_screen:
    input:
        ["data/trimmed/{sample}.1.fastq","data/trimmed/{sample}.2.fastq"]
    output:
        txt="data/fastqc/pre_prealign/{sample}.fastq_screen.txt",
        png="data/fastqc/pre_prealign/{sample}.fastq_screen.png"
    params:
        fastq_screen_config="config/fastq_screen.conf",
        subset=100000,
        aligner='bowtie2'
    threads: 8
    resources:
        mem_mb=8000,
        time="24:00:00"
    conda:
        "wrapper"
    wrapper:
        "v2.0.0/bio/fastq_screen"

rule fastqc_post_prealign:
    input:
        ["data/mapped/rDNA/{sample}.1.fastq", "data/mapped/rDNA/{sample}.2.fastq"]
    output:
        ["data/fastqc/post_prealign/{sample}.1_fastqc.html","data/fastqc/post_prealign/{sample}.2_fastqc.html"]
#    conda:
#        "../envs/qc.yml"
    resources:
        mem_mb=4000,
        time="24:00:00"
    threads:1
    shell:
        "fastqc -o data/fastqc/post_prealign -t 1 {input}"


rule multiqc:
    input:
        expand("data/fastqc/pre_prealign/trimmed_{sample}.1_fastqc.html", sample=SAMPLES),
        expand("data/fastqc/pre_prealign/trimmed_{sample}.2_fastqc.html", sample=SAMPLES),
        expand("data/fastqc/pre_prealign/trimmed_{sample}.fastq_screen.txt", sample=SAMPLES),
        expand("data/fastqc/post_prealign/{sample}.1_fastqc.html", sample=SAMPLES),
        expand("data/fastqc/post_prealign/{sample}.2_fastqc.html", sample=SAMPLES)
    output:
        "data/multiqc/multiqc_report.html"
#    conda:
#        "../envs/qc.yml"
    threads: 1
    resources:
        mem_mb=4000,
        time="24:00:00"
    shell:
        "multiqc data/fastqc -o data/multiqc"
