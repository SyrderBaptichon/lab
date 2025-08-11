#!/bin/bash

##----- Author : Syrder Baptichon
##----- Purpose : A tool to analyse web server(nginx in this case) access log from the CLI
##----- Usage : ./nginx_log_analyser.sh 
##----- Project from roadmap.sh (https://roadmap.sh/projects/nginx-log-analyser)

COUNT=5

echo "Top ${COUNT} IP addresses with the most requests:"
awk '
{
    counts[$1]++
}
END {
    for (ip in counts) 
        printf "%s - %d requests\n", ip, counts[ip]
}' nginx-access.log | sort -k3,3nr | head -n "${COUNT}"

echo -e "\nTop ${COUNT} most requested paths:"
awk '
{
    counts[$7]++
}
END {
    for (path in counts)
        printf "%s - %d requests\n", path, counts[path]
}' nginx-access.log | sort -k3,3nr | head -n "${COUNT}"

echo -e "\nTop 5 response status codes:"
awk '
{
    counts[$9]++
}
END {
    for (request in counts)
        printf "%s - %d requests\n", request, counts[request]
}' nginx-access.log | sort -k3,3nr | head -n "${COUNT}"


echo -e "\nTop ${COUNT} user agents:"
awk -F'"' '{print $6}' nginx-access.log | sort | uniq -c | sort -nr | head -$COUNT | awk '{print substr($0, index($0,$2)) " - " $1 " requests"}'


