# Quay production catalog with manual fixes for OCP 4.12

The source is `registry.redhat.io/redhat/redhat-operator-index:v4.12`, captured on November 5, 2026. The production baseline is preserved and the version-specific manual fixes are layered on top.

| Package | Production bundles | Manual additions | Total bundles | Channels | Default channel |
| --- | ---: | ---: | ---: | ---: | --- |
| container-security-operator | 183 | 1 | 184 | 15 | stable-3.18 |
| quay-bridge-operator | 183 | 1 | 184 | 15 | stable-3.18 |
| quay-operator | 172 | 2 | 174 | 15 | stable-3.18 |

`unified-provenance.json` records the immutable index and linux/amd64 extraction manifest, every production source file and its hash, output hashes, package counts, and any manual overlay. All JSON files under each of the three production package directories are included, preserving split catalogs as well as single-file catalogs. JSON is converted to YAML without changing values, list order, or schemas.

The manual overlay is the catalog delta between `6f9ab6fe9396e0d59a8e45eb19ab86389c79784b` and `989c749542ab78566464fafd20114a4bea166b52` on `art-quay-fbc-unified-4-12`. Source commits: `cb8a9a2d7b2224b5b36d3dddee8118ad85f20437`, `aac069b9de7f197f97ea2c89fb9ba84773bd8109`.

Only restored bundles and their channel entries are included. Edits to channel entries for excluded automated source builds are omitted. Production bundle objects, existing channel entries, defaults, and deprecations are preserved. The original mirror set is restored for the manual bundle references.

The manual additions retain the legacy `olm.bundle.object` properties from the OCP 4.12 fix. No CSV metadata migration is performed.

No automated source FBC builds are selected. `inputs` and `__doozer_bundle_nvrs` are empty; manual additions are recorded separately. The Dockerfile keeps the original 4.12 operator-registry base and execution group, with a new planned NVR.

## Validation and future build

```sh
opm validate catalog
opm serve catalog --cache-dir=/tmp/quay-prod-4.12-cache --cache-only --pprof-addr=
```

Compare every production object and existing channel entry with the extracted production sources. Verify manual bundle objects and channel additions against the recorded manual source commits, and verify all recorded hashes. Confirm that automated source bundles remain excluded.

Image builds, Konflux checks, and release validation are deferred. The inspected `lp-unified-fbc` implementation assumes the standard branch `art-quay-fbc-unified-4-12` and nonempty source-build metadata. Configure the later job to select this branch and support production plus manual provenance without regenerating catalogs from FBC builds. After building, render the output image and compare it against these committed sources.
