function dclean --description 'Prune stopped docker containers and untagged images with confirmation, translated from inc/functions.zsh'
    question "Do you really want to delete all stopped 🐳  docker containers?" "yn"
    read -s -n 1 ask
    printf '%s> %s%s\n' "$PC_ANSWER" "$ask" "$PC_RESET"

    if test "$ask" = y
        docker container prune --filter 'label=name!=splunk' --force
    else
        abort "no docker containers to clean"
    end

    set -e ask

    question "Do you really want to delete all untagged 🐳  docker images?" "yn"
    read -s -n 1 ask
    printf '%s> %s%s\n' "$PC_ANSWER" "$ask" "$PC_RESET"

    if test "$ask" = y
        docker image prune --force
    else
        abort "no docker images to clean"
    end

    set -e ask
end
