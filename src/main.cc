#include "generated/protos/kv-proto.pb.h"

#include <iostream>
#include <algorithm>
#include <random>
#include <string>



int main() {
    printf("Hello world!\n");

    kv::proto::RequestMessage req;
    req.set_opt("GET");
    req.set_key("asd123www");
    req.set_value("A computer scientist!");

    
    return 0;
}