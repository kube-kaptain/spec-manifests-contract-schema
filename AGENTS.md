# Spec Manifests Contract Schema for Agents

JSON Schema for manifests contract files that accompany Kaptain manifest packages.

## Purpose

Defines and validates the structure of the contract file packaged alongside
manifest zips. The contract documents what token scheme the manifests use,
what configuration the consumer must supply, what defaults are available, and
which other token schemes can be automatically converted to.

Published as a versioned OCI image and as versioned YAML/JSON files on the
GitHub release for every release build.

## Project Structure

```
src/
  specs/
    spec-manifests-contract-schema.yaml   # Source schema (picked up directly by spec-package-prepare)
  examples/
    contract-full.yaml                    # All fields populated
    contract-min.yaml                     # Only required fields
.github/
  bin/
    verify-schema-on-examples.bash        # Hook: validates examples against schema
  workflows/
    build.yaml                            # Calls spec-check-filter-release
README.md                                 # For humans
AGENTS.md                                 # These instructions
CLAUDE.md                                 # Redirect to AGENTS.md
```

## Schema Overview

The contract file has four top-level sections:

| Section       | Purpose                                                                   |
|---------------|---------------------------------------------------------------------------|
| `tokens`      | Delimiter style and name style used in the manifests                      |
| `config`      | Required tokens (from scanning) and optional default values               |
| `compatibility` | Which token schemes can be auto-converted vs need repackaging           |

### Token Scheme

Uses the same `delimiterStyle` and `nameStyle` enums as the KaptainPM schema.
Recorded directly from the build environment variables.

### Config

- `required` - array of all token names still present in the substituted manifests (optional - omit config entirely if no unresolved tokens)
- `noDefault` - array of token names that MUST be provided (no safe default exists)
- `defaults` - object mapping token names to default string values (optional)

The defaults section supports inline values now. A defaults directory (one file
per token, same as `src/config/`) is also supported in the contract package but
is not part of this schema (it is a filesystem convention). When both inline
defaults and a defaults directory are present, values must not conflict.

### Compatibility

- `automaticConversion` - schemes the manifests can be converted to automatically
- `repackageRequired` - schemes that need specialised repackaging

Determined by scanning manifest content for patterns that would collide with
other delimiter/name combinations.

## Versioning

Automatic 2-part versions (`major.minor`) by the release build on merge.

## Rules

- Source schema lives in `src/specs/spec-manifests-contract-schema.yaml`
- All text files must have a trailing newline
