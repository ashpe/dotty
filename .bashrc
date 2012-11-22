source ~/.git-completion.sh

export LANG="en_US.UTF-8"
export PERL_BADLANG="0"
export PAGER=less
export EDITOR=/usr/bin/vim
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/sbin:/usr/X11/bin:$PATH

[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

source ~/perl5/perlbrew/etc/bashrc
PS1='\[\033[1;31m\]\u@\h\[\033[1;31m\]:\[\033[00m\]\w\[\033[38;5;55m\]$(__git_ps1 " [%s] ")\[\033[1;31m\]\$ \[\033[00m\] '

tt() { perl -MTemplate -E "Template->new->process(\'$@', undef, \$out); say $out"; }    
tmouse() { for i in resize-pane select-pane select-window; do tmux set mouse-$i $1; done; }
perlat() { for i in $@; do PATHSEP=: prepend_envvar_at PERL5LIB $i; done; }

prepend_envvar() {
    local envvar=$1
    local pathsep=${PATHSEP:-:}
    eval "local envval=\$(strip_envvar \$$envvar $2)"
    if test -z $envval; then
        eval "export $envvar=\"$2\""
    else
        eval "export $envvar=\"$2$pathsep$envval\""
    fi
    #eval "echo \$envvar=\$$envvar"
}
prepend_envvar_at() {
    cd $2 || return
    prepend_envvar_here $1
    cd - >> /dev/null
}

envvar_contains() {
    local pathsep=${PATHSEP:-:}
    eval "echo \$$1" | egrep -q "(^|$pathsep)$2($pathsep|\$)";
}

strip_envvar() {
    [ $# -gt 1 ] || return;

    local pathsep=${PATHSEP:-:}
    local haystack=$1
    local needle=$2
    echo $haystack | sed -e "s%^${needle}\$%%" \
                   | sed -e "s%^${needle}${pathsep}%%" \
                   | sed -e "s%${pathsep}${needle}\$%%" \
                   | sed -e "s%${pathsep}${needle}${pathsep}%${pathsep}%"
}


prepend_envvar_here() { prepend_envvar $1 $(pwd); }


alias profile='source ~/.bashrc'

export PKG_CONFIG_PATH=~/src/game/protocol_buffers/
export HISTIGNORE="&:[bf]g:exit"
export PERL_CPANM_OPT="--sudo"
update-uselect() {
    local url=http://users.tpg.com.au/morepats/;
    local file=$(curl -s $url |\
                    egrep -o 'App-USelect-[0-9._]*.tar.gz' |\
                        tail -n 1);
    cpanm $url$file && unset -f uselect;
}
# Grep-and-Vi
gv() {
    ack --heading --break "$@" | uselect -s '!/^\d+[:-]/' | ixargs vim
}
# locate variants - only files or only dirs
flocate() {
    locate "$@" | perl -nlE 'say if -f'
}
# Locate-and-Vi
lv() {
    flocate "$@" | uselect | ixargs evi
}
ixargs() {
    # Read files from stdin into the $files array
    IFS=$'\n';
    set -f ;
    trap 'echo Or maybe not...' INT
    local files=( $(cat) )   # read files from stdin
    trap INT
    set +f ;
    IFS=$' \t\n'

    # Reopen stdin to /dev/tty so that interactive programs work properly
    exec 0</dev/tty

    # Run specified command with the files from stdin
    [ -n "$files" ] && $@ "${files[@]}"
}
fv() {
    find . \( -name .git -prune \) -o -type f -not -iname '.*.sw?' \
                | sort | fgrep "$@" | uselect | ixargs vim
}

### Functions ###

yamldump() {
perl -MData::Dumper::Concise -MYAML -e \
        'print qq("$_" =>\n), Dumper(YAML::LoadFile($_)) for @ARGV' $@
}


### functions ###
yaml2csv() { perl -MYAML::XS -MText::CSV::Slurp -0e 'print Text::CSV::Slurp->new->create(input => Load(<>))'; }

function yaml_to_meta() {
    SD_WSDEFAULTS_PATH=core/conf/ SD_CONF_FILE=~/src/surveys/development/deecd/census-2012/default/conf/config.pl /usr/bin/env perl -Ibuild/lib -Icore/lib core/bin/ws-yml-map Meta < $1.yaml
}

function yaml_to_xlsx() {
SD_WSDEFAULTS_PATH=core/conf/ SD_CONF_FILE=~/src/surveys/development/deecd/census-2012/default/conf/config.pl /usr/bin/env perl -Ibuild/lib -Icore/lib core/bin/ws-yml-map -m=$2 'Keep(session_key, selected_language_detail)' Flatten Empty Dump 'XLSX('$1.xlsx')' Null < $1.yaml
}

function yaml_to_keep() {
SD_WSDEFAULTS_PATH=core/conf/ SD_CONF_FILE=~/src/surveys/development/deecd/census-2012/default/conf/config.pl /usr/bin/env perl -Ibuild/lib -Icore/lib core/bin/ws-yml-map 'Keep(session_key, selected_language_detail)'  < $1.yaml
}

function yaml_to_xls() {
    SD_WSDEFAULTS_PATH=core/conf/ SD_CONF_FILE=~/src/surveys/development/deecd/census-2012/default/conf/config.pl /usr/bin/env perl -Ibuild/lib -Icore/lib core/bin/ws-yml-map Flatten Empty Dump 'XLS('$1.xls')' Null < $1.yaml
}

function yaml_to_csv() {
    SD_WSDEFAULTS_PATH=core/conf/ SD_CONF_FILE=~/src/surveys/production/deecd/kindergarten-census-2012/part-b/conf/config.pl /usr/bin/env perl -Ibuild/lib -Icore/lib core/bin/ws-yml-map Empty Dump 'CSV('$1.csv')' Null < $1.yaml
}

leak() { perl -ple 'print STDERR'; }

### Aliases ###
alias http="plackup -MPlack::App::Directory -e 'Plack::App::Directory->new({ root => \$ENV{PWD} })->to_app;'"
alias RM='rm -rf'
alias vi='vim'


alias tmux_websurvey='tmuxinator start websurvey-setup'
alias ssh='ssh -AY'
alias http="plackup -MPlack::App::Directory -e 'Plack::App::Directory->new({ root => \$ENV{PWD} })->to_app;'"
alias footytips='ssh ashpe@173.231.53.150'
alias homepc='ssh ashpe@203.132.88.127'
alias ll='ls -l -G'
alias ls='ls -G'
alias la='ls -la -G'
alias RM='rm -rf'
alias perlsw='perl -Mstrict -Mwarnings'
alias perldd='perl -MData::Dumper'
alias perlxxx='perl -MXXX'
alias GETf='GET -UseS'
alias POSTf='POST -UseS'
alias HEADf='HEAD -UseS'
alias i=clear
alias scpresume="rsync --partial --progress --rsh=ssh"
alias v='vim'
alias vi='vim'
alias im='vim'
alias :e='vim'
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin

alias ..='cd ..'
alias ..1='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'
alias ..6='cd ../../../../../..'
alias ..6='cd ../../../../../../..'
alias ..7='cd ../../../../../../../..'
alias ..8='cd ../../../../../../../../..'
alias ..9='cd ../../../../../../../../../..'

alias gst='git status'
alias gbr='git branch'
alias gd='git diff'
alias gdp='gd | vim -'
alias gdc='git diff --cached'
alias gdcp='gdc | vim -'
alias ga='git add'
alias gau='git add -u'
alias gco='git checkout'
alias gci='git commit -v'
alias gcim='git commit -v -m'
alias gcia='git commit -v -a'
alias gciam='git commit -v -a -m'
alias gl='git log'
alias glol='git log --pretty=oneline'
alias glop='git log -p -1'
alias guppy='gup && gpu'
alias sup='git stash && gup && git stash pop'
alias suppy='git stash && gup && gpu && git stash pop'
alias gls='git ls-files --exclude-standard'
alias gcp='git cherry-pick -x'
alias grh='git reset --hard HEAD'
alias gundo='git reset HEAD^'
alias gsr='git svn rebase'
alias gsdc='git svn dcommit'


