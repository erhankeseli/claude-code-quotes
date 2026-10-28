# claude-code-quotes

This project is a Stop hook for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). The hook shows one random programming quote after each response.

<!-- TODO: Add a screenshot at docs/screenshot.png. Then remove the comment marks around the next line.
![Claude Code shows a programming quote after a response](docs/screenshot.png)
-->

## What it does

After each response, Claude Code runs the hook script `quote.sh`. The script selects one random line from `~/.claude/quotes.txt`. Claude Code shows the line below the response.

The quotes file contains 411 quotes. Each line contains one quote and the name of the author.

The project has no dependencies. The script uses only `sh` and `awk`. macOS and most Linux systems include both programs.

## Install

1. Clone the repo and run the install script:

   ```sh
   git clone https://github.com/erhankeseli/claude-code-quotes && cd claude-code-quotes && sh install.sh
   ```

   The install script does these tasks:

   - The script copies `quote.sh` to `~/.claude/hooks/quote.sh` and makes the file executable.
   - The script copies `quotes.txt` to `~/.claude/quotes.txt`.
   - If `~/.claude/quotes.txt` exists, the script does not overwrite the file. The script tells you about this.
   - The script does not change `~/.claude/settings.json`. The script prints the block for step 2.

2. Open `~/.claude/settings.json` and add this block:

   ```json
   "hooks": {
     "Stop": [
       { "hooks": [ { "type": "command", "command": "sh \"$HOME/.claude/hooks/quote.sh\"", "timeout": 5 } ] }
     ]
   }
   ```

   If the file already has a `hooks` key, do not add a second `hooks` key. Merge the `Stop` entry into the existing `hooks` object. If a `Stop` array exists, add the new entry to that array.

3. Start a new Claude Code session. The change applies to new sessions.

## How it works

Claude Code does not show the plain stdout of a Stop hook. For this reason, the script does not print plain text. The script prints one JSON object with a `systemMessage` field:

```json
{"systemMessage": "💡 Simplicity is prerequisite for reliability. — Edsger W. Dijkstra"}
```

Claude Code shows the `systemMessage` text with its own hook label. No setting removes this label.

The script does these steps:

1. The script reads `~/.claude/quotes.txt`. If the file does not exist or is not readable, the script stops with no output.
2. The script ignores empty lines.
3. The script selects one random line.
4. The script escapes backslashes and double quotes. This step keeps the JSON output valid.
5. The script prints the JSON object.

The script always exits with code 0.

## Customize

Edit `~/.claude/quotes.txt`. Write one quote on each line. Use this format:

```text
Quote text. — Author Name
```

The script shows the full line. The script reads the file again at each response. Thus you do not have to restart Claude Code after a change.

Do not put tab characters or Windows line endings (CRLF) in the file. The script does not escape these characters. If a line contains one of these characters, the output of that line is not valid JSON.

The install script does not overwrite an existing `~/.claude/quotes.txt`. To get new quotes from this repo, copy `quotes.txt` to `~/.claude/quotes.txt` yourself.

### Contribute quotes

Pull requests with new quotes are welcome. Add each quote to `quotes.txt` on a new line, in the format "text — author". Keep the quote text at 200 characters or less.

## Credits

The quotes come from [skolakoda/programming-quotes-api](https://github.com/skolakoda/programming-quotes-api) (ISC license). Quotes with a text longer than 200 characters were removed. This limit does not include the author name.

## License

The code in this repo uses the MIT license. See [LICENSE](LICENSE).
