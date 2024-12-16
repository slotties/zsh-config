autoload -U compinit; compinit

# Autocompletion settings
autoload -U colors && colors
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '[%b]'

export K8S_ITG="something-itg"
export K8S_STG="something-stg"
export K8S_PROD="something-prod"

# TODO: move to own file
function kubectl_ctx_prompt_color() {
	local color="pink"
  local k8s_context=$(k_current)

	if [[ "$k8s_context" == "${K8S_ITG}" ]]; then
                color="green"
        elif [[ "$k8s_context" == "${K8S_STG}" ]]; then
                color="blue"
        elif [[ "$k8s_context" == "${K8S_PROD}" ]]; then
                color="red"
        fi

	echo "%{$fg[$color]%}"
}
PROMPT='%{$reset_color%}%n:%${LENGTH}<..<%B%~%b%{$fg[blue]%} $vcs_info_msg_0_ $(kubectl_ctx_prompt_color)\$%{$reset_color%} '

path=(
    ~/app
    ~/dev/scripts
    /sbin
    /bin
    /usr/sbin
    /usr/bin
    /usr/local/sbin
    /usr/local/bin
)

setopt AUTO_PUSHD  
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT 
setopt auto_cd
unsetopt BEEP

# autocompletion for 'cd ..' etc.
zstyle ':completion:*' special-dirs true

# nvm
export NVM_DIR="$HOME/.nvm"
source "$HOME/.nvm/nvm.sh"

source ~/.zsh_aliases 
source ~/.zsh/custom.completion.kube.config
source ~/.zsh/custom.completion.kustomize.config
source ~/.zsh/custom.completion.npm
source ~/.zsh/custom.completion.pnpm
source ~/.zsh/kafka.plugin.zsh
source ~/.sdkman/bin/sdkman-init.sh

autoload -U select-word-style
select-word-style bash

bindkey "[D" backward-word
bindkey "[C" forward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line

bindkey "^[[A" up-line-or-search
bindkey "^[[B" down-line-or-search

bindkey "^[[0A" up-line-or-search
bindkey "^[[0B" down-line-or-search

# cluster configs
while read config_file
do
  if [[ -z "$KUBECONFIG" ]]
  then
    export KUBECONFIG=$config_file
  else
    export KUBECONFIG="${KUBECONFIG}:${config_file}"
  fi
done < <(find ~/.kube/config* -type f | grep -v deployer)
