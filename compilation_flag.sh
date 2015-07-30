#!/bin/bash

SRC_FOLDER=src

__what() {
    cat <<EOF

(*
Local Variables:
compile-command: "make -C .."
End:
*)
EOF
}

__compilation_flag() {
    local compilation_flag="$(__what)"
    for file in $(ls $SRC_FOLDER/*.{ml,mli});
    do
        [[ "$(grep compile-command $file)" ]] ||
            echo "$compilation_flag" >> $file
    done
}

__compilation_flag "$@"
