# laci — Privacy policy

laci is a command-line tool that searches and edits Google Drive, Docs, Sheets and Slides across the Google accounts
you sign in with. It runs on your Mac. This page is both the application home page and the privacy policy that the
OAuth consent screen of your own Google Cloud project links to.

## Whose project it is

laci ships with no OAuth client of its own. With `laci init` you set up your own under your Google account (a Google
Cloud project, a consent screen and a Desktop OAuth client), and laci signs in through that client. The application
name you see on Google's consent screen is the one you chose. The author of laci runs no server, holds no client, and
cannot see which accounts you sign in with or what is in them.

## What laci asks for

One scope, `https://www.googleapis.com/auth/drive`, plus your email address and Google account id so it can tell
your accounts apart. It uses the scope only for the commands you run and the calls of an AI agent you connect with
`laci mcp`: listing, searching, reading and, where you allow it, changing files in Drive, Docs, Sheets and Slides.

## Where your data goes

- **Nothing goes to the author.** laci talks to Google's APIs from your machine, and it has no analytics or telemetry.
  It contacts GitHub only when you run `laci update`, to fetch a release.
- **Tokens stay in your Keychain.** The refresh token for each account and the OAuth client secret are stored in
  your macOS login Keychain under the service name `laci`. They are not written to the config file or to logs. The
  Google Cloud CLI, which `laci init` uses, keeps its own sign-in in its own files.
- **The config file** holds the OAuth client id, your Google project id, and for each account its Google account id,
  email address, label and settings. It holds no secret.
- **File content** is read on request and shown to you or passed to the program that called laci. An AI agent receives
  what it asks for and handles it under its provider's terms. While it runs, laci keeps the text of a few recently
  read files in memory.
- **Copies on disk** are made only on request. `laci export` writes a file where you say. An agent's export saves one
  in laci's cache, `~/.cache/laci/exports` by default, where the agent's next export removes it once it is a day old,
  and `laci uninstall` removes it.

## Your control

- `laci account remove <account>` revokes that account's token with Google, deletes its Keychain item and drops it
  from the config.
- `laci uninstall` does this for every account and deletes the client secret, the config, the cached exports, laci's
  entries in your AI agents and its Google Cloud CLI configuration. Your Google Cloud sign-in and project stay.
- You can also revoke laci's access at any time from your Google account's security settings, or delete the Google
  Cloud project.

## Contact

This repository has issues disabled. If you need to reach the author, use the contact details on the GitHub profile
`lugassawan`.
