rule TSS_metagene_matrix:
    input:
        sample=["data/bigwigs/{sample}.bw","genesets/refgene_all_known_mrna_transcripts_merged_2kb.bed"],
    output:
        "data/metagene/matrix_{sample}.gz"
    resources:
        mem_mb=2000,
        time="24:00:00"
    threads: 1
    conda:
        "../envs/cgat-apps"
    shell:
        "computeMatrix scale-regions -S {input[0]} -R {input[1]} -bs 10 -m 4000 --averageTypeBins sum --missingDataAsZero -o {output}"

rule TSS_metagene_heatmap:
    input: 
       "data/metagene/matrix_{sample}.gz"
    output:
        "data/metagene/{sample}_2kb_surrounding_TSS.png"
    threads: 1
    resources:
        mem_mb=2000,
        time="24:00:00"
    conda:
        "../envs/cgat-apps"
    shell:
        "plotHeatmap -m {input} -out {output}"
