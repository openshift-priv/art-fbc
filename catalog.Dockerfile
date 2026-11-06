# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.16 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.16
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
ENV __doozer_group=mta-8.2
ENV __doozer_key=mta-operator
ENV __doozer_version=8.2.4
ENV __doozer_release=20261106074237.ocp4.16
ENV __doozer_bundle_nvrs=mta-operator-metadata-container-8.2.4.202611060434.p2.gdee0f37.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/migtools/mta-operator
LABEL io.openshift.build.commit.id=dee0f373b282699071303f3b23e2547122cc84f4
LABEL com.redhat.art.name=mta-operator-fbc
LABEL com.redhat.art.nvr=mta-operator-fbc-8.2.4-20261106074237.ocp4.16
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/mta/mta-operator-bundle@sha256:be80bb6b11723ca8e765d87a3600fefdd5342aa4d4b50e3a1d1313bb9ad8c878
