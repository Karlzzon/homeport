# 0001. Record architecture decisions

## Date

2026-11-04

## Context

This project involves many decisions about tooling, architecture and security. The reasoning behind them is easily lost, even in a project with a single maintainer.

## Decision

Record decisions as Architecture Decision Records (ADRs) in `docs/adr/`, using a lightweight MADR-style template.

- Files are named `NNNN-kebab-case-title.md` and numbered in order.
- Each ADR has the sections Date, Context, Decision, Alternatives considered and Consequences.
- An ADR in the repository is a decision that has been made.
- An ADR is written when a non-obvious decision affects architecture, tooling, security or ways of working. Minor details do not need one.
- An ADR is not edited after it is committed. A changed decision gets a new ADR, and the old one gets a `Superseded by NNNN` line at the top.

## Alternatives considered

- **Commit messages only:** hard to find and too short for trade-offs.
- **A single decisions document:** simple, but it tends to be rewritten, which loses the history of how decisions evolved.
- **A wiki or external tool:** separates decisions from the code and its version history.

## Consequences

- **Positive:** the reasoning is versioned with the code and can be reviewed in the repository.
- **Positive:** the history of changed decisions is preserved.
- **Negative:** each significant decision takes extra time to write down.
- **Negative:** ADRs must be written consistently, or the record becomes incomplete.
