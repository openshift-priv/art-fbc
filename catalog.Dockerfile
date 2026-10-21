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
ENV __doozer_group=openshift-4.20
ENV __doozer_key=ose-smb-csi-driver-operator
ENV __doozer_version=4.20.0
ENV __doozer_release=20261021000529
ENV __doozer_bundle_nvrs=ose-smb-csi-driver-operator-bundle-container-v4.20.0.202610202103.p2.g1a773c6.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/csi-operator
LABEL io.openshift.build.commit.id=1a773c6c2789fcd3a89f1c057eadc095ffd79495
LABEL com.redhat.art.name=ose-smb-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-smb-csi-driver-operator-fbc-4.20.0-20261021000529
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-smb-csi-driver-operator-bundle@sha256:649349677edada31ce37cffdbcfa34b0eed91d85de3c720a2d8474f4e723ff41
