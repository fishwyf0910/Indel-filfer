genome=/data01/wangyf/project2/CyprinusCarpio/1.data/genome/genome.fa

source activate gatk4_pipeline

gatk --java-options "-Djava.io.tmpdir=/data01/wangyf/project2/CyprinusCarpio/tmp -Xms80G -Xmx80G -XX:ParallelGCThreads=20" MergeVcfs  $(cat /data01/wangyf/project2/CyprinusCarpio/1.data/genome/chr-new.order | while read line;do echo "-I /data01/wangyf/project2/CyprinusCarpio/7.genotyping/chr.vcf/good$line.vcf.gz";done) -O raw.vcf.gz && \

gatk --java-options "-Djava.io.tmpdir=/data01/wangyf/project2/CyprinusCarpio/tmp -Xms80G -Xmx80G -XX:ParallelGCThreads=20" SelectVariants -R $genome -V raw.vcf.gz -select-type INDEL --restrict-alleles-to BIALLELIC -O raw.indel.vcf.gz

gatk SelectVariants --java-options "-Djava.io.tmpdir=/data01/wangyf/project2/CyprinusCarpio/tmp -Xms80G -Xmx80G -XX:ParallelGCThreads=20" -V raw.indel.vcf.gz -O raw.indel.maxmiss0.05.vcf.gz --max-nocall-fraction 0.05

gatk SelectVariants --java-options "-Djava.io.tmpdir=/data01/wangyf/project2/CyprinusCarpio/tmp -Xms80G -Xmx80G -XX:ParallelGCThreads=20" -V raw.indel.maxmiss0.05.vcf.gz -O raw.indel.maxmiss0.05.AF0.05.vcf.gz --selectExpressions "AF > 0.05"

## get InDel region
perl /data01/wangyf/software/annovar/convert2annovar.pl -format vcf4old  raw.indel.maxmiss0.05.AF0.05.vcf.gz --outfile raw.indel.maxmiss0.05.AF0.05.vcf.gz.avinput
