SSH_AGENT_FILE="$HOME/.ssh/ssh_agent"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent > "$SSH_AGENT_FILE"

    chmod 600 "$SSH_AGENT_FILE"
    source "$SSH_AGENT_FILE" > /dev/null
}

if [ -f "$SSH_AGENT_FILE" ]; then
    source "$SSH_AGENT_FILE" > /dev/null
    ps "$SSH_AGENT_PID" > /dev/null || start_agent
else
    start_agent
fi
