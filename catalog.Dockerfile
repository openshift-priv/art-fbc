# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.18 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.18
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
ENV __doozer_group=openshift-4.18
ENV __doozer_key=ose-smb-csi-driver-operator
ENV __doozer_version=4.18.0
ENV __doozer_release=20260312144823
ENV __doozer_bundle_nvrs=ose-smb-csi-driver-operator-bundle-container-v4.18.0.202603121405.p2.gcbdc89d.assembly.test.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/csi-operator
LABEL io.openshift.build.commit.id=cbdc89d2badcc8570252f2a0ee2f27c87fc0ba90
LABEL com.redhat.art.name=ose-smb-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-smb-csi-driver-operator-fbc-4.18.0-20260312144823
