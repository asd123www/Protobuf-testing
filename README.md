# Profobuf latency

## config

```
Cloudlab-xl170
Ubuntu 20.04, 5.4.0-164-generic
amd64 libprotobuf-lite17 amd64 3.6.1.3-2ubuntu5.2
```

## Serialization Latency

|                     | Round1 | Round2 | Round3 | Round4 | Round5 |
| ------------------- | ------ | ------ | ------ | ------ | ------ |
| Variance            | 0.158  | 0.157  | 0.253  | 0.343  | 0.226  |
| Average latency     | 0.287  | 0.287  | 0.286  | 0.288  | 0.288  |
| 50th latency        | 0.282  | 0.282  | 0.282  | 0.282  | 0.282  |
| 90th tail latency   | 0.301  | 0.301  | 0.300  | 0.302  | 0.301  |
| 99th tail latency   | 0.320  | 0.322  | 0.318  | 0.322  | 0.321  |
| 99.9th tail latency | 0.487  | 0.378  | 0.453  | 0.392  | 0.457  |

