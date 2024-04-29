rule cutadapt_trim:
    input:
        ["data/samples/{sample}.1.fastq.gz", "data/samples/{sample}.2.fastq.gz"],
    output:
        fastq1=temp("data/trimmed/trimmed_{sample}.1.fastq"),
        fastq2=temp("data/trimmed/trimmed_{sample}.2.fastq"),
        qc="data/trimmed/trimmed_{sample}.qc.txt",
    params:
        # https://cutadapt.readthedocs.io/en/stable/guide.html#adapter-types
        adapters="-a CTGTCTCTTATACACATCT -A CTGTCTCTTATACACATCT",
        # https://cutadapt.readthedocs.io/en/stable/guide.html#
        extra="--minimum-length 20 -q 30",
    log:
        "logs/cutadapt/{sample}.log",
    threads: 1  # set desired number of threads here
    resources:
        mem_mb=4000,
        time="24:00:00"
    wrapper:
        "v1.32.1/bio/cutadapt/pe"
#output changed to temp
