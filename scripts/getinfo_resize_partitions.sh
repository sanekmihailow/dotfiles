#!/usr/bin/env bash
dest="$HOME/resize/$(date +%F)"
curtime="$(date +%H-%M)"

if [ -d $dest ]; then dst=0; else  mkdir -p ${dest}; fi
select=99
resized=false

allpath_device=$(ls /sys/class/scsi_device/*/device/block |sed '/^$/d')
echo "------------"
echo "$allpath_device"
echo "------------"
shortpath_device="$(echo -e "$allpath_device" |sed -z 's/:\n/\//g')"
device="$(echo -e "$shortpath_device" |cut -d '/' -f8 |sed 's/$/, /g' |sed -z 's/\n//g' |sed 's/, $//g' )"
#ls /sys/class/scsi_device/*/device/block |sed -z 's/:\n/\//g' |sed '/^$/d' |cut -d '/' -f1-8


echo -e "\n enter disk path \n choose between: $device"

if read -sp "" disk; then
    pattrn="^[0-9]"
    if [[ ! $disk =~ $pattrn ]]; then

        check="$(echo "$shortpath_device" |grep "$disk")"
        if [[ $? == 0 ]]; then
            device="$(echo "$check" |cut -d '/' -f1-6)"
            dmesg -T |grep -in -C5 'logical blocks' > ${dest}/dmesg_resize

            while [ $select != 0 ]; do

                if [ $select == 99 ]; then
                    echo -e "\n \033[0;32m please choose what you want  save (1 or 2 or 3) :\033[0m
                    \n 1) before \n 2) current \n 3) after \n 0) or zero to exit"
                    read -sp "" select
                fi

                if [ $select == 1 ];       then pattern1='before'
                    elif [ $select == 2 ]; then pattern1='current'
                    elif [ $select == 3 ]; then pattern1='after'
                    else echo "\n echo unknown pattern";  exit 1
                fi

                if [ $resized != true ]; then
                    if [[ $select == 2 || $select == 3 ]]; then
                        echo '1' > ${device}/rescan
                        dmesg -T |grep -in -C5 'logical blocks' > ${dest}/dmesg_resize
                        resized=true
                    fi
                fi

                fdisk -l                       > ${dest}/${pattern1}_fdiskl_${curtime}
                sfdisk -l                      > ${dest}/${pattern1}_sfdiskl_${curtime}
                parted /dev/${disk} print free > ${dest}/${pattern1}parted_free
                parted -l                      > ${dest}/${pattern1}_parted_${curtime}
                partx -l /dev/${disk}          > ${dest}/${pattern1}_partx_${curtime}
                partx --show /dev/${disk}      >> ${dest}/${pattern1}_partx_${curtime}
                lsblk                          > ${dest}/${pattern1}_lsblk_${curtime}
                df -hT                         > ${dest}/${pattern1}_df_${curtime}

                check_lvm=$(fdisk -l |grep '/dev/mapper' &> /dev/null)
                if [[ $? == 0 ]]; then
                    pvdisplay   > ${dest}/${pattern1}_pv_${curtime}
                    pvscan      >> ${dest}/${pattern1}_pv_${curtime}
                    vgdisplay   > ${dest}/${pattern1}_vg_${curtime}
                    vgscan      >> ${dest}/${pattern1}_vg_${curtime}
                    lvdisplay   > ${dest}/${pattern1}_lv_${curtime}
                    lvscan      >> ${dest}/${pattern1}_lv_${curtime}
                fi

                correct=false
                while [ $correct != true ]; do
                    echo -e "\n \033[0;32m please choose what you want  save (1 or 2 or 3) :\033[0m
                    \n 1) before \n 2) current \n 3) after \n 0) or zero to exit"

                    if read -sp "" choose
                        then echo -e "you choose $choose\n"
                             correct=true; select=$choose
                        else echo -e "invalid argument\n please try again \n"
                    fi
                done
            done
        else
            echo -e "\033[31m device path not found \033[0m"
            exit 1
        fi
    else
        echo -e "\033[31m use path and not use number. On example: sda \033[0m"
        exit 1
    fi
fi
