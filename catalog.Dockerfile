# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.20 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.20
# The base image is expected to contain
# /bin/opm (with serve subcommand) and /bin/grpc_health_probe

# Configure the entrypoint and command
ENTRYPOINT ["/bin/opm"]
CMD ["serve", "/configs", "--cache-dir=/tmp/cache"]

COPY --from=builder /configs /configs
COPY --from=builder /tmp/cache /tmp/cache

# Set FBC-specific label for the location of the FBC root directory
# in the image
LABEL operators.operatorframework.io.index.configs.v1=/configs
ENV __doozer_group=mtc-1.8
ENV __doozer_key=openshift-migration-operator
ENV __doozer_version=1.8.19
ENV __doozer_release=20261102160553.ocp4.20
ENV __doozer_bundle_nvrs=openshift-migration-operator-metadata-container-1.8.19.202611021512.p2.gfb7943d.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/migtools/mig-operator
LABEL io.openshift.build.commit.id=fb7943d6002cd999c6504a9b96c88f3e1a8d6044
LABEL com.redhat.art.name=openshift-migration-operator-fbc
LABEL com.redhat.art.nvr=openshift-migration-operator-fbc-1.8.19-20261102160553.ocp4.20
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/rhmtc/openshift-migration-operator-bundle@sha256:d7eb4cf08c2014cecae52be89b8ad50179684d4d0ff7a2a7ffa888b46eee605f
