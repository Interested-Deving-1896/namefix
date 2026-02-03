# Fish completion for namefix
# https://github.com/pinkorca/namefix

# Disable file completion by default
complete -c namefix -f

# Options
complete -c namefix -s c -l check -d 'Check for issues only (default)'
complete -c namefix -s f -l fix -d 'Sanitize problematic filenames'
complete -c namefix -s u -l undo -d 'Restore original filenames from backup'
complete -c namefix -s d -l dry-run -d 'Preview changes without applying'
complete -c namefix -s i -l interactive -d 'Prompt before each rename'
complete -c namefix -s b -l batch -d 'Apply fixes without prompting'
complete -c namefix -s r -l recursive -d 'Process subdirectories recursively'
complete -c namefix -s j -l json -d 'Output in JSON format'
complete -c namefix -s v -l verbose -d 'Show detailed output'
complete -c namefix -s q -l quiet -d 'Suppress non-essential output'
complete -c namefix -s h -l help -d 'Show help'
complete -c namefix -l version -d 'Show version'

# Strategy option with completions
complete -c namefix -s s -l strategy -d 'Sanitization strategy' -x -a '
    underscore\t"Replace with underscores (default)"
    hyphen\t"Replace with hyphens"
    remove\t"Remove problematic characters"
'

# Directory argument
complete -c namefix -a '(__fish_complete_directories)' -d 'Directory'
