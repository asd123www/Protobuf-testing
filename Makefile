# Makefile to compile Protocol Buffers and C++ project

# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++11 -I.
LDFLAGS = -lprotobuf -pthread

# Protocol Buffers Compiler
PROTOC = protoc

# Directories
SRC_DIR = src
PROTO_DIR = protos
GEN_DIR = generated
GEN_PROTO_DIR = $(GEN_DIR)/$(PROTO_DIR)
GEN_SRC_DIR = $(GEN_DIR)/$(SRC_DIR)

CXXFLAGS +=  -I$(GEN_PROTO_DIR)

# Find all .proto files in the protos directory
PROTO_FILES = $(wildcard $(PROTO_DIR)/*.proto)

# Generated .pb.cc and .pb.h files
PB_SRCS = $(patsubst $(PROTO_DIR)/%.proto,$(GEN_PROTO_DIR)/%.pb.cc,$(PROTO_FILES))
PB_HDRS = $(patsubst $(PROTO_DIR)/%.proto,$(GEN_PROTO_DIR)/%.pb.h,$(PROTO_FILES))

# Object files for the protobufs and main application
OBJS = $(patsubst $(GEN_PROTO_DIR)/%.cc,$(GEN_PROTO_DIR)/%.o,$(PB_SRCS)) \
	   $(patsubst $(SRC_DIR)/%.cc,$(GEN_SRC_DIR)/%.o,$(wildcard $(SRC_DIR)/*.cc))

# Target executable
TARGET = main

.PHONY: all clean
.PRECIOUS: $(GEN_PROTO_DIR)/%.pb.cc $(GEN_PROTO_DIR)/%.pb.h

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $^ -o $@ $(LDFLAGS)

# Rule for compiling source files
$(GEN_SRC_DIR)/%.o: $(SRC_DIR)/%.cc
	@mkdir -p $(GEN_SRC_DIR)
	$(CXX) -c $< -o $@ $(CXXFLAGS)

# Rule for generating protobuf .cc and .h files
$(GEN_PROTO_DIR)/%.pb.cc $(GEN_PROTO_DIR)/%.pb.h: $(PROTO_DIR)/%.proto
	@mkdir -p $(GEN_PROTO_DIR)
	$(PROTOC) --cpp_out=$(GEN_PROTO_DIR) --proto_path=$(PROTO_DIR) $<

$(GEN_PROTO_DIR)/%.o: $(GEN_PROTO_DIR)/%.pb.cc $(GEN_PROTO_DIR)/%.pb.h
	$(CXX) -c $< -o $@ $(CXXFLAGS) 

clean:
	rm -rf $(GEN_DIR)
	rm -f $(OBJS) $(TARGET) $(PB_SRCS) $(PB_HDRS)
