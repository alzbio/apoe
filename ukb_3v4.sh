#APOE4 vs APOE3 snp enrichment 
#ERIS
#/PHShome/mm1286/data/data/alz/ukb/genotype
module add Plink
mkdir -p apoe
plink2 --bfile genotype/ukb_cal_allChrs --snp rs429358 --recode A --out apoe/rs429358
plink2 --bfile genotype/ukb_cal_allChrs --snp rs429358 --make-bed --out apoe/rs429358
awk '{print $7}' apoe/rs429358.raw | tail -n +2 | sort | uniq -c
awk 'NR==1 || ($7==0 || $7==2)' apoe/rs429358.raw > apoe/rs429358_hom.raw
awk 'NR>1 {print $1, $2}' apoe/rs429358_hom.raw > apoe/rs429358_hom_samples.txt
plink2 --bfile genotype/ukb_cal_allChrs --keep apoe/rs429358_hom_samples.txt --make-bed --out apoe/rs429358_hom

cd apoe
awk 'NR>1{print $1, $2, $NF}' rs429358.raw > geno_lookup.txt
awk 'NR==FNR{a[$1 FS $2]=$3; next} {print $1, $2, $3, $4, $5, a[$1 FS $2]}' geno_lookup.txt rs429358_hom.fam > rs429358_hom_geno_as_pheno.fam
cp rs429358_hom.fam rs429358_hom.fam.backup
cp rs429358_hom_geno_as_pheno.fam rs429358_hom.fam
awk '{$6 = ($6 == 0 ? 1 : $6); print $0}' rs429358_hom.fam > rs429358_hom_casecontrol.fam
cp rs429358_hom_casecontrol.fam rs429358_hom.fam
plink2 --bfile rs429358_hom --glm allow-no-covars --threads 32 --out diff_snps_rs429358_hom
