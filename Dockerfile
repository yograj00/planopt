# Use Ubuntu Jammy as the base image
FROM ubuntu:22.04

EXPOSE 80 22

# Set environment variable for the semester
ENV SEMESTER=planopt-hs23

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    update-ca-certificates

RUN apt-get install --no-install-recommends -y \
        nginx \
        cmake \
        g++ \
        git \
        make \
        python3 \
        flex \
        bison \
        ecl \
        zlib1g-dev \
        libgmp3-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /plop

# Install VAL
RUN git clone https://github.com/KCL-Planning/VAL.git VAL && cd VAL && git checkout a5565396007eee73ac36527fbf904142b3077c74 && make clean && sed -i 's/-Werror //g' Makefile && make && mv validate /usr/bin && rm -rf /plop/VAL

# Install INVAL
RUN git clone https://github.com/patrikhaslum/INVAL.git INVAL && cd INVAL && sed -i '1s|.*|#!/usr/bin/ecl -shell|g' compile-with-ecl && ./compile-with-ecl && mv inval /usr/bin && rm -rf /plop/INVAL

# Install soplex
RUN git clone https://github.com/scipopt/soplex.git soplex && cd soplex && git checkout a5df0814d67812c13a00f06eec507b4d071fb862 && cd .. && cmake -S soplex -B build && cmake --build build && cmake --install build && rm -rf /plop/soplex /plop/build

# Checkout Semester into WORKDIR
RUN git clone "https://github.com/aibasel-teaching/${SEMESTER}.git" .


