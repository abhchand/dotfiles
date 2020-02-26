#!/usr/bin/env bash

# This server uses dynamic DNS to expose itself to the world as `$HOST.abhchand.me`
#
# This is done as follows:
#
# * I use NameCheap.com to manage the `abhchand.me` domain (among other domains).
#   There's a DNS `A` record that points `$HOST.abhchand.com`
#   to the home router IP address (which periodicaly changes, more on that below).
#
# * The home router uses port forwarding to pass the incoming request from the external
#   world on towards the local server.
#   * This is configured under "port forwarding" on the router admin panel.
#   * Specifically it forwards requests coming in from port YYYY to $HOST's port 22 (traditional
#     ssh port).  As a side effect, that means all external traffic must use YYYY for the ssh port
#     instead of the default 22 (e.g. `ssh -p YYYY $HOST.abhchand.me`)
#   * As a side note, the router is also configured to reserve an internal IP for $HOST so it never
#     changes inside the home network. That's also configured in the router admin panel
#
# * As the last piece of the configuration, we need to constantly update NameCheap's `A` record
#   because the IP address of the home router constantly changes. Somewhat conveniently, NameCheap
#   actually supports doing this via HTTP. We just need to send a simple GET request with the new IP
#   and a secret password (provided by NameCheap).
#   See: https://www.namecheap.com/support/knowledgebase/article.aspx/29/11/how-do-i-use-a-browser-to-dynamically-update-the-hosts-ip
#   * This script is called periodically (via cron). It retrieves the IP address and updates NameCheap
#     if needed.
#
# Cron Entry:
#   > SHELL=/bin/bash
#   > BASH_ENV=/home/abhishek/.bashrc
#   >
#   > */10 * * * * HOST=XXX NAMECHEAP_SECRET=AAA sh /path/to/this/script.sh >> /tmp/dynamic-dns.log 2>&1

MY_IP=`curl --silent "http://whatismyip.akamai.com"`
REQUEST_URL="https://dynamicdns.park-your-domain.com/update?host=$HOST&domain=abhchand.me&password=$NAMECHEAP_SECRET&ip=$MY_IP"

RESPONSE=`curl --silent -w "RESPONSE: %{http_code}" $REQUEST_URL`
DATE=`date '+%Y-%m-%d %H:%M:%S'`

echo "[$DATE] { request: $REQUEST_URL, response: $RESPONSE }"
