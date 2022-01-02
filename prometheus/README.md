## Running prometheus instance on docker

```shell
docker build -t my-prometheus .
docker run --network="host" -p 9090:9090 my-prometheus
```

## Running grafana instance on docker

```shell
docker build -f Grafana.Dockerfile -t my-grafana .
docker run --network="host" -p 3000:3000 my-grafana
```
