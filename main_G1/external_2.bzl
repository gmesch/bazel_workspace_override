load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def external_2():
    http_archive(
        name = "external",
        url = "file:../external_2.tar",
        strip_prefix = "external_2",
    )
