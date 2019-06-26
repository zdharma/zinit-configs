# Uses the command-not-found package zsh support
# as seen in http://www.porcheron.info/command-not-found-for-zsh/
# this is installed in Ubuntu

[[ -e /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found

# Arch Linux command-not-found support, you must have package pkgfile installed
# https://wiki.archlinux.org/index.php/Pkgfile#.22Command_not_found.22_hook
[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

#
if command -v prt-get >/dev/null; then
    if (( ! ${+functions[command_not_found_handler]} )) ; then
            function command_not_found_handler {
                    crux_find_package ${1+"$1"} && :
            }
    fi

    crux_find_package() {
        bin=$1
        bin_path=$(prt-get fsearch ${bin} | grep "^  .*${bin}$" | sed 's/^  //g' | sed 1q)
        [[ -z $bin_path ]] && return 1
        pkg_path=$(prt-get fsearch --full "${bin_path}" | sed 1q | sed 's/Found in \(.*\):/\1/g')
        pkg_name=$(basename "${pkg_path}")
        printf "%s\n%s\n" "Command '${bin}' not found, but can be installed with:" \
                          "sudo prt-get depinst ${pkg_name}"
    }

fi
