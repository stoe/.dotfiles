#!/bin/zsh

# add sencha cmd versions to PATH
vs=(
    3.1.2.342
    4.0.5.87
    5.0.3.324
    5.1.3.61
    6.0.0.202
)
for v in $vs; do
    p="$HOME/bin/Sencha/Cmd/$v"

    if [ -d "${p}" ]; then
        # print -P "    %F{8}> $p%f"
        export PATH=${p}:$PATH
        export SENCHA_CMD_3_0_0=${p}
    fi
done

# latest version
alias sencha="$HOME/bin/Sencha/Cmd/sencha";

# sencha cmd plus
alias sc="cmd-plus"

# start a Sencha CMD server
function senchaserver() {
    local ip=localhost          # default host
    local sencha="sencha"

    local port="${1:-1337}"     # if port is defined use it, fallback to default

    local fashion=""
    local fd=""

    # v6 handler
    if [ "${2}" == true -o "${1}" == true ]; then
        fashion="?platformTags=fashion:true"
        fd="?platformTags=%F{3}fashion:true%f"
    fi

    # port fallback
    if [ "${1}" == true ]; then
        port="1337"
    fi

    local pd="%F{3}$port%f"

    clear

    print -P "\n  > %F{8}$(pwd)%f\n"
    print -P "%F{green}sencha server%f started at http://${ip}:${pd}${fd}\n"

    # start server and open location in default browser
    sleep 2 && open -a "/Applications/Google Chrome Canary.app/" "http://${ip}:${port}${fashion}" & ${sencha} -n -q fs web --port "${port}" start -map .
}

# dev
function sar () {
    sencha app refresh "$@"
}

function saw () {
    sencha app watch "$@"
}

# Sencha Space
function wamd {
    local device=""

    case "${1}" in
        iPhone5*)
        device="iPhone-5"
        ;;
        iPhone*)
        device="iPhone-6"
        ;;
        iPad*)
        device="iPad-Air"
        ;;
        *)
        device="iPhone-6"
        ;;
    esac

    clear

    if type ios-sim | grep "not found" > /dev/null 2>&1 ; then
        print -P "\n  > %F{red}npm i -g ios-sim%f first!"
    else
        print -P "launching %F{3}Sencha Web App Manager Debug%f on %F{cyan}${device}%f ...\n"

        ios-sim launch "${HOME}/code/sencha/_space/space-debug/Sencha Dev.app/" --devicetypeid "com.apple.CoreSimulator.SimDeviceType.${device}"
    fi
}
