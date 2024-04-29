rule narrowpeak:
    input:
        treatment="data/mapped/{sample}_sorted_deduplicated.bam"   # required: treatment sample(s)
#        control=""      # optional: control sample(s)
    output:
        # all output-files must share the same basename and only differ by it's extension
        # Usable extensions (and which tools they implicitly call) are listed here:
        #         https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/macs2/callpeak.html.
        multiext("data/peakcalling/narrow/{sample}",
                 "_peaks.xls",   ### required
                 ### optional output files
                 "_peaks.narrowPeak",
                 "_summits.bed"
                 )
    threads: 1
    resources:
        mem_mb=8000,
        time="24:00:00"
    log:
        "logs/macs2/{sample}_narrowpeak.log"
    params:
        "-f BAM -g hs --nomodel --extsize 150 -q 0.01 --SPMR --shift -75 --nolambda"
    conda:
        "wrapper"
    wrapper:
        "v2.0.0/bio/macs2/callpeak"

rule broadpeak:
    input:
        treatment="data/mapped/{sample}_sorted_deduplicated.bam"   # required: treatment sample(s)
#        control=""      # optional: control sample(s)
    output:
        # all output-files must share the same basename and only differ by it's extension
        # Usable extensions (and which tools they implicitly call) are listed here:
        #         https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/macs2/callpeak.html.
        multiext("data/peakcalling/broad/{sample}",
                 "_peaks.xls",   ### required
                 ### optional output files
                 # these output extensions internally set the --bdg or -B option:
                 "_treat_pileup.bdg",
                 "_control_lambda.bdg",
                 # these output extensions internally set the --broad option:
                 "_peaks.broadPeak",
                 "_peaks.gappedPeak"
                 )
    threads:1
    resources:
        mem_mb=8000,
        time="24:00:00"
    log:
        "logs/macs2/{sample}_broadpeak.log"
    conda:
        "wrapper"
    params:
        "-f BAM -g hs -q 0.01 --shift -75 --extsize 150 --broad-cutoff 0.01 --nomodel --broad --bdg --nolambda"
    wrapper:
        "v2.0.0/bio/macs2/callpeak"
 
