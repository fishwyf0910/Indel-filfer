genome=/data01/wangyf/project2/CyprinusCarpio/1.data/genome/genome.fa

source activate gatk4_pipeline

gatk --java-options "-Djava.io.tmpdir=/data01/wangyf/project2/CyprinusCarpio/tmp -Xms80G -Xmx80G -XX:ParallelGCThreads=20" MergeVcfs  $(cat /data01/wangyf/project2/CyprinusCarpio/1.data/genome/chr-new.order | while read line;do echo "-I /data01/wangyf/project2/CyprinusCarpio/7.genotyping/chr.vcf/good$line.vcf.gz";done) -O raw.vcf.gz && \

gatk --java-options "-Djava.io.tmpdir=/data01/wangyf/project2/CyprinusCarpio/tmp -Xms80G -Xmx80G -XX:ParallelGCThreads=20" SelectVariants -R $genome -V raw.vcf.gz -select-type INDEL --restrict-alleles-to BIALLELIC -O raw.indel.vcf.gz

:<<!
gatk VariantFiltration --java-options "-Djava.io.tmpdir=/data01/wangyf/project2/CyprinusCarpio/tmp -Xms80G -Xmx80G -XX:ParallelGCThreads=20" \
-R $genome -V raw.indel.vcf.gz -O raw.indel.QUAL30.QD2.FS200.SOR10.MQRankSum5.ReadPosRankSum8.vcf.gz \
-filter "QUAL < 30" -filter-name "QUAL30" \
-filter "QD < 2.0" -filter-name "QD2" \
-filter "FS > 200.0" -filter-name "FS200" \
-filter "MQRankSum < 5" -filter-name "MQRankSum-5" \
-filter "SOR > 10.0" -filter-name "SOR10" \
-filter "ReadPosRankSum < -8.0" -filter-name "ReadPosRankS-8"
!

gatk SelectVariants --java-options "-Djava.io.tmpdir=/data01/wangyf/project2/CyprinusCarpio/tmp -Xms80G -Xmx80G -XX:ParallelGCThreads=20" --exclude-filtered true -V raw.indel.QUAL30.QD2.FS200.SOR10.MQRankSum5.ReadPosRankSum8.vcf.gz -O raw.indel.QUAL30.QD2.FS200.SOR10.MQRankSum5.ReadPosRankSum8.PASS.vcf.gz

## get InDel region
perl /data01/wangyf/software/annovar/convert2annovar.pl -format vcf4old  raw.indel.maxmiss0.05.AF0.05.vcf.gz --outfile raw.indel.maxmiss0.05.AF0.05.vcf.gz.avinput
