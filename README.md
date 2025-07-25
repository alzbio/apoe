```
# apoe
module add htslib
tabix -h chr19.vcf.gz chr19:44900000-44925000 | bgzip > apoe_cluster.vcf.gz
tabix -p vcf apoe_cluster.vcf.gz
paste <(bcftools query -l apoe_cluster.vcf.gz) \
      <(bcftools query -f '[%GT\n]' -r chr19:44908684 apoe_cluster.vcf.gz) \
| awk '$2=="1/1"{print $1}' > apoe4.ids

bcftools view -S apoe3.ids -Oz -o apoe3_cluster.vcf.gz apoe_cluster.vcf.gz

bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n' apoe3_cluster.vcf.gz | awk '{
  n_homref=0; n_het=0; n_homalt=0; n_miss=0;
  for(i=5;i<=NF;i++) {
    if($i=="0/0" || $i=="0|0") n_homref++;
    else if($i=="1/1" || $i=="1|1") n_homalt++;
    else if($i=="0/1" || $i=="1/0" || $i=="0|1" || $i=="1|0") n_het++;
    else if($i=="./." || $i==".|.") n_miss++;
  }
  total_called = n_homref + n_het + n_homalt;
  if (total_called > 0) {
    printf "%s\t%s\t%s\t%s\t%d\t%d\t%d\t%d\t%.5f\t%.5f\t%.5f\n", $1,$2,$3,$4,n_homref,n_het,n_homalt,n_miss,n_homref/total_called,n_het/total_called,n_homalt/total_called;
  } else {
    printf "%s\t%s\t%s\t%s\t%d\t%d\t%d\t%d\tNA\tNA\tNA\n", $1,$2,$3,$4,n_homref,n_het,n_homalt,n_miss;
  }
}' | sort -k9,9n > apoe3_fr

cut -f1-4 apoe3_fr | awk -F'\t' 'OFS="\t" {gsub(/^chr/, "", $1); print $1, $2, ".", $3, $4}' > apoe3_fr_an

```
