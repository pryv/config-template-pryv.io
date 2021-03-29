
# Logging for Pryv.io

This is a setup for a Promtail-Loki-Grafana stack for Tracing dashboard

## Usage:

- Start with `../run-logging`
- Connect to Grafana: open [http://localhost:3000](http://localhost:3000), sign in with **admin/admin**
- Add data source: Loki / http://loki:3100
- Import dashboard: copy paste JSON from grafana/dashboards/..

### Troubleshoot

- Monitor Promtail targets: [http://localhost:9080/targets](http://localhost:9080/targets)

## References:

- installation: https://grafana.com/docs/loki/latest/installation/docker/#install-with-docker-compose
- dashboard: https://grafana.com/grafana/dashboards/12559
- troubleshoot: https://grafana.com/docs/loki/latest/getting-started/troubleshooting/
