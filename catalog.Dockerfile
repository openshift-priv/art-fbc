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
ENV __doozer_group=acm-2.16
ENV __doozer_key=multiclusterhub-operator
ENV __doozer_version=2.16.4
ENV __doozer_release=20261113182613.ocp4.20
ENV __doozer_bundle_nvrs=acm-multiclusterhub-operator-metadata-container-2.16.4.202611131615.p2.g4a5c68c.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/stolostron/multiclusterhub-operator
LABEL io.openshift.build.commit.id=4a5c68c5a3ca2abb40eb2bb6c2ccfb5c9615659b
LABEL com.redhat.art.name=multiclusterhub-operator-fbc
LABEL com.redhat.art.nvr=multiclusterhub-operator-fbc-2.16.4-20261113182613.ocp4.20
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/rhacm2/acm-operator-bundle@sha256:1c87acf9c86e4b86dddb98498bd7471a550eb941ebae45efbc16e3a9e48f1d6c
