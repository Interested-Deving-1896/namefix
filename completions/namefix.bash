# Bash completion for namefix
# https://github.com/pinkorca/namefix

_namefix() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    opts="-c --check -f --fix -u --undo -d --dry-run -i --interactive -b --batch -r --recursive -j --json -v --verbose -q --quiet -s --strategy -h --help --version"

    case "${prev}" in
        -s|--strategy)
            COMPREPLY=($(compgen -W "underscore hyphen remove" -- "${cur}"))
            return 0
            ;;
    esac

    if [[ "${cur}" == -* ]]; then
        COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
    else
        COMPREPLY=($(compgen -d -- "${cur}"))
    fi
}

complete -F _namefix namefix
