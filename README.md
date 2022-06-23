# mlops_tool
MLOps tool (Experiment tracking, Server monitoring)

1. Experiment tracking
- Library: Aim
- Easy to track experiments and compare results
- Pytorch tutorial is in aim_tutorial
```
cd aim_tutorial
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python pytorch_test.py
aim up #after python process end
#There will be url for aim dashboard UI
```
***
2. Server monitoring
- Library: Grafana, Prometheus, node-exporter
- Easy to check server monitoring with prebuilt Grafana Dashboard
- To see the Grafana Web UI, 3000 port has to be opened

```
# There is sudo-password in node_exporter_start.sh. Change it to the sudo-password that owner uses
# We have to track host server so install node_exporter in host is better than using Docker
bash node_exporter_start.sh

# Grafana and Prometheus will be installed with Docker-Compose. Opening port for grafana and prometheus is included in run.sh
# There is code which POST some prebuilt dashboards to Grafana. If you want to test another dashboards, go https://grafana.com/grafana/dashboards/ and change dash_num.
bash run.sh
```
- There are more options for Server monitoring like TIG stack(Telegraf, InfluxDB, Grafana)
