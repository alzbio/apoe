```
# apoe
tabix -h chr19.vcf.gz chr19:44900000-44925000 | bgzip > apoe_cluster.vcf.gz
tabix -p vcf apoe_cluster.vcf.gz
paste <(bcftools query -l apoe_cluster.vcf.gz) \
      <(bcftools query -f '[%GT\n]' -r chr19:44908684 apoe_cluster.vcf.gz) \
| awk '$2=="1/1"{print $1}' > apoe4.ids

```
