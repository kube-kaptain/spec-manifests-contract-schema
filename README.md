# spec-manifests-contract-schema

JSON Schema for Kaptain manifests contract files.


## What is a manifests contract?

When Kaptain builds a manifest package zip (and wraps in an OCI image and GitHub
Release), it generates a contract file and zip  alongside the manifests. The
contract tells consuming projects:

- **Token scheme** - what delimiter style and name style the manifests use
- **Required configuration** - which tokens remain unresolved and must eventually be supplied
- **Defaults** - fallback values for tuneable tokens (memory, CPU, replicas, etc.)
- **Compatibility** - which other token schemes can be auto-converted to, and which need repackaging


## Usage

Validate a contract file against the schema:


```bash
check-jsonschema --schemafile spec-manifests-contract-schema.yaml my-contract.yaml
```

Use the appropriate versioned release of this file for the version of the build
system you're currently using.
