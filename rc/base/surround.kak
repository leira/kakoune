def -docstring %{surround-selection <opening> [<closing>]: surround the current selection with <opening> and <closing>
If only <opening> is provided, it will be used as <closing> too.
If <opening> is one of \"{[(<>)]}\" and no <closing> is provided, a matching pair will be used.} \
    surround-selection -params 1..2 %{
    %sh{
        exec_proof() {
            ## Replace the '<' sign that is interpreted differently in `exec`
            printf %s\\n "$@" | sed 's,<,<lt>,g'
        }

		opening="$1"
		closing="$2"

        if [ -z "${opening}" ]; then
            echo "echo -debug 'No <opening> provided, could not surround the selection'"
            exit
        fi

        if [ -z "${closing}" ]; then
            case "${opening}" in
                ['<>'])
                    opening='<'; closing='>' ;;
                ['()'])
                    opening='('; closing=')' ;;
                ['[]'])
                    opening='['; closing=']' ;;
                ['{}'])
                    opening='{'; closing='}' ;;
                *)
                    closing="${opening}" ;;
            esac
        fi

        readonly opening=$(exec_proof "${opening}")
        readonly closing=$(exec_proof "${closing}")

		printf %s\\n "echo -debug '${opening}:${closing}'"

        printf %s\\n "eval -draft %{ try %{
            ## The selection is empty
            exec <a-K>\\A[\\h\\v\\n]*\\z<ret>

            ## surround the selection
            exec -draft %{a${closing}<esc>i${opening}}
        } }"
    }
}

