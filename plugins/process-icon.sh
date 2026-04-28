#!/usr/bin/env bash
case "$1" in
    nvim|vim|vi)            printf '\xee\x98\xab' ;;  # U+E62B
    python3|python|python2) printf '\xee\x88\xb5' ;;  # U+E235
    node|nodejs)            printf '\xee\x9c\x98' ;;  # U+E718
    docker)                 printf '\xef\x8c\x88' ;;  # U+F308
    git)                    printf '\xee\x9c\x82' ;;  # U+E702
    bash|zsh|sh|fish)       printf '\xef\x92\x89' ;;  # U+F489
    ssh)                    printf '\xef\x83\xa1' ;;  # U+F0E1
    htop|top|btop)          printf '\xef\x82\x80' ;;  # U+F080
    cargo|rustc)            printf '\xee\x9e\xa8' ;;  # U+E7A8
    ruby)                   printf '\xee\x9e\x91' ;;  # U+E791
    go)                     printf '\xef\xb3\x91' ;;  # U+FCD1
    lua)                    printf '\xef\x8b\x82' ;;  # U+F2C2
    make)                   printf '\xef\x84\xa3' ;;  # U+F123
    *)                      echo "" ;;
esac
