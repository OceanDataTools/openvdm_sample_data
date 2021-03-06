#!/bin/bash -e

# OpenVDM is available as open source under the GPLv3 License at
#   https:/github.com/oceandatatools/openvdm_sample_data
#
# This script replaces any existing OpenVDM configuration with the 
# one used on the OpenVDM demo site.  It is designed to be run as root.
#
# It should be re-run whenever the code has been refresh. Preferably
# by first running 'git pull' to get the latest copy of the script,
# and then running 'install_sample_data.sh' to re-run this script.
#
# The script has been designed to be idempotent, that is, if can be
# run over again with no ill effects.
#
# This script is somewhat rudimentary and has not been extensively
# tested. If it fails on some part of the installation, there is no
# guarantee that fixing the specific issue and simply re-running will
# produce the desired result.  Bug reports, and even better, bug
# fixes, will be greatly appreciated.


PREFERENCES_FILE='.install_openvdm_sample_data_preferences'

###########################################################################
###########################################################################
function exit_gracefully {
    echo Exiting.

    return -1 2> /dev/null || exit -1  # exit correctly if sourced/bashed
}

#########################################################################
#########################################################################
# Return a normalized yes/no for a value
yes_no() {
    QUESTION=$1
    DEFAULT_ANSWER=$2

    while true; do
        read -p "$QUESTION ($DEFAULT_ANSWER) " yn
        case $yn in
            [Yy]* )
                YES_NO_RESULT=yes
                break;;
            [Nn]* )
                YES_NO_RESULT=no
                break;;
            "" )
                YES_NO_RESULT=$DEFAULT_ANSWER
                break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

###########################################################################
###########################################################################
# Read any pre-saved default variables from file
function set_default_variables {
    # Defaults that will be overwritten by the preferences file, if it
    # exists.
    DEFAULT_INSTALL_ROOT=/opt

    DEFAULT_SAMPLE_DATA_ROOT=/vault/sample_data

    DEFAULT_OPENVDM_REPO=https://github.com/oceandatatools/openvdm_sample_data
    DEFAULT_OPENVDM_BRANCH=master

    DEFAULT_OPENVDM_USER=survey

    # Read in the preferences file, if it exists, to overwrite the defaults.
    if [ -e $PREFERENCES_FILE ]; then
        echo Reading pre-saved defaults from "$PREFERENCES_FILE"
        source $PREFERENCES_FILE
        echo branch $DEFAULT_OPENVDM_BRANCH
    fi
}


###########################################################################
###########################################################################
# Save defaults in a preferences file for the next time we run.
function save_default_variables {
    cat > $PREFERENCES_FILE <<EOF
# Defaults written by/to be read by install_sample_data.sh

DEFAULT_HOSTNAME=$HOSTNAME
DEFAULT_INSTALL_ROOT=$INSTALL_ROOT

DEFAULT_SAMPLE_DATA_ROOT=$SAMPLE_DATA_ROOT

DEFAULT_OPENVDM_REPO=$OPENVDM_REPO
DEFAULT_OPENVDM_BRANCH=$OPENVDM_BRANCH

DEFAULT_OPENVDM_USER=$OPENVDM_USER

EOF
}


###########################################################################
###########################################################################
# Create user
function verify_user {

    OPENVDM_USER=$1

    echo "Verifying user $OPENVDM_USER exists"
    if ! id -u $OPENVDM_USER > /dev/null; then
        echo User does not exists, exiting
        exit_gracefully
    fi

}

###########################################################################
###########################################################################
# Install and configure required packages
function install_packages {

    apt-get update

}

###########################################################################
###########################################################################
# Install and configure database
function configure_samba {

    mv /etc/samba/smb.conf /etc/samba/smb.conf.orig

    sed -e '/### Added by openvdm_sample_data install script ###/,/### Added by openvdm_sample_data install script ###/d' /etc/samba/smb.conf.orig |
    sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'  > /etc/samba/smb.conf
    
    cat >> /etc/samba/smb.conf <<EOF

/### Added by openvdm_sample_data install script ###
include = /etc/samba/openvdm_sample_data.conf
/### Added by openvdm_sample_data install script ###
EOF

    cat > /etc/samba/openvdm_sample_data.conf <<EOF
# SMB Shares for OpenVDM

[SampleAuthSource]
  comment=Sample Data, read-only non-guest access
  path=${SAMPLE_DATA_ROOT}/auth_source
  browsable = yes
  public = yes
  hide unreadable = yes
  guest ok = no
  writable = no

[SampleAnonSource]
  comment=Sample Data, read-only guest access
  path=${SAMPLE_DATA_ROOT}/anon_source
  browsable = yes
  public = yes
  hide unreadable = yes
  guest ok = yes
  writable = no

[SampleAuthDestination]
  comment=Sample Destination, non-guest access 
  path=${SAMPLE_DATA_ROOT}/auth_destination
  browsable = yes
  public = yes
  hide unreadable = yes
  guest ok = no
  writable = yes
  write list = ${OPENVDM_USER}
  create mask = 0644
  directory mask = 0755
  veto files = /._*/.DS_Store/.Trashes*/
  delete veto files = yes

[SampleAnonDestination]
  comment=Sample Destination, guest write access 
  path=${SAMPLE_DATA_ROOT}/anon_destination
  browseable = yes
  public = yes
  guest ok = yes
  writable = yes
  create mask = 0000
  directory mask = 0000
  veto files = /._*/.DS_Store/.Trashes*/
  delete veto files = yes
  force create mode = 666
  force directory mode = 777
EOF

    echo "Restarting Samba Service"
    systemctl restart smbd.service
}


###########################################################################
###########################################################################
# Install and configure database
function configure_rsync {

    if [ -e /etc/rsyncd.conf ]; then

        mv /etc/rsyncd.conf /etc/rsyncd.conf.orig
        sed -e '/### Added by openvdm_sample_data install script ###/,/### Added by openvdm_sample_data install script ###/d' /etc/rsyncd.conf.orig |
        sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'  > /etc/rsyncd.conf
    fi

    cat >> /etc/rsyncd.conf <<EOF

/### Added by openvdm_sample_data install script ###

# Global configuration of the rsync service
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid

# Data source information
[sample_data]
    path = ${SAMPLE_DATA_ROOT}/rsync_source
    uid = ${OPENVDM_USER}
    gid = ${OPENVDM_USER}
    read only = yes
    list = yes
    auth users = ${OPENVDM_USER}
    secrets file = /etc/rsyncd.passwd
    hosts allow = 127.0.0.1/255.255.255.0

# Data source information
[sample_dest]
    path = ${SAMPLE_DATA_ROOT}/rsync_destination
    uid = ${OPENVDM_USER}
    gid = ${OPENVDM_USER}
    read only = no
    list = yes
    auth users = ${OPENVDM_USER}
    secrets file = /etc/rsyncd.passwd
    hosts allow = 127.0.0.1/255.255.255.0

/### Added by openvdm_sample_data install script ###
EOF

    if [ -e /etc/rsyncd.passwd ]; then

        mv /etc/rsyncd.passwd /etc/rsyncd.passwd.orig
        sed -e '/### Added by openvdm_sample_data install script ###/,/### Added by openvdm_sample_data install script ###/d' /etc/rsyncd.passwd.orig |
        sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'  > /etc/rsyncd.passwd
    fi

    cat >> /etc/rsyncd.passwd <<EOF
/### Added by openvdm_sample_data install script ###/

${OPENVDM_USER}:b4dPassword!

/### Added by openvdm_sample_data install script ###/
EOF

    chmod 600 /etc/rsyncd.passwd

    echo "Restarting Samba Service"
    systemctl start rsync.service
    systemctl enable rsync.service
}

function configure_directories {

    if [ ! -d $SAMPLE_DATA_ROOT ]; then
        while true; do
            read -p "Sample data directory ${SAMPLE_DATA_ROOT} does not exists... create it? (yes) " yn
            case $yn in
                [Yy]* )

                    mkdir -p ${SAMPLE_DATA_ROOT}

                    tar xvzf ~/openvdm_sample_data/sample_data.tgz -C ${SAMPLE_DATA_ROOT}

                    chmod -R 777 ${SAMPLE_DATA_ROOT}/anon_destination

                    chmod -R 777 ${SAMPLE_DATA_ROOT}/anon_source

                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/auth_destination

                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/auth_source

                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/local_destination

                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/rsync_destination
                    
                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/rsync_source

                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/ssdw
                    
                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/ssh_destination
                    
                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/ssh_source

                    break;;
                "" )

                    mkdir -p ${SAMPLE_DATA_ROOT}

                    tar xvzf ~/openvdm_sample_data/sample_data.tgz -C ${SAMPLE_DATA_ROOT}

                    chmod -R 777 ${SAMPLE_DATA_ROOT}/anon_destination

                    chmod -R 777 ${SAMPLE_DATA_ROOT}/anon_source

                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/auth_destination

                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/auth_source

                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/local_destination

                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/rsync_destination
                    
                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/rsync_source

                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/ssdw
                    
                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/ssh_destination
                    
                    chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/ssh_source

                    break;;
                [Nn]* )
                    echo "Quitting"
                    exit_gracefully;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    else

        tar xvzf ~/openvdm_sample_data/sample_data.tgz -C ${SAMPLE_DATA_ROOT}

        chmod -R 777 ${SAMPLE_DATA_ROOT}/anon_destination

        chmod -R 777 ${SAMPLE_DATA_ROOT}/anon_source

        chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/auth_destination

        chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/auth_source

        chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/local_destination

        chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/rsync_destination
        
        chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/rsync_source

        chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/ssdw
        
        chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/ssh_destination
        
        chown -R ${OPENVDM_USER}:${OPENVDM_USER} ${SAMPLE_DATA_ROOT}/ssh_source

    fi

}


###########################################################################
###########################################################################
# Install OpenVDM
function update_openvdm {
    # Expect the following shell variables to be appropriately set:
    # DATA_ROOT - path where data will be stored is
    # OPENVDM_USER - valid userid
    # OPENVDM_REPO - path to OpenVDM repo
    # OPENVDM_BRANCH - branch of rep to install

    startingDir=${PWD}

    if [ ! -d ~/openvdm_sample_data ]; then  # New install
        echo "Downloading OpenVDM Sample Data repository"
        cd ~
        git clone -b $OPENVDM_BRANCH $OPENVDM_REPO ./openvdm_sample_data
        # chown ${OPENVDM_USER}:${OPENVDM_USER} ./openvdm_sample_data

    else
        cd ~/openvdm_sample_data

        if [ -e .git ] ; then   # If we've already got an installation
            echo "Updating existing OpenVDM Sample Data repository"
            git pull
            git checkout $OPENVDM_BRANCH
            git pull

        else
            echo "Reinstalling OpenVDM Sample Data from repository"  # Bad install, re-doing
            cd ..
            rm -rf ./openvdm_sample_data
            git clone -b $OPENVDM_BRANCH $OPENVDM_REPO ./openvdm_sample_data
        fi
    fi

    cd ~/openvdm_sample_data


    read -p "Samba Password for ${DEFAULT_OPENVDM_USER}? " OPENVDM_SMBUSER_PASSWD
    read -p "MySQL Server root password? " DATABASE_ROOT_PASSWORD

    DB_EXISTS=`mysqlshow --user=root --password=${DATABASE_ROOT_PASSWORD} openvdm | grep -v Wildcard`
    if [ $? == 0 ]; then
        sed -e "s|${DEFAULT_SAMPLE_DATA_ROOT}|${SAMPLE_DATA_ROOT}|" ~/openvdm_sample_data/openvdm_sample_data.sql | \
        sed -e "s/${DEFAULT_OPENVDM_USER}/${OPENVDM_USER}/" | \
        sed -e "s/sample_smb_passwd/${OPENVDM_SMBUSER_PASSWD}/" \
	> ~/openvdm_sample_data/openvdm_sample_data_custom.sql

	      # cat ~/openvdm_sample_data/openvdm_sample_data_custom.sql
        mysql -u root -p${DATABASE_ROOT_PASSWORD} <<EOF
USE openvdm;
source ~/openvdm_sample_data/openvdm_sample_data_custom.sql;
flush privileges;
\q
EOF
        rm ~/openvdm_sample_data/openvdm_sample_data_custom.sql

    else
        echo "Error: openvdm database not found"
        cd ${startingDir}
        exit_gracefully
    fi

    cd ${startingDir}

    cp  ${INSTALL_ROOT}/openvdm/server/plugins/em302_plugin.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/em302_plugin.py
    cp  ${INSTALL_ROOT}/openvdm/server/plugins/parsers/geotiff_parser.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/parsers/geotiff_parser.py

    cp  ${INSTALL_ROOT}/openvdm/server/plugins/openrvdas_plugin.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/openrvdas_plugin.py
    cp  ${INSTALL_ROOT}/openvdm/server/plugins/parsers/gga_parser.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/parsers/gga_parser.py
    cp  ${INSTALL_ROOT}/openvdm/server/plugins/parsers/met_parser.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/parsers/met_parser.py
    cp  ${INSTALL_ROOT}/openvdm/server/plugins/parsers/svp_parser.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/parsers/svp_parser.py
    cp  ${INSTALL_ROOT}/openvdm/server/plugins/parsers/tsg_parser.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/parsers/tsg_parser.py
    cp  ${INSTALL_ROOT}/openvdm/server/plugins/parsers/twind_parser.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/parsers/twind_parser.py

    cp  ${INSTALL_ROOT}/openvdm/server/plugins/rov_openrvdas_plugin.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/rov_openrvdas_plugin.py
    cp  ${INSTALL_ROOT}/openvdm/server/plugins/parsers/comp_pres_parser.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/parsers/comp_pres_parser.py
    cp  ${INSTALL_ROOT}/openvdm/server/plugins/parsers/ctd_parser.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/parsers/ctd_parser.py
    cp  ${INSTALL_ROOT}/openvdm/server/plugins/parsers/o2_parser.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/parsers/o2_parser.py
    cp  ${INSTALL_ROOT}/openvdm/server/plugins/parsers/paro_parser.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/parsers/paro_parser.py
    cp  ${INSTALL_ROOT}/openvdm/server/plugins/parsers/sprint_parser.py.dist ${INSTALL_ROOT}/openvdm/server/plugins/parsers/sprint_parser.py
}


###########################################################################
###########################################################################
###########################################################################
###########################################################################
# Start of actual script
###########################################################################
###########################################################################

# Read from the preferences file in $PREFERENCES_FILE, if it exists
set_default_variables

if [ "$(whoami)" != "root" ]; then
    echo "ERROR: installation script must be run as root."
    exit_gracefully
fi


echo "#####################################################################"
echo "OpenVDM configuration script"

read -p "OpenVDM install root? ($DEFAULT_INSTALL_ROOT) " INSTALL_ROOT
INSTALL_ROOT=${INSTALL_ROOT:-$DEFAULT_INSTALL_ROOT}
echo "Install root will be '$INSTALL_ROOT'"
echo

read -p "Repository to install from? ($DEFAULT_OPENVDM_REPO) " OPENVDM_REPO
OPENVDM_REPO=${OPENVDM_REPO:-$DEFAULT_OPENVDM_REPO}

read -p "Repository branch to install? ($DEFAULT_OPENVDM_BRANCH) " OPENVDM_BRANCH
OPENVDM_BRANCH=${OPENVDM_BRANCH:-$DEFAULT_OPENVDM_BRANCH}

echo "Will install from github.com"
echo "Repository: '$OPENVDM_REPO'"
echo "Branch: '$OPENVDM_BRANCH'"
echo

# Create user if they don't exist yet
echo "#####################################################################"
read -p "OpenVDM user? ($DEFAULT_OPENVDM_USER) " OPENVDM_USER
OPENVDM_USER=${OPENVDM_USER:-$DEFAULT_OPENVDM_USER}
verify_user $OPENVDM_USER

echo

read -p "Root directory for sample data? ($DEFAULT_SAMPLE_DATA_ROOT) " SAMPLE_DATA_ROOT
SAMPLE_DATA_ROOT=${SAMPLE_DATA_ROOT:-$DEFAULT_SAMPLE_DATA_ROOT}


#########################################################################
#########################################################################
# Save defaults in a preferences file for the next time we run.
save_default_variables

#########################################################################
#########################################################################
# Install packages
echo "#####################################################################"
echo "Installing required software packages and libraries"
install_packages

echo "#####################################################################"
echo "Updating OpenVDM"
update_openvdm

echo "#####################################################################"
echo "Creating required directories"
configure_directories

echo "#####################################################################"
echo "Configuring Samba"
configure_samba

echo "#####################################################################"
echo "Configuring Rsync Server"
configure_rsync

echo "#####################################################################"
echo "Before the sample data and tranfer configurations will work you must"
echo "goto the main configuration tab and run the following tasks:"
echo " - Rebuild Cruise Directory"
echo " - Re-export the OpenVDM Configuration"
echo " - Rebuild Lowering Directory (if using lowerings)"
echo " - Re-export the Lowering Configuration (if using lowerings)"
echo " - Rebuild Data Dashboard"
echo " - Rebuild MD5 Summary"
echo "#####################################################################"

#########################################################################
#########################################################################
