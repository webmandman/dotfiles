#!/bin/sh

echo "Installing Commandbox For Server"

commandbox_url='https:/s2.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/5.5.0-alpha/commandbox-bin-5.5.0-alpha.zip'
mkdir -p /opt/commandbox
curl -s -o /opt/commandbox/src.zip $commandbox_url
unzip -d / /opt/commandbox/src.zip
rm -rf /opt/src.zip



