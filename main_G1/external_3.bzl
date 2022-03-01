load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def external_3():
    http_archive(
        name = "external",
        url = "file:../external_3.tar",
        strip_prefix = "external_3",
    )
