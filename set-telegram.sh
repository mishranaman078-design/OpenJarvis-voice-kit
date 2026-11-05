#!/bin/bash
# Saves your Telegram bot token in a locked file and locks the bot to YOUR chat.
# The token stays hidden while you paste it, and is never printed.
set -u
echo
echo "Paste your Telegram bot token, then press Enter ONE time."
echo "(It will stay invisible. That is normal.)"
IFS= read -rs TOKEN
echo
export TG_TOKEN="$(printf '%s' "$TOKEN" | tr -d '[:space:]')"
unset TOKEN
if [ -z "$TG_TOKEN" ]; then
  echo "Nothing was pasted. Run this again."
  exit 1
fi
"$HOME/.openjarvis/.venv/bin/python" - <<'PY'
import os, pathlib, sys, tempfile, time

import httpx
import tomlkit

token = os.environ["TG_TOKEN"]
base = f"https://api.telegram.org/bot{token}"


def call(method, **params):
    try:
        return httpx.get(f"{base}/{method}", params=params, timeout=40).json()
    except Exception as exc:  # keep the token out of error messages
        print(f"Could not reach Telegram ({type(exc).__name__}). Nothing was saved.")
        sys.exit(1)


me = call("getMe")
if not me.get("ok"):
    print("Telegram did not accept this token. Nothing was saved.")
    sys.exit(1)
name = me["result"]["username"]
print(f"Token works. Your bot is @{name}")
print()
print(f"Now, on your phone, open Telegram, find @{name}, and send it: hi")
print("Waiting for your message (up to 5 minutes)...")

deadline = time.time() + 300
offset = None
chat = None
while time.time() < deadline and chat is None:
    params = {"timeout": 25}
    if offset:
        params["offset"] = offset
    reply = call("getUpdates", **params)
    for update in reply.get("result", []):
        offset = update["update_id"] + 1
        message = update.get("message") or {}
        if message.get("chat", {}).get("type") == "private":
            chat = message["chat"]
            break
if chat is None:
    print("No message arrived. Nothing was saved. Run this again.")
    sys.exit(1)

# Mark the message as read, so Jarvis does not answer it later.
call("getUpdates", offset=offset, timeout=0)

folder = pathlib.Path.home() / ".openjarvis"
keys = folder / "cloud-keys.env"
lines = keys.read_text().splitlines() if keys.exists() else []
lines = [line for line in lines if not line.startswith("TELEGRAM_BOT_TOKEN=")]
lines.append(f"TELEGRAM_BOT_TOKEN={token}")
handle, temp = tempfile.mkstemp(dir=folder)
os.write(handle, ("\n".join(lines) + "\n").encode())
os.close(handle)
os.chmod(temp, 0o600)
os.replace(temp, keys)

config_path = folder / "config.toml"
config = tomlkit.parse(config_path.read_text())
if "channel" not in config:
    config.add("channel", tomlkit.table())
channel = config["channel"]
channel["enabled"] = True
channel["default_channel"] = "telegram"
channel["default_agent"] = "simple"
if "telegram" not in channel:
    channel["telegram"] = tomlkit.table()
channel["telegram"]["allowed_chat_ids"] = str(chat["id"])
config_path.write_text(tomlkit.dumps(config))

print()
print(f"Locked to one person only: {chat.get('first_name', 'unknown')}")
print("If that is not you, run this again and stop the bot in BotFather.")
print("Saved safely.")
PY
unset TG_TOKEN
