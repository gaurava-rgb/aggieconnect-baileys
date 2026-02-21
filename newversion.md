
---

> **Context:** you just worked on the existing bot It uses `whatsapp-web.js`, Supabase, and has: `bot.js`, `parser.js`, `matcher.js`, `db.js`, `dashboard.js`, `schema.sql` etc. 
>
> **Task:** Create a new folder `aggieconnect-baileys` in `/Users/gauravarora/Documents/` as a carbon copy A/B test that:
>
> 1. Replaces `whatsapp-web.js` with Baileys (`@whiskeysockets/baileys`) in `bot.js` — same group monitoring logic, same backfill, same reconnect behavior, same LLM parsing flow
> 2. Copies `parser.js` and `matcher.js` completely unchanged
> 3. Updates `db.js` to use the same Supabase credentials (read from `.env`) but all table names prefixed with `baileys_` — e.g. `baileys_message_log`, `baileys_requests`, `baileys_matches`
> 4. Copies `dashboard.js` unchanged except pointing to the `baileys_` prefixed tables
> 5. Creates `schema.sql` with identical structure to the original but for `baileys_` prefixed tables
> 6. Separate `package.json` and `node_modules`
> 7. Check existing PM2 processes with `pm2 list` and pick a free port for the dashboard
> 8. PM2 process names: `aggie-baileys-bot` and `aggie-baileys-dashboard`
> 9. Create a `CONTEXT.md` in the new folder explaining: this is a Baileys-based carbon copy of the whatsapp-web.js bot in `documents/aggieconnect`, running as an A/B test on the same VPS, same Supabase project, separate `baileys_` prefixed tables
>
> **Goal:** Both bots run simultaneously on the same VPS monitoring the same WhatsApp groups, storing independently to separate tables so we can compare reliability between whatsapp-web.js and Baileys.

---

