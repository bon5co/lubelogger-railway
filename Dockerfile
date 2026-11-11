# LubeLogger for Railway.
#
# Upstream starts with authentication OFF (anyone who reaches the URL can read and write every vehicle) and only
# turns it on when the deployer pastes SHA256 hashes of the root username and password into two variables.
# This wrapper (1) turns auth on, (2) computes those hashes at boot from ADMIN_USERNAME / ADMIN_PASSWORD so the
# deploy form needs nothing typed in, and (3) keeps the cookie data-protection keys on the data volume so a
# redeploy does not log the browser out. The binary and everything else are the stock image.
FROM ghcr.io/hargata/lubelogger:v1.7.4@sha256:483a9d7582c4e6258615fd822b3de4193b4fcc4230d0a92432c6d407faf75af2

ENV EnableAuth=true \
    ADMIN_USERNAME=admin

COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod +x /usr/local/bin/railway-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
CMD ["./CarCareTracker"]
