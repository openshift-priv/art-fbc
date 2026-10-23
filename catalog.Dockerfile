# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.14 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.14
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
LABEL com.redhat.art.name=quay-operator-fbc-unified
LABEL com.redhat.art.nvr=quay-operator-fbc-unified-4.14-20261023014521368001.ocp4.14
ENV __doozer_group=quay-3.10
ENV __doozer_version=4.14
ENV __doozer_release=20261023014521368001.ocp4.14
ENV __doozer_bundle_nvrs=quay-operator-metadata-container-3.10.28.202610201620.p2.g99297d2.assembly.stream.el8-2,quay-operator-metadata-container-3.12.24.202610201635.p2.g916d524.assembly.stream.el8-2,quay-operator-metadata-container-3.14.10.202610201627.p2.g8fedcad.assembly.stream.el8-2,quay-operator-metadata-container-3.15.9.202610201734.p2.g01959bb.assembly.stream.el8-2,quay-operator-metadata-container-3.16.7.202610202232.p2.ge44ea81.assembly.stream.el9-2,quay-operator-metadata-container-3.17.7.202610202329.p2.g015d069.assembly.stream.el9-2,quay-operator-metadata-container-3.18.3.202610202230.p2.g198abc8.assembly.stream.el9-1,quay-operator-metadata-container-3.9.28.202610201928.p2.gfb8f4b1.assembly.stream.el8-2
