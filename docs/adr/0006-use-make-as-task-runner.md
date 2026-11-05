# 0006. Use Make as task runner

## Date

2026-11-05

## Context

Creating, bootstrapping and deleting the cluster takes several commands with fixed arguments. These need one short and memorable entry point.

## Decision

Use a `Makefile` as a thin task runner. Each target runs one or two commands. Logic such as loops and conditions moves to scripts that a target calls. Every target is documented in the [bootstrap runbook](../runbooks/bootstrap.md).

## Alternatives considered

- **just:** built for this purpose and has real arguments, but it is another tool to install.
- **Task:** YAML-based with dependency support, but more verbose and also another tool to install.
- **Scripts only:** no extra tool, but no common entry point.

## Consequences

- **Positive:** Make is available on most systems and widely recognized.
- **Positive:** replacing it later is a small change, because the targets contain no logic.
- **Negative:** Make is designed to build files, so every target has to be declared `.PHONY`.
- **Negative:** arguments are passed as variables, such as `APP=name`.
