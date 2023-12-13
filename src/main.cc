#include "generated/protos/kv-proto.pb.h"

#include <iostream>
#include <algorithm>
#include <random>
#include <string>


#define WARMUP 100000
#define TOTAL_ROUND 2000000
#define KEY_LEN 128
#define VALUE_LEN 1024

struct timespec start, end;


long arr[TOTAL_ROUND + 5];
int cmpfunc (const void * a, const void * b) {
   return ( *(int*)a - *(int*)b );
}
void queryStatistic(long a[]) {
    int n = a[0];
    qsort(a + 1, n, sizeof(a[0]), cmpfunc);
    double sum = 0.0;
    for(int i = 1; i <= n; ++i) sum += a[i];
    double var = 0.0;
    for(int i = 1; i <= n; ++i) var += ((double)a[i] * 0.001)*(double)(a[i] * 0.001);
    printf("Variance: %.3f\n", (var - (sum * 0.001) / n * (sum * 0.001)) / n);

    printf("Average latency: %.3f\n", sum / n * 0.001);
    printf("50th tail latency: %.3f\n", a[(long)(n * 0.5)] * 0.001);
    printf("90th tail latency: %.3f\n", a[(long)(n * 0.9)] * 0.001);
    printf("99th tail latency: %.3f\n", a[(long)(n * 0.99)] * 0.001);
    printf("99.9th tail latency: %.3f\n", a[(long)(n * 0.999)] * 0.001);
}


int main() {
    printf("Hello world!\n");

    kv::proto::RequestMessage* req;
    char *key, *value;
    char buffer[10240];

    for (int i = 0; i < TOTAL_ROUND; ++i) {
        req = new kv::proto::RequestMessage();
        key = new char[KEY_LEN]; // 128
        value = new char[VALUE_LEN]; // 1024

        clock_gettime(CLOCK_MONOTONIC, &start);
        req->set_opt("SET");
        req->set_key(key);
        req->set_value(value);
        std::string data = req->SerializeAsString();
        memcpy(buffer, data.c_str(), data.length());
        clock_gettime(CLOCK_MONOTONIC, &end);
        
        if (i > WARMUP) {
            arr[++arr[0]] = end.tv_sec * 1000000000LL + end.tv_nsec - start.tv_sec * 1000000000LL - start.tv_nsec;
        }

        delete(req);
        delete(key);
        delete(value);
    }
    
    queryStatistic(arr);

    return 0;
}