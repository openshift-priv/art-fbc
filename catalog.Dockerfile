# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.1 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.1
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
ENV __doozer_group=openshift-5.1
ENV __doozer_key=ingress-node-firewall-operator
ENV __doozer_version=5.1.0
ENV __doozer_release=20261112100029
ENV __doozer_bundle_nvrs=ingress-node-firewall-operator-bundle-container-v5.1.0.202611120539.p2.gac2f05f.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ingress-node-firewall
LABEL io.openshift.build.commit.id=ac2f05f648934e68c0a4d55ddd640d5ab7d75623
LABEL com.redhat.art.name=ingress-node-firewall-operator-fbc
LABEL com.redhat.art.nvr=ingress-node-firewall-operator-fbc-5.1.0-20261112100029
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ingress-node-firewall-operator-bundle@sha256:91d980844a289431827330425307e73207ab4d58bcb988a4f7e34f3c56e7ffb4
