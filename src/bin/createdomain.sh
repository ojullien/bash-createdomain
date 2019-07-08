#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Creates an apache user/group and a home directory in /var/www.
##
## @package ojullien\bash\bin
## @license MIT <https://github.com/ojullien/bash-createdomain/blob/master/LICENSE>
## -----------------------------------------------------------------------------
#set -o errexit
set -o nounset
set -o pipefail

## -----------------------------------------------------------------------------
## Shell scripts directory, eg: /root/work/Shell/src/bin
## -----------------------------------------------------------------------------
readonly m_DIR_REALPATH="$(realpath "$(dirname "$0")")"

## -----------------------------------------------------------------------------
## Load constants
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_REALPATH}/../sys/constant.sh"

## -----------------------------------------------------------------------------
## Includes sources & configuration
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_SYS}/runasroot.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/string.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/filesystem.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/option.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/config.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/service.sh"
# shellcheck source=/dev/null
. "${m_DIR_APP}/clean/app.sh"
Config::load "createdomain"
# shellcheck source=/dev/null
. "${m_DIR_APP}/createdomain/app.sh"

## -----------------------------------------------------------------------------
## Help
## -----------------------------------------------------------------------------
((m_OPTION_SHOWHELP)) && CreateDomain::showHelp && exit 0
(( 0==$# )) && CreateDomain::showHelp && exit 1

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

## -----------------------------------------------------
## Parse the app options and arguments
## -----------------------------------------------------
declare -i iReturn

while (( "$#" )); do
    case "$1" in
    -t|--trace)
        shift
        String::separateLine
        Constant::trace
        CreateDomain::trace
        ;;
    --*|-*) # unknown option
        shift
        String::separateLine
        CreateDomain::showHelp
        exit 0
        ;;
    *) # We presume its a domain name
        String::separateLine
        CreateDomain::create "$1"
        iReturn=$?
        ((0!=iReturn)) && exit ${iReturn}
        shift
        Console::waitUser
        ;;
    esac
done

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
exit 0
