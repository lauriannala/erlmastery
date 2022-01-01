## Running prometheus instance on docker

```shell
docker build -t my-prometheus .
docker run --network="host" -p 9090:9090 my-prometheus
```
