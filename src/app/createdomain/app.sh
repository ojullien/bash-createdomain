## -----------------------------------------------------------------------------
## Linux Scripts.
## CreateDomain app functions
##
## @package ojullien\bash\app\createdomain
## @license MIT <https://github.com/ojullien/bash-createdomain/blob/master/LICENSE>
## -----------------------------------------------------------------------------

CreateDomain::showHelp() {
    String::notice "Usage: $(basename "$0") [options] <domain 1> [domain 2 ...]"
    String::notice "\tCreates an apache user/group and a home directory in /var/www"
    Option::showHelp
    String::notice "\t<domain 1>\tDomain name to create."
    return 0
}

CreateDomain::createGroup() {

    # Parameters
    if (($# != 1)) || [ -z "$1" ]; then
       String::error "Usage: CreateDomain::createGroup <domain name>"
        return 1
    fi

    # Init
    local sDomain="$1"
    local -i iReturn=1

    # Do the job
    String::notice "Creating '${sDomain}' group ..."
    adduser --force-badname --group "${sDomain}"
    iReturn=$?
    String::notice -n "Create '${sDomain}' group:"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

CreateDomain::createUser() {

    # Parameters
    if (($# != 1)) || [ -z "$1" ]; then
        String::error "Usage: CreateDomain::createUser <domain name>"
        return 1
    fi

    # Init
    local sDomain="$1"
    local -i iReturn=1

    # Do the job
    String::notice "Creating '${sDomain}' user ..."
    adduser --quiet --no-create-home --disabled-password --disabled-login --force-badname --home "${m_APACHE2_DOCUMENTROOT:?}/${sDomain}" --shell /bin/false --ingroup="${sDomain}" "${sDomain}"
    iReturn=$?
    String::notice -n "Create '${sDomain}' user:"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

CreateDomain::createDirectories() {

    # Parameters
    if (($# != 1)) || [ -z "$1" ]; then
        String::error "Usage: CreateDomain::createDirectories <domain name>"
        return 1
    fi

    # Init
    local sDomain="$1" sDirectory=""
    local -a aDirectories=( 'config' 'public' 'logs' 'tmp')
    local -i iReturn=1

    # Do the job
    for sDirectory in "${aDirectories[@]}"; do
        FileSystem::createDirectory "${m_APACHE2_DOCUMENTROOT:?}/${sDomain}/${sDirectory}"
        iReturn=$?
        ((0!=iReturn)) && return ${iReturn}
    done
    FileSystem::createDirectory "${m_APACHE2_LOGDIR:?}/${sDomain}"
    iReturn=$?

    return ${iReturn}
}

CreateDomain::changeOwner() {

    # Parameters
    if (($# != 1)) || [ -z "$1" ]; then
        String::error "Usage: CreateDomain::changeOwner <domain name>"
        return 1
    fi

    # Init
    local sDomain="$1"
    local -i iReturn=1

    # Change owner/group and access right

    String::notice -n "Change '${sDomain}' file access right:"
    find "${m_APACHE2_DOCUMENTROOT:?}/${sDomain}/" -type f -exec chmod u=rw,g=r,o= {} \;
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}
    ((0!=iReturn)) && return ${iReturn}

    String::notice -n "Change '${sDomain}' folder access right:"
    find "${m_APACHE2_DOCUMENTROOT}/${sDomain}/" -type d -exec chmod u=rwx,g=rx,o= {} \;
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}
    ((0!=iReturn)) && return ${iReturn}

    String::notice -n "Change '${sDomain}' owner:"
    chown -R "${sDomain}":"${m_APACHE2_GROUP:?}" "${m_APACHE2_DOCUMENTROOT}/${sDomain}/"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

CreateDomain::create() {

    # Parameters
    if (($# != 1)) || [ -z "$1" ]; then
       String::error "Usage: CreateDomain::create <domain name>"
        return 1
    fi

    # Init
    local sDomain="$1"
    local -i iReturn=1

    # Do the job
    CreateDomain::createDirectories "${sDomain}"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    CreateDomain::createGroup "${sDomain}"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    CreateDomain::createUser "${sDomain}"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    CreateDomain::changeOwner "${sDomain}"
    iReturn=$?

    return ${iReturn}
}
