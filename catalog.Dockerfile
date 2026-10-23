# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13
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
ENV __doozer_group=quay-3.12
ENV __doozer_key=container-security-operator
ENV __doozer_version=3.12.24
ENV __doozer_release=20261023181754.ocp4.13
ENV __doozer_bundle_nvrs=container-security-operator-metadata-container-3.12.24.202610231623.p2.gbe47da0.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/quay/container-security-operator
LABEL io.openshift.build.commit.id=be47da09ccc4a4bb7077f80a34319ad34323a198
LABEL com.redhat.art.name=container-security-operator-fbc
LABEL com.redhat.art.nvr=container-security-operator-fbc-3.12.24-20261023181754.ocp4.13
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-container-security-operator-bundle@sha256:d158d314761056719602f279dcdff5e9c0af6b64ad96b8d13d1de40d0e36ce2c
