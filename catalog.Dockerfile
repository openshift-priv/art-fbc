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
ENV __doozer_key=ingress-node-firewall-operator
ENV __doozer_version=4.18.0
ENV __doozer_release=20261025015538
ENV __doozer_bundle_nvrs=ingress-node-firewall-operator-bundle-container-v4.18.0.202610241849.p2.g1838b7f.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ingress-node-firewall
LABEL io.openshift.build.commit.id=1838b7f6d39931b20fce7ab9b641548e727fc13f
LABEL com.redhat.art.name=ingress-node-firewall-operator-fbc
LABEL com.redhat.art.nvr=ingress-node-firewall-operator-fbc-4.18.0-20261025015538
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ingress-node-firewall-operator-bundle@sha256:aa014116dab07a084637e53ed9a28995c6ae5543c82092083111542b1d0496a9
