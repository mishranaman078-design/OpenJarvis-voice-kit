#!/bin/bash
# Double-click to talk to Jarvis. Press Ctrl + C or close the window to stop.
OLLAMA="$HOME/.local/bin/ollama"

# Start the brain if it isn't running yet (for example, after a restart).
if ! "$OLLAMA" list >/dev/null 2>&1; then
  echo "Waking up Jarvis..."
  open -ga Ollama
  for _ in $(seq 1 30); do
    "$OLLAMA" list >/dev/null 2>&1 && break
    sleep 1
  done
fi

if ! "$OLLAMA" list >/dev/null 2>&1; then
  echo "Jarvis's brain did not start. Open the Ollama app from Applications, then try again."
  read -r -p "Press Enter to close."
  exit 1
fi

clear
echo "Jarvis is ready."
echo "Press Enter, then speak. Press Ctrl + C to stop."
echo
exec "$HOME/.local/bin/jarvis" chat --voice
