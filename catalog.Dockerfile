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
ENV __doozer_group=oadp-1.5
ENV __doozer_key=oadp-operator
ENV __doozer_version=1.5.9
ENV __doozer_release=20261105184914.ocp4.19
ENV __doozer_bundle_nvrs=oadp-operator-metadata-container-1.5.9.202611051615.p2.g229be98.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/oadp-operator
LABEL io.openshift.build.commit.id=229be981000e5e50db14638e543456cc94a94943
LABEL com.redhat.art.name=oadp-operator-fbc
LABEL com.redhat.art.nvr=oadp-operator-fbc-1.5.9-20261105184914.ocp4.19
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/oadp/oadp-operator-bundle@sha256:b16ce7cafc973a5d589cfb9c5e1f426d8a3e124dfd860dc876cc2a916fd2641b
