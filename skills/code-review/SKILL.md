---
name: code-review
description: PRやブランチの変更をレビューし、不具合の発生条件・根拠・影響・修正案を日本語で報告する。PRレビュー、差分の確認、変更の不具合調査を依頼されたときに使う。
license: Apache-2.0
---

# Code Review

Modified by ymkz: repository-neutral review, Japanese findings, stable finding
keys, evidence requirements, and read-only operation. See [UPSTREAM.md](UPSTREAM.md).

## Review Workflow

- Read the repository's applicable instructions and PR template, then inspect
  the PR title, body, base and head, commits, and complete base-to-head diff.
  For local changes, identify the requested staged, unstaged, or branch scope.
  If output is truncated, inspect the remaining changed files separately.
- Trace affected callers, configuration, tests, and public contracts far enough
  to establish intended behavior and whether a suspected failure is reachable.
- For each suspected bug, identify a concrete trigger, evidence, and observable
  impact. Check guards and existing behavior before reporting it. Run a focused
  reproduction when useful and permitted; distinguish executed checks from
  reasoning based on code. Do not invent findings or validation results.
- Review read-only. Do not edit files, stage, commit, switch branches, or fix
  findings as part of review. Use a temporary workspace for reproductions.
  Report in the conversation; post GitHub comments or submit a review only when
  explicitly requested. Review on your own unless multiple reviewers are requested.

## Findings

Default to Japanese unless the user or repository explicitly requires another
language. Report verified defects first, in priority order. Treat design advice
as optional suggestions, separate from defects, and include it only when useful.
Do not report untouched pre-existing issues unless the change makes them worse
or newly reachable. Style preferences alone are not defects.

Assign every finding and optional suggestion a unique key such as `R1`, `R2`
within the current PR or review conversation. Include the key in its title.
On follow-up reviews, retain keys for the same issues, including when their
wording or priority changes. Give new issues unused keys; do not renumber or
reuse resolved keys. If previous keys cannot be retrieved, state that the keys
are scoped to this review instead of claiming continuity.

Use `P0` for unconditional release-blocking failures, `P1` for urgent defects,
`P2` for normal-priority defects, and `P3` for minor defects. Optional suggestions
should be labeled as suggestions rather than assigned a defect priority.

For each defect, provide a title such as `[R1][P2] 再試行時に通知が重複する`,
a link to the relevant changed lines, and a short explanation of the trigger,
supporting evidence, impact, and concrete repair direction. For a suggestion,
use a title such as `[R2][提案] ...`. Avoid uncertain questions presented as bugs.

If no actionable findings remain, say so. Close with the checks performed and
material limits of the review, distinguishing local checks from CI. Do not
equate a passing CI run with proof that behavior is correct.

## Review Checklist

### Identifying Problems

Look for these issues in code changes:

- **Runtime errors**: Potential exceptions, null pointer issues, out-of-bounds access
- **Performance**: Unbounded O(n²) operations, N+1 queries, unnecessary allocations
- **Side effects**: Unintended behavioral changes affecting other components
- **Backwards compatibility**: Breaking API changes without migration path
- **Data access**: Query behavior and performance relevant to the project's database
- **Security vulnerabilities**: Injection, XSS, access control gaps, secrets exposure

### Design Assessment

- Do component interactions make logical sense?
- Does the change align with existing project architecture?
- Are there conflicts with current requirements or goals?

### Test Coverage

Assess test coverage in proportion to the changed behavior:

- Functional tests for business logic
- Integration tests for component interactions
- End-to-end tests for critical user paths

Verify tests cover actual requirements and edge cases. Avoid excessive branching or looping in test code.

### Long-Term Impact

Flag for senior engineer review when changes involve:

- Database schema modifications
- API contract changes
- New framework or library adoption
- Performance-critical code paths
- Security-sensitive functionality

## Feedback Guidelines

### Tone

- Be polite and empathetic
- Provide actionable suggestions, not vague criticism
- State confirmed defects directly. Mark unresolved hypotheses as unverified
  limits rather than presenting them as established findings.

### Approval

- State whether remaining issues block merging; submitting an approval requires
  an explicit request
- Don't block PRs for stylistic preferences
- Remember: the goal is risk reduction, not perfect code

## Common Patterns to Flag

### Python/Django

```python
# Bad: N+1 query
for user in users:
    print(user.profile.name)  # Separate query per user

# Good: Prefetch related
users = User.objects.prefetch_related('profile')
```

### TypeScript/React

```typescript
// Bad: Missing dependency in useEffect
useEffect(() => {
  fetchData(userId);
}, []);  // userId not in deps

// Good: Include all dependencies
useEffect(() => {
  fetchData(userId);
}, [userId]);
```

### Security

```python
# Bad: SQL injection risk
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")

# Good: Parameterized query
cursor.execute("SELECT * FROM users WHERE id = %s", [user_id])
```

## References

- [Sentry Code Review Guidelines](https://develop.sentry.dev/engineering-practices/code-review/)
