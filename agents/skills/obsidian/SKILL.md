---
name: obsidian
description: Work with my Obsidian vault using the Obsidian CLI. Use when searching, reading, creating, or editing vault notes.
compatibility: Requires Obsidian with CLI enabled and running.
---

Use the `obsidian` CLI. Choose the vault for the machine in use: `Notes` on my personal laptop or `Dexcom` on my work laptop. Pass the matching `vault="..."` as the first argument to vault commands.

Vaults are ordinary directories containing files, mostly Markdown. For a straightforward note change, it may be simpler to read or edit the `.md` file directly instead of using the CLI. Use the CLI when vault-aware operations or app-level features are useful. For broader Obsidian-specific guidance, see the [Kepano Obsidian Skills repo](https://github.com/kepano/obsidian-skills).

Avoid an H1 that repeats the note’s filename; Obsidian already displays the filename as the title.

Check `obsidian help` or `obsidian help <command>` for current syntax. Parameters use `key=value`; quote values with spaces. Boolean options are bare words when listed by help.

```bash
obsidian vault="Notes" search query="term"
obsidian vault="Dexcom" search query="term"
obsidian vault="Notes" read path="Folder/Note.md"
```
