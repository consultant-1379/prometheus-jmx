#!/bin/bash
set -xe
.bob/container-structure-test -test.v -image $1 jmx-single-port/test/metadata_tests.yaml
.bob/container-structure-test -test.v -image $1 jmx-single-port/test/file_tests.yaml
