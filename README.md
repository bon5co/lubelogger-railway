# lubelogger-railway

Thin wrapper over `ghcr.io/hargata/lubelogger` (LubeLogger, self-hosted vehicle maintenance and fuel tracker) for the
Railway template "LubeLogger". Turns authentication on, computes the SHA256 root-user hashes upstream expects from
`ADMIN_USERNAME` / `ADMIN_PASSWORD` at boot, and keeps the cookie data-protection keys on the data volume at
`/App/data`.
