#!/usr/bin/env bash
# SPDX-License-Identifier: CC0-1.0
# This file is released to the public domain. Use freely without attribution.
#
# Hook: hook-post-docker-tests
#
# Validates the example contract files against the generated schema.
# Runs after token substitution so ${Version} and ${ProjectName} are resolved.
#
# Inputs (provided by build system):
#   OUTPUT_SUB_PATH  - Build output directory

set -euo pipefail

OUTPUT_SUB_PATH="${OUTPUT_SUB_PATH:?OUTPUT_SUB_PATH is required}"
DOCKER_PLATFORM="${DOCKER_PLATFORM:-linux/amd64}"

# Use substituted schema (tokens resolved) from the docker build context.
# Multi-platform builds have per-platform dirs; content is identical so use the first.
if [[ "${DOCKER_PLATFORM}" == *,* ]]; then
  first_platform="${DOCKER_PLATFORM%%,*}"
  yaml_dir="${OUTPUT_SUB_PATH}/docker-${first_platform//\//-}/substituted/yaml"
else
  yaml_dir="${OUTPUT_SUB_PATH}/docker/substituted/yaml"
fi

echo "Validating examples against generated schema..."
echo ""

# Find the versioned schema file (spec-package-prepare adds version to filename)
schema_file=$(find "${yaml_dir}" -name 'spec-manifests-contract-schema-*.yaml' -type f | head -1)
if [[ -z "${schema_file}" ]]; then
  echo "ERROR: No schema file found in ${yaml_dir}"
  exit 1
fi
echo "Using schema: ${schema_file}"
echo ""

check-jsonschema --schemafile "${schema_file}" src/examples/contract-full.yaml
echo "  contract-full.yaml: ok"
check-jsonschema --schemafile "${schema_file}" src/examples/contract-min.yaml
echo "  contract-min.yaml: ok"

echo ""
echo "Example validation complete"
