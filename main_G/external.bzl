load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("external_1.bzl", "external_1")
load("external_2.bzl", "external_2")
load("external_3.bzl", "external_3")

def external():
    external_1()
    external_2()
    external_3()
