#!/bin/bash

EMAIL_DISTRO=`cat /etc/scripts/reportingtools/reporting_emails.txt`
DATE=`date +%Y-%m-%d`
echo "Running Report...."
cd /etc/scripts/reportingtools
python generateReport.py -e prod -a 7355 -t $DATE > /tmp/ingest_report.out;

echo "Emailing report to recipients...."
for i in $EMAIL_DISTRO;
    do mail -s "CBC Ingest & Transcode Report" "$i" < /tmp/ingest_report.out
done
echo "Done emailing reports"
echo "Cleaning up tmp...."
rm /tmp/ingest_report.out
