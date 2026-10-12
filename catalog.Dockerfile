# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.0 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.0
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
ENV __doozer_group=openshift-5.0
ENV __doozer_key=ose-gcp-filestore-csi-driver-operator
ENV __doozer_version=5.0.0
ENV __doozer_release=20261012171357
ENV __doozer_bundle_nvrs=ose-gcp-filestore-csi-driver-operator-bundle-container-v5.0.0.202610121432.p2.gb10ba12.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/gcp-filestore-csi-driver-operator
LABEL io.openshift.build.commit.id=b10ba12de70d015a399fe70dc6d3f8312d572ed4
LABEL com.redhat.art.name=ose-gcp-filestore-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-gcp-filestore-csi-driver-operator-fbc-5.0.0-20261012171357
LABEL com.redhat.art.bundle.pullspec=quay.io/redhat-user-workloads/ocp-art-tenant/art-images@sha256:31ee383818e9b8a840539266d0fa4fc954736ae9c011abaffa9d1b28b9a60af6
