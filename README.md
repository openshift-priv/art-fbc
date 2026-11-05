# Quay production catalog with manual EUS fixes for OCP 4.22

This branch starts with the three Quay operator packages published in
`registry.redhat.io/redhat/redhat-operator-index:v4.22` on November 5, 2026,
then layers on the manual EUS fixes from `art-quay-fbc-unified-4-22`.
It is a separate source branch for a future unified FBC build.

| Package | Production bundles | Manual additions | Total bundles | Channels | Default channel |
| --- | ---: | ---: | ---: | ---: | --- |
| container-security-operator | 167 | 8 | 175 | 14 | stable-3.18 |
| quay-bridge-operator | 167 | 8 | 175 | 14 | stable-3.18 |
| quay-operator | 158 | 6 | 164 | 14 | stable-3.18 |

`unified-provenance.json` records the immutable production index digest, the
linux/amd64 manifest used for extraction, source and output file hashes, and
package counts. It also records the manual source commits, added bundles, updated
channels, and mirror configuration. The three production
`/configs/<package>/catalog.json` files were extracted
with `oc image extract` and converted from JSON to YAML with PyYAML, preserving
all values and list order without schema migration. Every catalog object is
preserved, including bundle images, related images, channel entries, default
channels, and deprecations.

The manual overlay combines these commits into one additional commit:

- `a2f971a`: restore EUS bundles and channel entries.
- `bc76f32`: migrate those bundles to OCP 4.22 CSV metadata.
- `28e4784`: restore RHEL8 image mirrors.

The resulting 22 additions cover Quay 3.9, 3.10, 3.12, 3.14, and 3.15. They are
explicit exceptions to the production-only baseline and are absent from the
pinned production snapshot. Their bundle metadata and channel entries match the
manually fixed branch. Its mirror set is restored, including the six RHEL8
mappings added by the manual mirror fix and the existing mappings they rely on.

The nine automated 3.16.7, 3.17.7, and 3.18.3 source FBC bundles from the old
unified branch remain excluded. All 492 production bundles, existing channel
entries, package defaults, and deprecations are preserved.

The Dockerfile retains the OCP 4.22 operator-registry base and unified FBC identity,
with a new planned NVR. `__doozer_group=quay-3.16` identifies the existing build
configuration. It does not identify a source bundle. `__doozer_bundle_nvrs` and
provenance `inputs` are empty because no automated source builds are selected;
the manually restored bundles are recorded separately in `manual_overlay`.

## Validation and future build

Local validation uses:

```sh
opm validate catalog
opm serve catalog --cache-dir=/tmp/quay-prod-4.22-cache --cache-only --pprof-addr=
```

Validate that each output package preserves its production objects, with only
the recorded manual bundles and channel entries added. Compare those additions
against the manual source commits. The recorded SHA-256 hashes verify the
extracted and committed files, including the restored mirror set.

The image build, Konflux checks, and release validation are deferred. Before a
build, configure the job to select this branch and handle production plus manual
provenance. The inspected `lp-unified-fbc` implementation derives the fixed branch
`art-quay-fbc-unified-4-22`; its skip-rebase path also requires nonempty source
build inputs. It cannot consume this branch unchanged. Build from the committed
Dockerfile and catalog without regenerating sources from FBC build inputs, then
render the built image and compare all three packages with this snapshot.
