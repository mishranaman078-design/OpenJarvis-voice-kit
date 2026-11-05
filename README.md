# OpenJarvis Voice Kit

A free voice assistant that runs on your own Mac. It adds voice commands and safer defaults on top of [OpenJarvis](https://github.com/open-jarvis/OpenJarvis).

This is an unofficial community project. It isn't made by or linked to the OpenJarvis team, Marvel, Google, YouTube, Spotify or Telegram.

## What it adds

- **Your day:** "Good morning Jarvis, what is my day like?" answers from your real Google Calendar and Gmail.
- **YouTube:** "Open [any show] on YouTube" opens the top video.
- **Spotify:** "Play [any song] on Spotify" opens the search page. You press play.
- **Web search:** "Search for [anything]" gives a short answer and lists websites.
- **Free voice:** speaking and listening both run on your Mac, with no credits.
- **Desktop icon:** double-click and talk.
- **Telegram:** chat from your phone, locked to your account only.
- **PDF, translate, web and research jobs:** using the `jarvis-do` command.

## Safer defaults

- Google access is **read-only**. Jarvis can't send, change or delete email or events.
- Commands on your computer are turned off.
- Pasted secrets stay hidden.
- Email, calendar and search results are kept out of long-term memory.
- Usage statistics are off.

## What you need

- A Mac with Apple Silicon and 8 GB of memory or more
- About 10 GB of free space
- Internet for the setup

Everything in this kit is free. Google and Telegram accounts are only needed for those features.

## Install

Download this project, open Terminal in its folder, and run:

```bash
bash install.sh
```

It takes a while and downloads a few GB. It installs OpenJarvis, Ollama, uv and Rust. Please read `install.sh` first, because you should always know what a script does before you run it.

## Use it

Double-click **Talk to Jarvis** on your Desktop. Press **Enter** before each thing you say. Press **Ctrl + C** to stop.

## Connect Gmail and Calendar (optional)

You need your own free Google project, so your data stays between you and Google.

1. In [Google Cloud](https://console.cloud.google.com/projectcreate), create a project called `Jarvis`.
2. [Turn on these services](https://console.cloud.google.com/flows/enableapi?apiid=gmail.googleapis.com,calendar-json.googleapis.com,drive.googleapis.com,people.googleapis.com,tasks.googleapis.com).
3. [Set up the login screen](https://console.cloud.google.com/auth/overview), with the audience set to **External**.
4. [Add yourself as a test user](https://console.cloud.google.com/auth/audience).
5. [Create a client](https://console.cloud.google.com/auth/clients) of type **Desktop app**.
6. Run `jarvis connect gdrive` and paste the Client ID and Secret, once each.
7. Approve read-only access in your browser. If no window opens, the login may need to be opened by hand.

In test mode, Google may ask you to log in again about once a week.

## Connect Telegram (optional)

1. In Telegram, message **@BotFather**, send `/newbot`, and copy the token.
2. Run `bash ~/.openjarvis/set-telegram.sh`, then follow the steps.
3. Run `jarvis start --host 127.0.0.1`.

The bot only replies while your Mac is on, awake and running the server. Messages pass through Telegram's servers.

## Known limits

- **The small brain makes mistakes.** Check anything important, especially for studies or exams.
- **Hindi translation is unreliable.** In testing it got the meaning wrong.
- **It can mishear you,** especially names.
- **YouTube opens the top result,** which may not be the official video.
- **It uses a lot of memory on 8 GB.** Close other big apps if your Mac slows down.
- **It stays on one OpenJarvis version.** Running `jarvis self-update` may undo this kit's changes.
- **The installer hasn't been tested on a fresh Mac yet.** The patch has only been checked against a clean copy of OpenJarvis, so please report anything that breaks.

## Privacy

Never share your `~/.openjarvis` folder. It holds your keys, logins and memory.

## Credits and licence

Built on [OpenJarvis](https://github.com/open-jarvis/OpenJarvis), under the Apache License 2.0. See `LICENSE` and `NOTICE`.

Uses Kokoro for speech, faster-whisper for listening, and Ollama to run the brain.
