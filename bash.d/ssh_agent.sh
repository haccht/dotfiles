SSH_AGENT_FILE="$HOME/.ssh/ssh_agent"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent > "$SSH_AGENT_FILE"
    chmod 600 "$SSH_AGENT_FILE"
    source "$SSH_AGENT_FILE" > /dev/null
    /usr/bin/ssh-add -l >& /dev/null || {
        /usr/bin/ssh-add $HOME/.ssh/github.key
        /usr/bin/ssh-add $HOME/.ssh/haccht.key
        /usr/bin/ssh-add $HOME/.ssh/id_ecdsa
        /usr/bin/ssh-add $HOME/.ssh/id_rsa
    }
}

if [ -f "$SSH_AGENT_FILE" ]; then
    source "$SSH_AGENT_FILE" > /dev/null
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent$ > /dev/null || { start_agent; }
else
    start_agent;
fi
