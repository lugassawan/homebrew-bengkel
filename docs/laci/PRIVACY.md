# laci — Privacy policy

laci is a command-line tool that searches and edits Google Drive, Docs, Sheets and Slides across the Google accounts
you sign in with. It runs on your Mac. This page is both the application home page and the privacy policy that the
OAuth consent screen of your own Google Cloud project links to.

## Whose project it is

laci ships with no OAuth client of its own. During `laci account add` you create a Google Cloud project, a consent
screen and a Desktop OAuth client under your own Google account, and laci signs in through that client. The
application name you see on Google's consent screen is the one you chose. The author of laci runs no server, holds
no client, and cannot see which accounts you sign in with or what is in them.

## What laci asks for

One scope, `https://www.googleapis.com/auth/drive`, plus your email address and Google account id so it can tell
your accounts apart. It uses the scope only for the commands you run: listing, searching, reading and, where you
allow it, changing files in Drive, Docs, Sheets and Slides.

## Where your data goes

- **Nowhere but Google.** laci talks to Google's APIs from your machine. It sends nothing to the author or to any
  other third party, and it has no analytics or telemetry.
- **Tokens stay in your Keychain.** The refresh token for each account and the OAuth client secret are stored in
  your macOS login Keychain under the service name `laci`. They are not written to the config file or to logs.
- **The config file** holds the OAuth client id, your Google project id, and for each account its Google account id,
  email address, label and settings. It holds no secret.
- **File content** is read on request and shown to you or passed to the program that called laci. laci does not
  keep a copy.

## Your control

- `laci account remove <account>` revokes that account's token with Google, deletes its Keychain item and drops it
  from the config.
- `laci uninstall` does this for every account and deletes the config.
- You can also revoke laci's access at any time from your Google account's security settings, or delete the Google
  Cloud project.

## Contact

This repository has issues disabled. If you need to reach the author, use the contact details on the GitHub profile
`lugassawan`.
