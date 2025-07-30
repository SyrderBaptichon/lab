#!/bin/bash

##----- Author : Syrder Baptichon
##----- Purpose : A script to auto-detect network IP, search for connected devices, and scan them for open ports 
##----- Usage : ./network_scan
##----- PS : The script will miss devices that are not "pingable"

# Get network ip octets
ifconfig | grep broadcast | cut -d " " -f 10 | cut -d "." -f 1,2,3 | uniq > octets.txt

# Check if we found a network
if [ ! -s octets.txt ]; then
    echo "Error: Could not detect network. Make sure you're connected to a network."
    exit 1
fi

# Set variable to have the value of octets.txt
OCTETS=$(cat octets.txt)

# Handle multiple networks
NETWORK_COUNT=$(wc -l < octets.txt)
if [ $NETWORK_COUNT -gt 1 ]; then
    echo "Multiple networks detected:"
    nl octets.txt
    echo "Scanning all networks..."
    OCTETS=$(head -n1 octets.txt)
else
    echo "Scanning network: $OCTETS.1-254"
fi

# Create output file
OUTPUT_FILE="scan_results.txt"
> $OUTPUT_FILE

# Scan all networks found
while read -r NETWORK_OCTETS; do
    echo "Scanning $NETWORK_OCTETS.1-254..."
    
    # Scan the current network
    for ip in {1..254}
    do
        ping -c 1 -W 1 $NETWORK_OCTETS.$ip >/dev/null 2>&1 && echo "$NETWORK_OCTETS.$ip" >> $OUTPUT_FILE &
    done
done < octets.txt

# Wait for all pings to complete
wait

# Display results
if [ -s $OUTPUT_FILE ]; then
    echo ""
    echo "Active hosts found:"
    echo "=================="
    sort -V $OUTPUT_FILE
    echo ""
    echo "Total hosts found: $(wc -l < $OUTPUT_FILE)"
else
    echo "No active hosts found on network $OCTETS.x"
fi
