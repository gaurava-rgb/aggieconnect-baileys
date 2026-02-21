# Aggie Connect — Baileys Instance

## What this is

A/B test instance of the Aggie Connect WhatsApp bot, running **alongside** the production
`whatsapp-web.js` bot at `/root/aggieconnect`. Both bots monitor the same WhatsApp groups
and run on the same VPS (`agconnect`) and Supabase project.

## Why

`whatsapp-web.js` drives a headless Chrome browser via Puppeteer. It has known issues with
silent WebSocket drops (zombie state). `@whiskeysockets/baileys` is a pure Node.js
implementation of the WhatsApp Web protocol — much lighter (~20 MB vs ~200 MB RAM) and
more reliable for long-running server processes.

## What's different

| Thing              | whatsapp-web.js bot      | This (Baileys) bot         |
|--------------------|--------------------------|----------------------------|
| WA library         | whatsapp-web.js          | @whiskeysockets/baileys    |
| Auth storage       | .wwebjs_auth/            | .baileys_auth/             |
| DB tables          | requests, message_log, matches | baileys_requests, baileys_message_log, baileys_matches |
| Group table        | monitored_groups (shared)| monitored_groups (shared)  |
| Dashboard port     | 3000                     | 3002                       |
| Monitor port       | 3001                     | 3003                       |
| PM2 names          | aggie-bot, aggie-dash, aggie-monitor | aggie-baileys-bot, aggie-baileys-dash, aggie-baileys-monitor |
| Backfill mechanism | chat.fetchMessages()     | messaging-history.set event|
| Watchdog check     | client.getState()        | sock.user null check       |

## What's identical

- `parser.js` — same LLM prompt, same model
- `matcher.js` — same scoring logic
- `normalize.js` — same location normalization
- `monitored_groups` Supabase table — activating a group monitors it in BOTH bots

## Deployment

Same flow as the main bot: local → git push → `ssh agconnect "cd /root/aggieconnect-baileys && git pull && pm2 restart ecosystem.config.js"`

## First run

On first start, the bot will print a QR code. Scan it with WhatsApp (same account as the
main bot — it will appear as a second linked device). After scanning, auth is persisted
in `.baileys_auth/` and the bot will reconnect automatically without rescanning.
