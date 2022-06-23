#Setting node_exporter
export http_proxy=http://proxy-dmz.intel.com:912
export https_proxy=http://proxy-dmz.intel.com:912
export no_proxy="127.0.0.1,localhost,intel.com"

curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar -xvf node_exporter-1.0.1.linux-amd64.tar.gz
echo ${sudo-password} | sudo -S command

sudo mv node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/

sudo touch /etc/systemd/system/node_exporter.service
sudo chmod 777 /etc/systemd/system/node_exporter.service

sudo echo '[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
Environment="HTTP_PROXY=http://proxy-dmz.intel.com:912"
Environment="HTTPS_PROXY=http://proxy-dmz.intel.com:912/"
Environment="NO_PROXY="localhost,intel.com"

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/node_exporter.service

sudo useradd -M -r -s /bin/false node_exporter

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

exit