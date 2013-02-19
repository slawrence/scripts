#!/bin/bash
# Help from: http://www.leancrew.com/all-this/2010/12/batch-comparison-of-git-repositories/

declare fetch=false

while getopts ":f" opt; do
    case $opt in
        f)
            echo " Executing git fetch for repos..."
            fetch=true
            ;;
    esac
done

main() {
    local -a repos=(~/repos/* ~/.vim ~/dot_files ~/bin)
    for path in "${repos[@]}"; do
        check_repo "$path"
    done
}

check_repo() {
    local path="$1"
    local name="`basename "$path"`"
    local report=""
    if [ ! -d "$path" ]; then
        echo -e "$name\n not a directory: $path"
        return
    fi

    cd $"$path"
    if $fetch; then
        git fetch --quiet origin 2>/dev/null
    fi
    if [ "`git diff HEAD origin/HEAD 2> /dev/null`" ]; then
        report+="\n --> Out of sync with origin/HEAD"
    fi
    if [ "`git ls-files --other --exclude-standard 2> /dev/null`" ]; then
        report+="\n --> Untracked files present"
    fi
    if [ "`git diff --cached --shortstat 2> /dev/null`" ]; then
        report+="\n --> Changes to be committed"
    fi
    if [ "`git diff --shortstat 2> /dev/null`" ]; then
        report+="\n --> Changes to be staged/committed"
    fi

    cd - > /dev/null
    if [ -z "$report" ]; then
        report+="\n --> OK"
    fi
    echo -e "$name$report"
}

main
