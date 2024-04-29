import os
os.environ["OMP_NUM_THREADS"] = "1"
import pandas as pd

configfile: "config/config.yaml"

SAMPLES, = glob_wildcards("data/samples/{sample}.1.fastq.gz")

include: "rules/prealign.smk"
include: "rules/trim.smk"
include: "rules/map.smk"
include: "rules/metagene.smk"
include: "rules/multiqc.smk"
include: "rules/call_peaks.smk"
include: "rules/export.smk"

rule all:
    input: [expand("data/metagene/{sample}_2kb_surrounding_TSS.png", sample=SAMPLES),expand("data/peakcalling/broad/{sample}_peaks.broadPeak", sample=SAMPLES),expand("data/peakcalling/narrow/{sample}_peaks.narrowPeak", sample=SAMPLES),"data/multiqc/multiqc_report.html"]
