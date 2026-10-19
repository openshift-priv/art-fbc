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
ENV __doozer_key=ose-aws-efs-csi-driver-operator
ENV __doozer_version=4.18.0
ENV __doozer_release=20261019155948
ENV __doozer_bundle_nvrs=ose-aws-efs-csi-driver-operator-bundle-container-v4.18.0.202610190155.p2.g46b7804.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/csi-operator
LABEL io.openshift.build.commit.id=46b780449b0ebf83a65ec0c3c855271188324129
LABEL com.redhat.art.name=ose-aws-efs-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-aws-efs-csi-driver-operator-fbc-4.18.0-20261019155948
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-aws-efs-csi-driver-operator-bundle@sha256:fe96addc627cfe0f7b4ebcb217ad20c8dd0fda6f85a3cf150b7bbaf908a188d2
