# Quay production catalog with manual fixes for OCP 4.21

The source is `registry.redhat.io/redhat/redhat-operator-index:v4.21`, captured on November 5, 2026. The production baseline is preserved and the version-specific manual fixes are layered on top.

| Package | Production bundles | Manual additions | Total bundles | Channels | Default channel |
| --- | ---: | ---: | ---: | ---: | --- |
| container-security-operator | 182 | 3 | 185 | 15 | stable-3.17 |
| quay-bridge-operator | 182 | 3 | 185 | 15 | stable-3.17 |
| quay-operator | 172 | 3 | 175 | 15 | stable-3.17 |

`unified-provenance.json` records the immutable index and linux/amd64 extraction manifest, every production source file and its hash, output hashes, package counts, and any manual overlay. All JSON files under each of the three production package directories are included, preserving split catalogs as well as single-file catalogs. JSON is converted to YAML without changing values, list order, or schemas.

The manual overlay is the catalog delta between `5a7271126f8e484858471973620c24205881c4ef` and `936bc08e6a373043d2b203f6e4df8b04e21dca97` on `art-quay-fbc-unified-4-21`. Source commits: `afbe62707907935b252e523c24e03383a7188dc5`, `936bc08e6a373043d2b203f6e4df8b04e21dca97`.

Only restored bundles and their channel entries are included. Edits to channel entries for excluded automated source builds are omitted. Production bundle objects, existing channel entries, defaults, and deprecations are preserved. The original mirror set is restored for the manual bundle references.

No automated source FBC builds are selected. `inputs` and `__doozer_bundle_nvrs` are empty; manual additions are recorded separately. The Dockerfile keeps the original 4.21 operator-registry base and execution group, with a new planned NVR.

## Validation and future build

```sh
opm validate catalog
opm serve catalog --cache-dir=/tmp/quay-prod-4.21-cache --cache-only --pprof-addr=
```

Compare every production object and existing channel entry with the extracted production sources. Verify manual bundle objects and channel additions against the recorded manual source commits, and verify all recorded hashes. Confirm that automated source bundles remain excluded.

Image builds, Konflux checks, and release validation are deferred. The inspected `lp-unified-fbc` implementation assumes the standard branch `art-quay-fbc-unified-4-21` and nonempty source-build metadata. Configure the later job to select this branch and support production plus manual provenance without regenerating catalogs from FBC builds. After building, render the output image and compare it against these committed sources.
