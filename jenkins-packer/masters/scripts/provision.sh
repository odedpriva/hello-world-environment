#!/bin/bash
set -e

script_name=$(basename $0)

INSTALL_DIR=${HOME}/bin
TEMPDIR=$(mktemp -d)

# general variables.
ESC="\x1b["
RESET=$ESC"39;49;00m"
RED=$ESC"31;01m"
GREEN=$ESC"32;01m"
YELLOW=$ESC"33;01m"
MAGENTA=$ESC"35;01m"
LOG_ERROR_PREFIX=ERROR:
LOG_INFO_PREFIX=INFO:
LOG_FATAL_PREFIX=FATAL:

# 
function LOG() {
    local LOG_LEVEL_PREFIX=""
    
    case $1 in
        ERROR) LOG_LEVEL_PREFIX=$YELLOW$LOG_ERROR_PREFIX$RESET ;;
        INFO) LOG_LEVEL_PREFIX=$GREEN$LOG_INFO_PREFIX$RESET ;;
        FATAL) LOG_LEVEL_PREFIX=$RED$LOG_FATAL_PREFIX$RESET ;;
        STEP) if [ $DEBUG_MODE == "true" ]; then LOG_LEVEL_PREFIX=${MAGENTA}FUNCTION${RESET}; else return; fi ;;
    esac
    
    echo "${@:2}" | while read LINE; do
        printf "$(date "+%F %H:%M:%S") ${LOG_LEVEL_PREFIX} %s\n" "${LINE}" | tee -a ${LOGFILE}
    done
    
    if [ $1 == "FATAL" ]; then
        exit 1
    fi
}

function CHECK() {
    status=$1
    message=$2
    
    if [ $status -ne 0 ]; then
        LOG ERROR "$message"
    fi
}

function CHECK_AND_EXIT() {
    status=$1
    message=$2
    if [ $status -ne 0 ]; then
        LOG ERROR "$message"
        exit $status
    fi
}

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*) machine=linux ;;
    Darwin*) machine=darwin ;;
    *) machine="UNKNOWN:${unameOut}" && exit 1 ;;
esac

help() {
	cat <<EOF
usage: ${script_name}

e.g:
${script_name}

EOF
}

main() {
    setup
    install_common
    install_docker
    adding_crontab
    post_common
}

setup() {
    LOG INFO "STEP: ${FUNCNAME[0]}"
    mkdir -p ${INSTALL_DIR}
    chown ${UID}:${UID} ${INSTALL_DIR}
    echo 'export PATH=$HOME/bin:$PATH' >>${HOME}/.bashrc
	cat <<EOT >>${HOME}/.ssh/config
Host *
   StrictHostKeyChecking no
EOT
}

update_yum() {
    LOG INFO "STEP: ${FUNCNAME[0]}"
    sudo yum update -y
}

install_common() {
    LOG INFO "STEP: ${FUNCNAME[0]}"
    sudo yum install -y jq git
}

install_docker() {

    LOG INFO "STEP: ${FUNCNAME[0]}"
    sudo yum install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo docker version
    
}

install_jeknins() {

    LOG INFO "STEP: ${FUNCNAME[0]}"
    sudo yum remove -y java
    sudo yum install -y java-1.8.0-openjdk
    sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
    sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
    sudo yum install -y jenkins
    sudo chkconfig jenkins on
    echo "Setup SSH key"
    sudo mkdir /var/lib/jenkins/.ssh
    sudo touch /var/lib/jenkins/.ssh/known_hosts
    sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
    sudo chmod 700 /var/lib/jenkins/.ssh
    sudo mv /tmp/id_rsa /var/lib/jenkins/.ssh/id_rsa
    sudo chmod 600 /var/lib/jenkins/.ssh/id_rsa
}





adding_crontab() {
    LOG INFO "STEP: ${FUNCNAME[0]}"
    MY_CRONS=$(cat <<EOF
@reboot echo test
EOF
)
    set +e
    (crontab -l 2>/dev/null; echo "${MY_CRONS}") | crontab -
    set -e
    
    LOG INFO "listing crontab:"
    crontab -l
}

post_common() {
    LOG INFO "STEP: ${FUNCNAME[0]}"
    chmod -R +x ${INSTALL_DIR}
    ${INSTALL_DIR}/helm init --client-only
}

main "$@"
