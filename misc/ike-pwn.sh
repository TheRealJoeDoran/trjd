#
# REQUIRES IKEFORCE WORDLISTS FROM SPIDERLABS
#
#
#
#


if [ ! -f "IKE-HOSTS" ]; then
        printf "[!] File \'IKE-HOSTS\' does not exist\n"
        exit 1
fi

if [ ! -f "DH-GROUPS" ]; then
        printf "[!] File \'DH-GROUPS\' does not exist\n"
        exit 1
fi

if [ ! -f "CUSTOM-GROUPS" ]; then
        printf "[-] File \'CUSTOM-GROUPS\' does not exist\n"
        printf "[-] CUSTOM GROUP NAMES WILL NOT BE TESTED\n"
else
        printf "[+] \'CUSTOM-GROUPS\' FOUND\n"
        printf "[+] CUSTOM GROUP NAMES WILL BE TESTED\n"
fi

if [ ! -f "/opt/ikeforce/wordlists/groupnames.dic" ]; then
        printf "[-] IKEFORCE GROUP NAMES NOT FOUND in /opt/ikeforce/wordlists/groupnames.dic\n"
        printf "[-] COMMON GROUP NAMES WILL NOT BE TESTED\n"
else
        printf "[+] IKEFORCE GROUP NAMES FOUND in /opt/ikeforce/wordlists/groupnames.dic\n"
        printf "[+] COMMON GROUP NAMES WILL BE TESTED\n"
fi


for target in $(cat IKE-HOSTS);
do
        printf '#%.0s' {1..120}
        printf '\n'

        for dh in $(cat DH-GROUPS);
        do
                # KNOWN FAKE GROUP TO ESTABLISH BASELINE BEHAVIOR
                printf '#%.0s' {1..80} | tee -a ike-scan_${target}_fake.log
                printf '\n' | tee -a ike-scan_${target}_fake.log
                printf '# sudo ike-scan %s -M -A --id=fakegroupjoemadeup -dhgroup=%s -P\n' ${target} ${dh} | tee -a ike-scan_${target}_fake.log
                printf '# %s\n' "$(date)" | tee -a ike-scan_${target}_fake.log
                printf '#%.0s' {1..80} | tee -a ike-scan_${target}_fake.log
                printf '\n' | tee -a ike-scan_${target}_fake.log
                fakeResult="$(sudo ike-scan ${target} -M -A --id=fakegroupjoemadeup -dhgroup=${dh} -P | tee -a ike-scan_${target}_fake.log)"
                echo "${fakeResult}" | tee -a ike-scan_${target}_fake.log
                fake=$(echo "${fakeResult}" | grep -e "1 returned handshake")
                echo "FAKE 1: ${fake}" | tee -a ike-scan_${target}_fake.log
                if [ -z "${fake}" ]; then
                        printf "FAKE 1 is empty\n" | tee -a ike-scan_${target}_fake.log
                fi
                printf '\n' | tee -a ike-scan_${target}_fake.log
                printf '\n' | tee -a ike-scan_${target}_fake.log

                # CUSTOM GROUP NAMES
                if [ -f "CUSTOM-GROUPS" ]; then
                        for tg in $(cat CUSTOM-GROUPS);
                        do
                                printf '#%.0s' {1..80} | tee -a ike-scan_${target}_${dh}_custom.log
                                printf '\n' | tee -a ike-scan_${target}_${dh}_custom.log
                                printf '# sudo ike-scan %s -M -A --id=%s -dhgroup=%s -P\n' ${target} ${tg} ${dh} | tee -a ike-scan_${target}_${dh}_custom.log
                                printf '# %s\n' "$(date)" | tee -a ike-scan_${target}_${dh}_custom.log
                                printf '#%.0s' {1..80} | tee -a ike-scan_${target}_${dh}_custom.log
                                printf '\n' | tee -a ike-scan_${target}_${dh}_custom.log
                                sudo ike-scan ${target} -M -A --id=${tg} -dhgroup=${dh} -P | tee -a ike-scan_${target}_${dh}_custom.log
                                printf '\n' | tee -a ike-scan_${target}_${dh}_custom.log
                                printf '\n' | tee -a ike-scan_${target}_${dh}_custom.log
                        done
                fi

                # COMMON GROUP NAMES FROM IKEFORCE
                if [ -z "${fake}" ]; then # IF THE FAKE TUNNEL GROUP RETURNS A HANDSHAKE THEN BRUTE-FORCING IS POINTLESS, RETURNING NO HANDSHAKE ON THE FAKE MAKE BRUTE-FORCING MEANINGFUL
                        if [ -f "/opt/ikeforce/wordlists/groupnames.dic" ]; then
                                for tg in $(cat /opt/ikeforce/wordlists/groupnames.dic);
                                do
                                        printf '#%.0s' {1..80} | tee -a ike-scan_${target}_${dh}_ikeforce.log
                                        printf '\n' | tee -a ike-scan_${target}_${dh}_ikeforce.log
                                        printf '# sudo ike-scan %s -M -A --id=%s -dhgroup=%s -P\n' ${target} ${tg} ${dh} | tee -a ike-scan_${target}_${dh}_ikeforce.log
                                        printf '# %s\n' "$(date)" | tee -a ike-scan_${target}_${dh}_ikeforce.log
                                        printf '#%.0s' {1..80} | tee -a ike-scan_${target}_${dh}_ikeforce.log
                                        printf '\n' | tee -a ike-scan_${target}_${dh}_ikeforce.log
                                        sudo ike-scan ${target} -M -A --id=${tg} -dhgroup=${dh} -P | tee -a ike-scan_${target}_${dh}_ikeforce.log
                                        printf '\n' | tee -a ike-scan_${target}_${dh}_ikeforce.log
                                        printf '\n' | tee -a ike-scan_${target}_${dh}_ikeforce.log
                                done
                        fi
                fi
        done

        printf '\n'
        printf '\n'
        printf '\n'
        printf '\n'
        printf '\n'
done
