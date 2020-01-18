#
# Python 3
# This script merges multiple Nessus XML files into one.
# This script does not handle deduplication of data, ie hosts.
# This script is best used in support of large vuln scans where the targets were split up into multiple scans.
#
# Reference: https://gist.github.com/mastahyeti/2720173
# Reference: https://www.darkoperator.com/blog/2015/2/16/merging-nessus-xml-reports-with-powershell
# Reference: https://docs.python.org/3/library/xml.etree.elementtree.html
# Reference: https://pypi.org/project/defusedxml/
#
# @TheRealJoeDoran
#

import defusedxml.ElementTree as ET
#
# To install defusedxml: pip3 install defusedxml
# Tested with defusedxml 0.6.0
#

import argparse
import os

PARSER = argparse.ArgumentParser(description="Merge Multiple Nessus XML Files")
PARSER.add_argument('-t', '--report_title', help="Title of the Merged Report", required=True)
PARSER.add_argument('-o', '--outfile', help="Output Filename and extension. Example: merged.nessus", required=True)
ARGS = PARSER.parse_args()

debug = False
createReport = True

for fileName in os.listdir('.'):
	print("[-] Parsing Begin -> ", fileName)

	if createReport:
		print("[-] Creating report")
		createReport = False
		mergedNessus = ET.parse(fileName)
		report = mergedNessus.find('Report')
		report.attrib['name'] = ARGS.report_title
	else:
		print("[-] Appending report")

		nessus = ET.parse(fileName)

# Don't seem to need the TARGETS list to be accurate when importing. Saving in case it becomes useful.
#
#		for pref in nessus.findall('.//preference'):
#			if pref.find('name').text == "TARGET":
#				print ("Preference: ")
#				print (pref.find('name').text)
#				print (pref.find('value').text)
#

		for host in nessus.findall('.//ReportHost'):
			if debug:
				print("[-] Appending Host -> ", host.attrib['name'])

			report.append(host)

	print("[-] Parsing Complete -> ", fileName)

print("[-] Writing report to ", ARGS.outfile)
mergedNessus.write(ARGS.outfile, encoding="utf-8", xml_declaration=True)
print("[+] Merge Complete.")
