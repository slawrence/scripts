#!/bin/bash
# Help from: http://www.leancrew.com/all-this/2010/12/batch-comparison-of-git-repositories/

index=0
gitrepos=()

#TODO: There has got to be a better way to add all these folders to the array
#add repos folder
for d in ~/repos/*; do
    gitrepos[(index+=1)]="$d"
done

#add other important folders
gitrepos[(index+=1)]=~/.vim
gitrepos[(index+=1)]=~/dot_files
gitrepos[(index+=1)]=~/bin

for d in "${gitrepos[@]}"; do
    if [ -e $d ]; then
        cd $d
    else
        echo " Did not find repo: $d"
        continue
    fi

    reponame="`basename $d`"

    ok=true
    git fetch --quiet origin 2>/dev/null
    if [ ! -z "`git diff HEAD origin/HEAD 2> /dev/null`" ]; then
        echo " $reponame --> Out of sync with origin/HEAD"
        ok=false
    fi
    if [ ! -z "`git ls-files --other --exclude-standard 2> /dev/null`" ]; then
        echo " $reponame --> Untracked files present"
        ok=false
    fi
    if [ ! -z "`git diff --cached --shortstat 2> /dev/null`" ]; then
        echo " $reponame --> Changes to be committed"
        ok=false
    fi
    if [ ! -z "`git diff --shortstat 2> /dev/null`" ]; then
        echo " $reponame --> Changes to be staged/committed"
        ok=false
    fi
    if $ok; then
        echo " OK --> $reponame"
    fi
done
