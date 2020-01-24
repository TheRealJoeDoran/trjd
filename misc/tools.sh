updating () {
	printf "\e[32m[+] UPDATING %s...\n\e[39m" "${1}"
}

installing () {
	printf "\e[32m[+] INSTALLING %s...\n\e[39m" "${1}"
}

apt-get update && apt-get install responder metasploit-framework secure-delete crackmapexec pv pigz jq gobuster tmux ipmitool

if [ -d "/opt/Empire" ]; then
	updating "Empire"
	cd /opt/Empire/
	git pull
else
	installing "Empire"
	cd /opt/
	git clone https://github.com/EmpireProject/Empire
	cd /opt/Empire/
	./setup/install.sh
fi

if [ -d "/opt/impacket" ]; then
	updating "impacket"
	cd /opt/impacket/
	git pull
else
	installing "impacket"
	cd /opt/
	git clone https://github.com/SecureAuthCorp/impacket
	cd /opt/impacket/
	pip install .
fi

if [ -d "/opt/EyeWitness" ]; then
	updating "EyeWitness"
	cd /opt/EyeWitness/
	git pull
else
	installing "EyeWitness"
	cd /opt/
	git clone https://github.com/FortyNorthSecurity/EyeWitness
	cd /opt/EyeWitness/setup/
	./setup.sh
fi

if [ -d "/opt/CMSmap" ]; then
	updating "CMSmap"
	cd /opt/CMSmap/
	git pull
else
	installing "CMSmap"
	cd /opt/
	git clone https://github.com/Dionach/CMSmap
	cd /opt/CMSmap/
	pip3 install .
	cmsmap -U PC
fi

if [ -d "/opt/nishang" ]; then
	updating "nishang"
	cd /opt/nishang/
	git pull
else
	installing "nishang"
	cd /opt/
	git clone https://github.com/samratashok/nishang.git
fi

if [ -d "/opt/Sherlock" ]; then
	updating "Sherlock"
	cd /opt/Sherlock/
	git pull
else
	installing "Sherlock"
	cd /opt/
	git clone https://github.com/rasta-mouse/Sherlock.git
fi

if [ -d "/opt/WindowsEnum" ]; then
	updating "WindowsEnum"
	cd /opt/WindowsEnum/
	git pull
else
	installing "WindowsEnum"
	cd /opt/
	git clone https://github.com/absolomb/WindowsEnum.git
fi

if [ -d "/opt/wesng" ]; then
	updating "wesng"
	cd /opt/wesng/
	git pull
else
	installing "wesng"
	cd /opt/
	git clone https://github.com/bitsadmin/wesng.git
fi

if [ -d "/opt/fuzzdb" ]; then
	updating "fuzzdb"
	cd /opt/fuzzdb/
	git pull
else
	installing "fuzzdb"
	cd /opt/
	git clone https://github.com/fuzzdb-project/fuzzdb
fi

if [ -d "/opt/ikeforce" ]; then
	updating "ikeforce"
	cd /opt/ikeforce/
	git pull
else
	installing "ikeforce"
	cd /opt/
	git clone https://github.com/SpiderLabs/ikeforce
fi

if [ -d "/opt/testssl.sh" ]; then
	updating "testssh.sh"
	cd /opt/testssl.sh/
	git pull
else
	installing "testssl.sh"
	cd /opt/
	git clone https://github.com/drwetter/testssl.sh
fi

if [ -d "/opt/eavesarp" ]; then
	updating "eavesarp"
	cd /opt/eavesarp/
	git pull
else
	installing "eavesarp"
	cd /opt/
	git clone https://github.com/arch4ngel/eavesarp
	cd /opt/eavesarp/
	python3.7 -m pip install -r requirements.txt
fi

if [ -d "/opt/USB-Rubber-Ducky" ]; then
	updating "USB-Rubbery-Ducky"
	cd /opt/USB-Rubber-Ducky/
	git pull
else
	installing "USB-Rubber-Ducky"
	cd /opt/
	git clone https://github.com/hak5darren/USB-Rubber-Ducky
fi

if [ -d "/opt/BloodHound" ]; then
	updating "BloodHound"
	cd /opt/BloodHound/
	git pull
else
	installing "BloodHound"
	cd /opt/
	git clone https://github.com/BloodHoundAD/BloodHound.git
fi

#
# TO DO: Add
# https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite
# https://github.com/danielmiessler/SecLists
#

printf "\e[32m[+] DEPLOYMENT COMPLETE.\n\e[39m"
