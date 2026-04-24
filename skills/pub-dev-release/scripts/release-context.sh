#!/usr/bin/env sh
set -eu

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$repo_root"

echo "Repository: $repo_root"
echo

if [ -f pubspec.yaml ]; then
  echo "Current pubspec version:"
  sed -n 's/^version:[[:space:]]*/version: /p' pubspec.yaml | head -n 1
else
  echo "Current pubspec version: pubspec.yaml not found"
fi

echo
latest_tag="$(git describe --tags --abbrev=0 2>/dev/null || true)"

if [ -n "$latest_tag" ]; then
  echo "Latest release tag: $latest_tag"
  echo
  echo "Commits since latest release:"
  git log --oneline "$latest_tag"..HEAD
  echo
  echo "Files changed since latest release:"
  git diff --name-status "$latest_tag"..HEAD
else
  echo "Latest release tag: none found"
  echo
  echo "Recent commits:"
  git log --oneline -20
  echo
  echo "Tracked files changed in working tree:"
  git status --short
fi

echo
echo "Working tree status:"
git status --short
