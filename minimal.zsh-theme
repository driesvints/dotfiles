# Global settings
MNML_OK_COLOR="${MNML_OK_COLOR:-2}"
MNML_ERR_COLOR="${MNML_ERR_COLOR:-1}"

MNML_USER_CHAR="${MNML_USER_CHAR:-λ}"
MNML_INSERT_CHAR="${MNML_INSERT_CHAR:-›}"
MNML_NORMAL_CHAR="${MNML_NORMAL_CHAR:-·}"
MNML_ELLIPSIS_CHAR="${MNML_ELLIPSIS_CHAR:-..}"
MNML_BGJOB_MODE=${MNML_BGJOB_MODE:-4}

[ "${+MNML_PROMPT}" -eq 0 ] && MNML_PROMPT=(mnml_ssh mnml_pyenv mnml_status mnml_keymap)
[ "${+MNML_RPROMPT}" -eq 0 ] && MNML_RPROMPT=('mnml_cwd 2 0' mnml_git)
[ "${+MNML_INFOLN}" -eq 0 ] && MNML_INFOLN=(mnml_err mnml_jobs mnml_uhp mnml_files)

[ "${+MNML_MAGICENTER}" -eq 0 ] && MNML_MAGICENTER=(mnml_me_dirs mnml_me_ls mnml_me_git)

# Components
function mnml_status {
    local okc="$MNML_OK_COLOR"
    local errc="$MNML_ERR_COLOR"
    local uchar="$MNML_USER_CHAR"

    local job_ansi="0"
    if [ -n "$(jobs | sed -n '$=')" ]; then
        job_ansi="$MNML_BGJOB_MODE"
    fi

    local err_ansi="$MNML_OK_COLOR"
    if [ "$MNML_LAST_ERR" != "0" ]; then
        err_ansi="$MNML_ERR_COLOR"
    fi

    printf '%b' "%{\e[$job_ansi;3${err_ansi}m%}%(!.#.$uchar)%{\e[0m%}"
}

function mnml_keymap {
    local kmstat="$MNML_INSERT_CHAR"
    [ "$KEYMAP" = 'vicmd' ] && kmstat="$MNML_NORMAL_CHAR"
    printf '%b' "$kmstat"
}

function mnml_cwd {
    local echar="$MNML_ELLIPSIS_CHAR"
    local segments="${1:-2}"
    local seg_len="${2:-0}"

    local _w="%{\e[0m%}"
    local _g="%{\e[38;5;244m%}"

    if [ "$segments" -le 0 ]; then
        segments=0
    fi
    if [ "$seg_len" -gt 0 ] && [ "$seg_len" -lt 4 ]; then
        seg_len=4
    fi
    local seg_hlen=$((seg_len / 2 - 1))

    local cwd="%${segments}~"
    cwd="${(%)cwd}"
    cwd=("${(@s:/:)cwd}")

    local pi=""
    for i in {1..${#cwd}}; do
        pi="$cwd[$i]"
        if [ "$seg_len" -gt 0 ] && [ "${#pi}" -gt "$seg_len" ]; then
            cwd[$i]="${pi:0:$seg_hlen}$_w$echar$_g${pi: -$seg_hlen}"
        fi
    done

    printf '%b' "$_g${(j:/:)cwd//\//$_w/$_g}$_w"
}

function mnml_git {
    local statc="%{\e[0;3${MNML_OK_COLOR}m%}" # assume clean
    local bname="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"

    if [ -n "$bname" ]; then
        if [ -n "$(git status --porcelain 2> /dev/null)" ]; then
            statc="%{\e[0;3${MNML_ERR_COLOR}m%}"
        fi
        printf '%b' "$statc$bname%{\e[0m%}"
    fi
}

function mnml_hg {
    local statc="%{\e[0;3${MNML_OK_COLOR}m%}" # assume clean
    local bname="$(hg branch 2> /dev/null)"
    if [ -n "$bname" ]; then
        if [ -n "$(hg status 2> /dev/null)" ]; then
            statc="%{\e[0;3${MNML_ERR_COLOR}m%}"
        fi
        printf '%b' "$statc$bname%{\e[0m%}"
    fi
}

function mnml_hg_no_color {
    # Assume branch name is clean
    local statc="%{\e[0;3${MNML_OK_COLOR}m%}"
    local bname=""
    # Defines path as current directory
    local current_dir=$PWD
    # While current path is not root path
    while [[ $current_dir != '/' ]]
    do
        if [[ -d "${current_dir}/.hg" ]]
        then
            if [[ -f "$current_dir/.hg/branch" ]]
            then
                bname=$(<"$current_dir/.hg/branch")
            else
                bname="default"
            fi
            printf '%b' "$statc$bname%{\e[0m%}"
            return;
        fi
        # Defines path as parent directory and keeps looking for :)
        current_dir="${current_dir:h}"
   done
}

function mnml_uhp {
    local _w="%{\e[0m%}"
    local _g="%{\e[38;5;244m%}"
    local cwd="%~"
    cwd="${(%)cwd}"

    printf '%b' "$_g%n$_w@$_g%m$_w:$_g${cwd//\//$_w/$_g}$_w"
}

function mnml_ssh {
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        printf '%b' "$(hostname -s)"
    fi
}

function mnml_pyenv {
    if [ -n "$VIRTUAL_ENV" ]; then
        _venv="$(basename $VIRTUAL_ENV)"
        printf '%b' "${_venv%%.*}"
    fi
}

function mnml_err {
    local _w="%{\e[0m%}"
    local _err="%{\e[3${MNML_ERR_COLOR}m%}"

    if [ "${MNML_LAST_ERR:-0}" != "0" ]; then
        printf '%b' "$_err$MNML_LAST_ERR$_w"
    fi
}

function mnml_jobs {
    local _w="%{\e[0m%}"
    local _g="%{\e[38;5;244m%}"

    local job_n="$(jobs | sed -n '$=')"
    if [ "$job_n" -gt 0 ]; then
        printf '%b' "$_g$job_n$_w&"
    fi
}

function mnml_files {
    local _w="%{\e[0m%}"
    local _g="%{\e[38;5;244m%}"

    local a_files="$(ls -1A | sed -n '$=')"
    local v_files="$(ls -1 | sed -n '$=')"
    local h_files="$((a_files - v_files))"

    local output="${_w}[$_g${v_files:-0}"
    if [ "${h_files:-0}" -gt 0 ]; then
        output="$output $_w($_g$h_files$_w)"
    fi
    output="$output${_w}]"

    printf '%b' "$output"
}

# Magic enter functions
function mnml_me_dirs {
    local _w="\e[0m"
    local _g="\e[38;5;244m"

    if [ "$(dirs -p | sed -n '$=')" -gt 1 ]; then
        local stack="$(dirs)"
        echo "$_g${stack//\//$_w/$_g}$_w"
    fi
}

function mnml_me_ls {
    if [ "$(uname)" = "Darwin" ] && ! ls --version &> /dev/null; then
        COLUMNS=$COLUMNS CLICOLOR_FORCE=1 ls -C -G -F
    else
        ls -C -F --color="always" -w $COLUMNS
    fi
}

function mnml_me_git {
    git -c color.status=always status -sb 2> /dev/null
}

# Wrappers & utils
# join outpus of components
function _mnml_wrap {
    local -a arr
    arr=()
    local cmd_out=""
    local cmd
    for cmd in ${(P)1}; do
        cmd_out="$(eval "$cmd")"
        if [ -n "$cmd_out" ]; then
            arr+="$cmd_out"
        fi
    done

    printf '%b' "${(j: :)arr}"
}

# expand string as prompt would do
function _mnml_iline {
    echo "${(%)1}"
}

# display magic enter
function _mnml_me {
    local -a output
    output=()
    local cmd_out=""
    local cmd
    for cmd in $MNML_MAGICENTER; do
        cmd_out="$(eval "$cmd")"
        if [ -n "$cmd_out" ]; then
            output+="$cmd_out"
        fi
    done
    printf '%b' "${(j:\n:)output}" | less -XFR
}

# capture exit status and reset prompt
function _mnml_zle-line-init {
    MNML_LAST_ERR="$?" # I need to capture this ASAP
    zle reset-prompt
}

# redraw prompt on keymap select
function _mnml_zle-keymap-select {
    zle reset-prompt
}

# draw infoline if no command is given
function _mnml_buffer-empty {
    if [ -z "$BUFFER" ]; then
        _mnml_iline "$(_mnml_wrap MNML_INFOLN)"
        _mnml_me
        zle redisplay
    else
        zle accept-line
    fi
}

# properly bind widgets
# see: https://github.com/zsh-users/zsh-syntax-highlighting/blob/1f1e629290773bd6f9673f364303219d6da11129/zsh-syntax-highlighting.zsh#L292-L356
function _mnml_bind_widgets() {
    zmodload zsh/zleparameter

    local -a to_bind
    to_bind=(zle-line-init zle-keymap-select buffer-empty)

    typeset -F SECONDS
    local zle_wprefix=s$SECONDS-r$RANDOM

    local cur_widget
    for cur_widget in $to_bind; do
        case "${widgets[$cur_widget]:-""}" in
            user:_mnml_*);;
            user:*)
                zle -N $zle_wprefix-$cur_widget ${widgets[$cur_widget]#*:}
                eval "_mnml_ww_${(q)zle_wprefix}-${(q)cur_widget}() { _mnml_${(q)cur_widget}; zle ${(q)zle_wprefix}-${(q)cur_widget} }"
                zle -N $cur_widget _mnml_ww_$zle_wprefix-$cur_widget
                ;;
            *)
                zle -N $cur_widget _mnml_$cur_widget
                ;;
        esac
    done
}

# Setup
autoload -U colors && colors
setopt prompt_subst

PROMPT='$(_mnml_wrap MNML_PROMPT) '
RPROMPT='$(_mnml_wrap MNML_RPROMPT)'

_mnml_bind_widgets

bindkey -M main  "^M" buffer-empty
bindkey -M vicmd "^M" buffer-empty