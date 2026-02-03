#compdef namefix
# Zsh completion for namefix
# https://github.com/pinkorca/namefix

_namefix() {
    local -a opts strategies

    strategies=(
        'underscore:Replace with underscores (default)'
        'hyphen:Replace with hyphens'
        'remove:Remove problematic characters'
    )

    opts=(
        '(-c --check)'{-c,--check}'[Check for issues only (default)]'
        '(-f --fix)'{-f,--fix}'[Sanitize problematic filenames]'
        '(-u --undo)'{-u,--undo}'[Restore original filenames from backup]'
        '(-d --dry-run)'{-d,--dry-run}'[Preview changes without applying]'
        '(-i --interactive)'{-i,--interactive}'[Prompt before each rename]'
        '(-b --batch)'{-b,--batch}'[Apply fixes without prompting]'
        '(-r --recursive)'{-r,--recursive}'[Process subdirectories recursively]'
        '(-j --json)'{-j,--json}'[Output in JSON format]'
        '(-v --verbose)'{-v,--verbose}'[Show detailed output]'
        '(-q --quiet)'{-q,--quiet}'[Suppress non-essential output]'
        '(-s --strategy)'{-s,--strategy}'[Sanitization strategy]:strategy:->strategy'
        '(-h --help)'{-h,--help}'[Show help]'
        '--version[Show version]'
        '*:directory:_files -/'
    )

    _arguments -s -S $opts

    case $state in
        strategy)
            _describe -t strategies 'strategy' strategies
            ;;
    esac
}

_namefix "$@"
