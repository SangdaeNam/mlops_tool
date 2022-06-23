#Setting Prometheus
root=$(pwd)
sudo mkdir -p /data/docker/prometheus/
sudo cp prometheus.yml /data/docker/prometheus/prometheus.yml

mkdir prometheus
cd prometheus

sudo useradd -M -r -s /bin/false grafana
docker volume create --name=prometheus_data
docker volume create --name=grafana_data
docker volume ls

sudo useradd -M -r -s /bin/false grafana

sudo ufw allow 3000/tcp
sudo ufw allow 9090/tcp
sudo ufw allow 9100/tcp

docker-compose up -d

curl http://admin:admin@localhost:3000/api/datasources --header 'Content-Type: application/json' --data @"$root/local-datasource.json"

sudo apt-get install jq

dash_num=1860
curl https://grafana.com/api/dashboards/$dash_num | jq '.json' > "$root/dashboard-$dash_num.json"

( echo '{ "overwrite": true, "dashboard" :'; \
    cat "$root/dashboard-$dash_num.json"; \
    echo '}' ) \
    | jq \
    > "$root/dashboard-$dash_num-modified.json"

curl http://admin:admin@localhost:3000/api/dashboards/db \
    --header 'Content-Type: application/json' \
    --data @"$root/dashboard-$dash_num-modified.json"
