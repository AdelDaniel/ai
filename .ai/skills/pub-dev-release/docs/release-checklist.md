# Pub.dev Release Checklist

Use this checklist before finalizing a Flutter or Dart package release.

## Repository State

- Confirm the working tree status.
- Identify the current `pubspec.yaml` version.
- Identify the latest release tag.
- Review all commits since the latest release tag.
- Review uncommitted changes if they are part of the release.

## Release Content

- Categorize changes as `Added`, `Changed`, `Fixed`, or `Breaking`.
- Choose the next version using semantic versioning.
- Update only the `version:` field in `pubspec.yaml`.
- Add the new section to the top of `CHANGELOG.md`.
- Update `README.md` only when public behavior, APIs, installation, or migration notes changed.

## Final Verification

- Run formatter, analyzer, and tests when available.
- Ensure changelog entries are user-facing.
- Ensure release notes do not include implementation details.
- Ensure the tag name matches the version and does not start with `v`.
- Ensure no release-facing text mentions AI.
