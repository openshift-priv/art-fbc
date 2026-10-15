# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.17 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.17
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
ENV __doozer_group=openshift-4.17
ENV __doozer_key=ingress-node-firewall-operator
ENV __doozer_version=4.17.0
ENV __doozer_release=20261015075921
ENV __doozer_bundle_nvrs=ingress-node-firewall-operator-bundle-container-v4.17.0.202610141823.p2.g79b77b5.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ingress-node-firewall
LABEL io.openshift.build.commit.id=79b77b5f3538477f03fc46c15afd40c568443f57
LABEL com.redhat.art.name=ingress-node-firewall-operator-fbc
LABEL com.redhat.art.nvr=ingress-node-firewall-operator-fbc-4.17.0-20261015075921
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ingress-node-firewall-operator-bundle@sha256:a3deb77ec996f9ecc09b50285568d058cb20edea3596bc563845e12388be4ead
