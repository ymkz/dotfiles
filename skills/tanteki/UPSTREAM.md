# Upstream

- Repository: https://github.com/iwasa-kosui/tanteki
- Path: `skills/tanteki/SKILL.md`
- Reference commit: [e9c4ae749fbe1b35cb740d9e7e0e00a00a0cb42b](https://github.com/iwasa-kosui/tanteki/commit/e9c4ae749fbe1b35cb740d9e7e0e00a00a0cb42b)
- Reference source: https://github.com/iwasa-kosui/tanteki/blob/e9c4ae749fbe1b35cb740d9e7e0e00a00a0cb42b/skills/tanteki/SKILL.md
- Verified and migrated: 2026-10-28
- License: MIT; see [LICENSE](LICENSE).
- Original installation commit: unknown. The reference commit was inspected during migration; it is not a claim about the original installation revision.
- Migrated SKILL.md SHA-256: `8313be8cc5e6c2caf28efe53ace0bbefab05bca31ea76ff3d56c11b7fcfdc65c`

## Local changes

The installed skill differs from the reference revision. Preserve the existing instructions, references, lint rules, package manifest, and lockfile rather than replacing them with current upstream content.

Resolve the CLI entry path to its real path in `scripts/lint.mjs` so the linter runs when invoked through the user-level skill symlink. The skill instructions remain unchanged.

Added provenance metadata and retained the upstream license for local Git management.
