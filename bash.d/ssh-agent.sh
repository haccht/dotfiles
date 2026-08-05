SSH_AGENT_FILE="$HOME/.ssh/ssh_agent"

start_agent() {
    mkdir -p "$HOME/.ssh"
    echo "Initialising new SSH agent..."
    ssh-agent > "$SSH_AGENT_FILE"

    chmod 600 "$SSH_AGENT_FILE"
    source "$SSH_AGENT_FILE" > /dev/null
}

if [ -f "$SSH_AGENT_FILE" ]; then
    source "$SSH_AGENT_FILE" > /dev/null
    ps -p "${SSH_AGENT_PID:-}" > /dev/null 2>&1 || start_agent
else
    start_agent
fi
