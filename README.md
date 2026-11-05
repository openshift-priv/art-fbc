# Quay production catalog snapshot for OCP 4.22

This branch contains only the three Quay operator packages published in
`registry.redhat.io/redhat/redhat-operator-index:v4.22` on November 5, 2026.
It is a separate source branch for a future unified FBC build.

| Package | Bundles | Channels | Default channel |
| --- | ---: | ---: | --- |
| container-security-operator | 167 | 14 | stable-3.18 |
| quay-bridge-operator | 167 | 14 | stable-3.18 |
| quay-operator | 158 | 14 | stable-3.18 |

`unified-provenance.json` records the immutable production index digest, the
linux/amd64 manifest used for extraction, source and output file hashes, and
package counts. The three `/configs/<package>/catalog.json` files were extracted
with `oc image extract` and converted from JSON to YAML with PyYAML, preserving
all values and list order without schema migration. Every catalog object is
preserved, including bundle images, related images, channel entries, default
channels, and deprecations.

No source FBC builds or unreleased bundles are overlaid. In particular, the
previous branch's manually restored EUS entries are included only when they
exist in this production snapshot. The inherited mirrors pointing to ART build
repositories were removed; image references remain exactly as published.

The Dockerfile retains the OCP 4.22 operator-registry base and unified FBC identity,
with a new planned NVR. `__doozer_group=quay-3.16` identifies the existing build
configuration. It does not identify a source bundle. `__doozer_bundle_nvrs` and
provenance `inputs` are empty because this snapshot introduces no new bundles.

## Validation and future build

Local validation uses:

```sh
opm validate catalog
opm serve catalog --cache-dir=/tmp/quay-prod-4.22-cache --cache-only --pprof-addr=
```

Each output package must also compare equal, as a collection of parsed catalog
objects, to its extracted production source. The recorded SHA-256 hashes verify
the extracted and committed files.

The image build, Konflux checks, and release validation are deferred. Before a
build, configure the job to select this branch and handle production-only
provenance. The inspected `lp-unified-fbc` implementation derives the fixed branch
`art-quay-fbc-unified-4-22`; its skip-rebase path also requires nonempty source
build inputs. It cannot consume this branch unchanged. Build from the committed
Dockerfile and catalog without regenerating sources from FBC build inputs, then
render the built image and compare all three packages with this snapshot.
