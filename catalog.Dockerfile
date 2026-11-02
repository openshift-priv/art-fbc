# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19
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
ENV __doozer_version=1.8.18
ENV __doozer_release=20261102124710.ocp4.19
ENV __doozer_bundle_nvrs=openshift-migration-operator-metadata-container-1.8.18.202611021208.p2.gfb7943d.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/migtools/mig-operator
LABEL io.openshift.build.commit.id=fb7943d6002cd999c6504a9b96c88f3e1a8d6044
LABEL com.redhat.art.name=openshift-migration-operator-fbc
LABEL com.redhat.art.nvr=openshift-migration-operator-fbc-1.8.18-20261102124710.ocp4.19
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/rhmtc/openshift-migration-operator-bundle@sha256:96cd1ad5ffae0b9ca7df6ef52622fd1c4abf45277a4848cafe7578d58323a15e
