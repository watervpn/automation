
#!/bin/bash
#
# Requirement Check

#set -x
DIRNAME=`dirname $0`

#############################
#    OS Check
#############################
# Check Centos release file exist
test ! -f /etc/centos-release && echo "OpenVpn script only support centos platform" && exit 1

# Check Centos version - expect "CentOS Linux release 7.0.1406 (Core)"
CENTOS_VERSION=`cat /etc/centos-release`
if ! [[ $CENTOS_VERSION =~ ^CentOS[[:space:]]Linux[[:space:]]release[[:space:]]7.* ]]; then
    echo 'OpenVpn script only support centos version 7, go away!' && exit 1
fi

#############################
#    Internet Check
#############################
# Check internet connection
wget -q --tries=10 --timeout=20 --spider http://google.com
# $? find error code of last execute command
test ! -eq 0 && echo "No internet connection, go away!" && exit 1

#############################
#    Repo Check
#############################
# Check EPEL repo
EPEL=`yum repolist epel | grep epel`
if [ -z "$EPEL" ]; then
    # Install epel repo
    # Todo: download epel from our server
    #wget -O /tmp/epel-release-7-5.noarch.rpm http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
    sudo yum -y install $DIRNAME/packages/repo/epel-release-7-5.noarch.rpm
fi

#############################
#    Package Check
#############################
# Check requirment packages 
test ! -f `which wget` && sudo yum -y install wget && echo "Installed missing wget package"
test ! -f `which git` && sudo yum -y install git && echo "Installed missing git package"
