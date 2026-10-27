---
name: pr-writer
description: 差分を根拠に、日本語のPRタイトルと説明を作成・更新する。PRの作成、タイトルや本文の修正、レビューに向けた変更の説明を依頼されたときに使う。
license: Apache-2.0
---

# PR Writer

Modified by ymkz: Japanese titles and prose, standard commit types, repository
templates, and scope-aware operations. See [UPSTREAM.md](UPSTREAM.md) for origin.

Write the PR body as a cover note for reviewers, not a changelog, template,
validation log, or file-by-file summary.

Write both the title subject and body in Japanese, unless the user or repository
explicitly requires another language. Keep types, scopes, and code identifiers
in English. Explain changed behavior and its reason in natural paragraphs;
use bullets only for parallel items that are easier to scan as a list.

Follow the repository's PR template when present. Adapt the guidance below to
its sections, and do not invent changes or validation results.

Drafting copy does not require creating a branch, committing, pushing, or editing
a remote PR. Perform those operations only within the user's requested scope.

## Inspect the Change

Requires authenticated `gh`. Inspect the current branch, working tree, PR,
base branch, commits, and full diff:

```bash
git branch --show-current
git status --porcelain
gh pr view --json number,title,body,url,baseRefName,headRefName
gh repo view --json defaultBranchRef
```

If `gh pr view` reports that no PR exists, continue with first-time PR
creation. For an existing PR, use its `baseRefName`; otherwise use the
repository default branch. Set `BASE`, then inspect:

```bash
git log "$BASE"..HEAD --oneline
git diff "$BASE"...HEAD
```

For PR creation, use a feature branch and ensure intended changes are committed.
For an explicitly requested draft of uncommitted work, inspect that diff and
identify its scope. Review the whole branch diff for an existing PR, not only
the latest commit or existing PR text.

## Core Rules

- Describe concrete changed behavior, affected surfaces, and reviewer impact
  before implementation detail.
- Explain motivation, risk, tradeoffs, migration, or review focus only when
  useful.
- Use the smallest structure that makes the change easier to review.
- Replace internal prompt or process terminology with specific behavior.
- When refreshing a PR, rewrite around the current full diff without narrating
  review history.

## Titles

Use `<type>(<scope>): <subject>` or `<type>: <subject>`.

Allowed types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`,
`ci`, `chore`, `style`, and `revert`. Follow explicit repository conventions
when they differ. For example: `fix(auth): ログイン失敗時の入力内容を保持`.

- Describe the dominant full-branch change with the narrowest accurate type
  and scope.
- Use `!` only when the change breaks an external contract, and explain the
  affected surface in the body.
- Avoid vague subjects such as `update`, `cleanup`, `misc`, `fix stuff`,
  or `address feedback`. Do not add a trailing period.
- Keep an existing title only when it still describes the whole diff.

## Body Shape

Choose the minimum useful shape:

| Change | Include |
|--------|---------|
| Small or obvious | One concise paragraph without headings. |
| Feature, bug fix, or refactor | Changed behavior and effect; add root cause, unchanged behavior, or non-obvious approach when relevant. |
| Contract or breaking change | Affected API, schema, payload, config, permission, storage, or CLI surface; include compatibility and migration guidance. |
| Operational, visual, or workflow change | User/operator effect, measured impact, failure modes, or flow when useful. |
| Broad, generated, or cross-cutting change | Organizing principle, why the breadth is necessary, and where review should start. |

Default:

```markdown
<What changed and what effect it has.>

<Why the approach, risk, migration, or review focus matters, if not obvious.>
```

For review-feedback updates, describe the resulting PR as a whole rather than
the sequence of revisions.

## Reviewer Aids

Use an aid only when it reduces reviewer reconstruction work:

- A compact before/after or interface example for changed contracts.
- A small Mermaid diagram for async flows or state transitions.
- A screenshot or recording note when visual evidence exists.
- A rollout, compatibility, risk, or review-order note when reviewers or
  adopters need it.

Introduce an artifact with one sentence explaining what reviewers should
notice. Omit it when prose is clearer.

## Boundaries

- Do not add default `Summary`, `Changes`, or `Test Plan` sections unless the
  repository template requires them.
- Omit routine validation unless it changes risk assessment or explains
  meaningful regression coverage. For docs, skills, copy, or config changes,
  omit it by default.
- Do not paste commands, CI logs, validation dumps, commit logs, placeholders,
  or exhaustive file lists.
- Never include customer or organization names, user emails, support ticket
  contents, secrets, or PII.
- Use issue references only when verified from user input, branch names,
  commits, PR discussion, or tracker output. `Fixes <issue>` closes;
  `Refs <issue>` only links.

## Create or Update

Create new PRs as drafts. Write the body to a temporary Markdown file, then run:

```bash
gh pr create --draft --title '<title>' --body-file /tmp/pr-body.md
```

Update existing PRs with `gh api`:

```bash
gh api -X PATCH repos/{owner}/{repo}/pulls/PR_NUMBER \
  -f title='<title>' \
  -F body=@/tmp/pr-body.md
```

Refresh the title and body when follow-up commits materially change scope,
approach, breaking behavior, risk, migration, or review expectations. Skip
typo-only, formatting-only, and rename-only follow-ups.

## Examples

Small change:

```markdown
AI Customizations セクションを初期状態で折りたたみ、必要になるまで
サイドバーの表示領域を圧迫しないようにしました。開閉状態の保存は従来どおりです。
```

Breaking contract:

````markdown
実行ログをスキル単位からチャンク単位のレコードへ変更しました。
トップレベルの `findings` を読む処理は、各レコードの `chunk.findings` を
読むように変更する必要があります。

Before:

```json
{"skill": "security-review", "findings": [...]}
```

After:

```json
{"schemaVersion": 1, "chunk": {"index": 1, "findings": [...]}}
```
````
