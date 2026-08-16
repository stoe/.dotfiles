function dstop --description 'Stop all docker containers with confirmation, translated from inc/functions.zsh'
    question "Do you really want to stop all 🐳  docker containers?" "yn"
    read -s -n 1 ask
    printf '%s> %s%s\n' "$PC_ANSWER" "$ask" "$PC_RESET"

    set -l dockerps (docker ps -a -q)

    if test "$ask" = y; and test -n "$dockerps"
        docker stop $dockerps
    else
        abort "no docker containers to stop"
    end
end
