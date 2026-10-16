# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22
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
ENV __doozer_group=openshift-4.22
ENV __doozer_key=ingress-node-firewall-operator
ENV __doozer_version=4.22.0
ENV __doozer_release=20261016224636
ENV __doozer_bundle_nvrs=ingress-node-firewall-operator-bundle-container-v4.22.0.202610162105.p2.g655f0d4.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ingress-node-firewall
LABEL io.openshift.build.commit.id=655f0d41687d19a74c7a710e4ae991bc6a25074b
LABEL com.redhat.art.name=ingress-node-firewall-operator-fbc
LABEL com.redhat.art.nvr=ingress-node-firewall-operator-fbc-4.22.0-20261016224636
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ingress-node-firewall-operator-bundle@sha256:6bc0ed3e4bed2061a839671bfc06ba2d5e22f47e85d6b37d92ca9277283628b1
