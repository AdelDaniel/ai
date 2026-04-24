# Semantic Versioning Guide

Use semantic versioning to choose the next package version.

## Patch

Use a patch release for bug fixes and corrections that do not add features or change public behavior.

Example:

```yaml
version: 1.2.4
```

## Minor

Use a minor release for backward-compatible features, new public APIs, new helpers, or expanded capabilities.

Example:

```yaml
version: 1.3.0
```

## Major

Use a major release for breaking changes, removed APIs, renamed public APIs, changed method signatures, changed return types, or behavior changes that require users to update their code.

Example:

```yaml
version: 2.0.0
```

## Mixed Changes

When a release contains multiple change types, choose the highest required version bump.

- Any breaking change requires a major release.
- Any feature without breaking changes requires a minor release.
- Fix-only releases use a patch release.
