#
#
# SIMPLE TWEAKS NEEDED - DEFINE YOUR BRUTEFILES LINES 123 - 131.
#
#





#
#
# printUsage ()
#
#
printUsage () {
        printf "Usage: $0 <HOST LIST> <PORT> <SSL [True|False]> <BRUTE LIST [common|small|medium|large]>\n\n"
        printf "Example: $0 HTTP-HOSTS 80 False\n"
        printf "Example: $0 HTTPS-HOSTS 443 True\n"
        exit 1
}




#
#
#
#
#
printHeader() {
        printf '\n'
        printf '\n'
        printf '#%.0s' {1..80}
        printf '\n'
        printf '\n'
}





#
#
#
#
#
goPwn() {
if [ "${ssl}" = "TRUE" ]; then
        for host in $( cat ${hosts}); do
                if [ "${port}" = "443" ]; then
                        url="https://${host}"
                else
                        url="https://${host}:${port}"
                fi

                printHeader | tee -a gobuster_https-${host}-${port}_${brute}.log
                printf "${url}\n" | tee -a gobuster_https-${host}-${port}_${brute}.log
                printf "gobuster -k -u ${url} -l -w ${bruteFile}" | tee -a gobuster_https-${host}-${port}_${brute}.log
                printHeader | tee -a gobuster_https-${host}-${port}_${brute}.log

                gobuster -k -u ${url} -l -w ${bruteFile} | tee -a gobuster_https-${host}-${port}_${brute}.log
        done
elif [ "${ssl}" = "FALSE" ]; then
        for host in $(cat ${hosts}); do
                if [ "${port}" = "80" ]; then
                        url="http://${host}"
                else
                        url="http://${host}:${port}"
                fi

                printHeader | tee -a gobuster_http-${host}-${port}_${brute}.log
                printf "${url}\n" | tee -a gobuster_http-${host}-${port}_${brute}.log
                printf "gobuster -u ${url} -l -w ${bruteFile}" | tee -a gobuster_http-${host}-${port}_${brute}.log
                printHeader | tee -a gobuster_http-${host}-${port}_${brute}.log

                gobuster -u ${url} -l -w ${bruteFile} | tee -a gobuster_http-${host}-${port}_${brute}.log
        done
else
        printf "[!] goPwn() Unexpected Condition\n"
        printUsage
fi
}





#
#
# MAIN SCRIPT
#
#
if [ "$#" -ne 4 ]; then
        printf "[!] Illegal number of parameters\n"
        printUsage
fi

hosts=${1}
port=${2}
ssl=${3^^}
brute=${4^^}

if [ ! -f "${hosts}" ]; then
        printf "[!] HOST LIST: File \'${hosts}\' does not exist\n"
        printUsage
fi

if [ ! ${port} -ge 1 ] || [ ! ${port} -le 65535 ]; then
        printf "[!] PORT: Invalid Port Number. Valid Ports are 1 through 65535, inclusive.\n"
        printUsage
fi

if [ "${ssl}" != "TRUE" ] && [ "${ssl}" != "FALSE" ]; then
        printf "[!] SSL: The SSL Parameter must be TRUE or FALSE.\n"
        printUsage
fi

if [ "${brute}" != "COMMON" ] && [ "${brute}" != "SMALL" ] && [ "${brute}" != "MEDIUM" ] && [ "${brute}" != "LARGE" ]; then
        printf "[!] BRUTE LIST: The BRUTE LIST value must be common, small, medium, or large.\n"
        printUsage
else
        if [ "${brute}" = "COMMON" ]; then
                bruteFile="/usr/share/wordlists/dirb/common.txt"
        elif [ "${brute}" = "SMALL" ]; then
                printf "[-] SMALL PLACE HOLDER\n"
        elif [ "${brute}" = "MEDIUM" ]; then
                printf "[-] MEDIUM PLACE HOLDER\n"
        elif [ "${brute}" = "LARGE" ]; then
                printf "[-] LARGE PLACE HOLDER\n"
        else
                printf "[!] BRUTE LIST: Unexpected Error.\n"
                printUsage
        fi

        if [ ! -f "${bruteFile}" ]; then
                printf "[!] BRUTE LIST: File \'${bruteFile}\' does not exist\n"
                printUsage
        fi
fi

printf "Selected Options:\n"
printf "HOST LIST: ${hosts}\n"
printf "PORT: ${port}\n"
printf "SSL: ${ssl}\n"
printf "BRUTE LIST: ${bruteFile}\n"

goPwn
