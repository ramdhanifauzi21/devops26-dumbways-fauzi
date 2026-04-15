# Task - Week 3

## [Terraform]

1. Dengan mendaftar akun free tier AWS/GCP/Azure, buatlah Infrastructre dengan terraform menggunakan registry yang sudah ada. dengan beberapa aturan berikut :
   - Buatlah 2 buah server dengan OS ubuntu 24 dan debian 11 (Untuk spec menyesuaikan)
   - attach vpc ke dalam server tersebut
   - attach ip static ke vm yang telah kalian buat
   - pasang firewall ke dalam server kalian dengan rule {allow all ip(0.0.0.0/0)}
   - buatlah 2 block storage di dalam terraform kalian, lalu attach block storage tersebut ke dalam server yang ingin kalian buat. (pasang 1 ke server ubuntu dan 1 di server debian)
   - test ssh ke server

2. Buat terraform code kalian serapi mungkin
3. simpan script kalian ke dalam github dengan format tree sebagai berikut:

```sh

Automation

|

| Terraform

└─| └── gcp

│ └── main.tf

│ └── providers.tf

│ └── etc

├── aws

│ └── main.tf

│ └── providers.tf

│ └── etc

├── azure

│ └── main.tf

│ └── providers.tf

│ └── etc

```

Reference :

[Amazon Web Services (AWS)](https://aws.amazon.com/free/)

[Google Cloud Platform (GCP)](https://cloud.google.com/free)

[Microsoft Azure](https://azure.microsoft.com/en-us/pricing/free-services)


## [Ansible]

Buatlah ansible untuk :

1. Membuat user baru, gunakan login ssh key & password
2. Instalasi Docker
3. Deploy application frontend yang sudah kalian gunakan sebelumnya menggunakan ansible.
4. Instalasi Monitoring Server (node exporter, prometheus, grafana)
5. Setup reverse-proxy
6. Generated SSL certificate
7. simpan script kalian ke dalam github dengan format tree sebagai berikut:

```sh

Automation

|

| Terraform

└─| └── gcp

│ └── main.tf

│ └── providers.tf

│ └── etc

│ ├── aws

│ └── main.tf

│ └── providers.tf

│ └── etc

│ ├── azure

│ └── main.tf

│ └── providers.tf

│ └── etc

Ansible

├── ansible.cfg

├── lolrandom1.yaml

├── group_vars

│ └── all

├── Inventory

├── lolrandom2.yaml

└── lolrandom3.yaml

```

## [Monitoring Server]

1. Setup node-exporter, prometheus dan Grafana menggunakan docker / native diperbolehkan
2. monitoring seluruh server yang kalian buat di materi terraform dan yang kalian miliki di biznet.
3. Reverse Proxy
   - bebas ingin menggunakan nginx native / docker

4. Domain
   - exporter-$name.studentdumbways.my.id (node exporter)
   - prom-$name.studentdumbways.my.id (prometheus)
   - monitoring-$name.studentdumbways.my.id (grafana)

5. SSL Cloufflare on / certbot SSL biasa / wildcard SSL diperbolehkan
6. Dengan Grafana, buatlah :
   - Dashboard untuk monitor resource server (CPU, RAM & Disk Usage) buatlah se freestyle kalian.
   - Buat dokumentasi tentang rumus promql yang kalian gunakan
   - Buat alerting dengan Contact Point pilihan kalian (discord, telegram, slack dkk)

7. Untuk alert :
   - Boleh menggunakan alert manager / alert rule dari grafana
   - Ketentuan alerting yang harus dibuat
   - CPU Usage over 20%
   - RAM Usage over 75%
   - Monitoring specific container
   - deploy application frontend di app-server
   - monitoring frontend container
   - untuk alerting bisa di check di server discord yaa, sudah di buatkan channel alerting

Reference :

[node-exporter](https://hub.docker.com/r/prom/node-exporter)

[Prometheus](https://hub.docker.com/r/prom/prometheus)

[Grafana Dashboard](https://hub.docker.com/r/grafana/grafana)

[Cadvisor](https://github.com/google/cadvisor)
