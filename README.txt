Snakemake pipeline for processing ATAC-seq data.

To execute on SLURM cluster: snakemake --cluster "sbatch -t {resources.time} --mem={resources.mem_mb} -c {threads}" -j 30 --use-conda --latency-wait 30

To build rulegraph:snakemake --rulegraph | dot -Tpdf > rulegraph.pdf

Files:
 - Conda environment used to run the pipeline envs/snakemake.yaml.

Requirements:
fastq_screen_index/: folder with bowtie2 indices for fastq screen.
index/: hg38 bowtie2 index
prealign_index/: bowtie2 index of mtDNA and rDNA genomes. Obtained from refgenie: human_rDNA \ rCRSd

GRCh38.chrom.sizes in base directory.

Metagene geneset in genesets/ (requires cgat):
zcat hg38.refGene.gtf.gz | awk '{if (==transcript){print}}' | grep NM > refgene_all_known_mrna_transcripts.gtf
cgat gff2bed --is-gtf -I refgene_all_known_mrna_transcripts.gtf -S refgene_all_known_mrna_transcripts.bed
cat refgene_all_known_mrna_transcripts.bed | sort -k1,1 -k2,2n |bedtools merge -s -c 4,5,6 -o distinct > refgene_all_known_mrna_transcripts_merged.bed
cat refgene_all_known_mrna_transcripts_merged.bed| awk 'BEGIN {OFS = "\t"} {                                                           
    if ($6 == "+") {
        $3 = $2
        $2 = $2 - 2000
        $3 = $3 + 2000
    } else if ($6 == "-") {
        $2 = $3
        $2 = $2 - 2000
        $3 = $3 + 2000
    }
    print
}' > refgene_all_known_mrna_transcripts_merged_2kb.bed


