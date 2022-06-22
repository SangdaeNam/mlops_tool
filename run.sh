export http_proxy=http://proxy-dmz.intel.com:912
export https_proxy=http://proxy-dmz.intel.com:912
export no_proxy="127.0.0.1,localhost,intel.com"
#Setting Prometheus
sudo mkdir -p /data/docker/prometheus/
sudo cp prometheus.yml /data/docker/prometheus/prometheus.yml

mkdir prometheus
cd prometheus

# sudo useradd -M -r -s /bin/false grafana
docker volume create --name=prometheus_data
docker volume create --name=grafana_data
docker volume ls

sudo useradd -M -r -s /bin/false grafana

docker-compose up -d

sudo ufw allow 3000/tcp
sudo ufw allow 9090/tcp

curl http://admin:admin@localhost:3000/api/datasources --header 'Content-Type: application/json' --data @/home/sangdaen/workspace/mlops_tool/local-datasource.json

sudo apt-get insatll jq
curl https://grafana.com/api/dashboards/1860 | jq '.json' > /home/sangdaen/workspace/mlops_tool/dashboard-1860.json

( echo '{ "overwrite": true, "dashboard" :'; \
    cat /home/sangdaen/workspace/mlops_tool/dashboard-1860.json; \
    echo '}' ) \
    | jq \
    > /home/sangdaen/workspace/mlops_tool/dashboard-1860-modified.json

curl http://admin:admin@localhost:3000/api/dashboards/db \
    --header 'Content-Type: application/json' \
    --data @/home/sangdaen/workspace/mlops_tool/dashboard-1860-modified.json