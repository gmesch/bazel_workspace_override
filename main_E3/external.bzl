load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def external_1():
    http_archive(
        name = "external",
        url = "file:../external_1.tar",
        strip_prefix = "external_1",
    )

def external_2():
    http_archive(
        name = "external",
        url = "file:../external_2.tar",
        strip_prefix = "external_2",
    )

def external_3():
    http_archive(
        name = "external",
        url = "file:../external_3.tar",
        strip_prefix = "external_3",
    )
