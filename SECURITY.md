# Security policy

## Supported versions

This repository carries no version of its own. Each formula names a published release of its tool. Supported-version status for OwnPG itself is `ownpg-releases`'s policy, not this file's.

## Reporting a vulnerability

Report a vulnerability privately through GitHub's private vulnerability reporting on this repository: https://github.com/devops-infinity/homebrew-tap/security/advisories/new. Do not open a public issue for a security problem. If private vulnerability reporting is unavailable to you, email sazzad@devops.bd instead.

Include the affected commit, the exact `brew install` or `brew upgrade` command you ran, and what the formula did that it should not have.

See the security policy in [devops-infinity/ownpg-releases](https://github.com/devops-infinity/ownpg-releases/security/policy) for response-time commitments.

## Scope

A report is in scope when it shows a formula in `Formula/` naming a URL that does not point at a genuine release of its tool, a checksum that does not match the artifact it names, or Ruby code in a formula that runs anything beyond a standard Homebrew install.

A report about OwnPG's own behavior, the binary, or the PostgreSQL connection it manages is out of scope here. See [devops-infinity/ownpg-releases](https://github.com/devops-infinity/ownpg-releases/security/policy) instead.

## Data this tap handles

Homebrew executes the Ruby files in `Formula/` on your machine during `brew install` or `brew upgrade`. This repository holds no other code, runs no server, and collects no data of its own.
