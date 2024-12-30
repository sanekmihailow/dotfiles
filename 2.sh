find / -type d  \( -path '/proc' -o -path '/dev' -o -path '/sys' \
                   -o -path '/var/log/*' -o -path '/var/lib/docker/*' \
                   -o -path '/mnt' \) \
                -prune -o -type f -cmin -60 \
                -printf '%Td-%Tm-%TY %TH:%TM %s\t %p %m %u:%g (%c) [%i] \n' \
        |awk '{ $3 = substr(($3/1024), 1, 4) "k""\t"; $4=$4 "\t " ; print }';
