# Bazel external workspace override behavior

Bazel supports the import of external workspaces. Each imported workspace is
given a name by which its build targets can be referenced from the main
workspace.

It thus can happen that two different workspaces are imported under the same
name, and then the question arises which workspace actually appears under this
name.

There are two rules that govern this situation:

1. The last imported workspace becomes available to the main workspace,
   according to the documentation.

2. It is an error to import a workspace under an already existing name *after* a
   `load()` statement was executed in the target workspace, according to the
   error message that `bazel` gives when this is attempted.

## Problems

The rules as given above can be observed using the `local_repository()`
workspace rule. However, the rules are violated by the `http_archive()`
repository rule, for reasons that are not obvious, and that lead to workspace
composition that is difficult to comprehend and reason about.

What is observed for `http_archive()` rules instead:

1. Even after the `load()` statement that loads the `http_archive()` or even
   `load()` statements that load other functions, multiple `http_archive()`
   rules for the same name *can* be loaded without error. In many such cases,
   the *last* loaded instance becomes effective.

2. However, there *are* situations in which it's not the *last* workspace loaded
   that becomes effective. This happens if other `load()` statements than the
   one for `http_archive()` appear *after* an `http_archive()` call. In that
   case, the last such workspace of a given name becomes effective.

3. In those situations, the remaining workspaces are *silently* not loaded,
   without causing an error or even any indication.

## Demonstration

The problems above are demonstrated in a series of workspaces in this
repository.

Each main workspace is called `main_<id>`. Each main workspace imports three
external workspaces `external_{1,2,3}` all under the workspace name `external`,
in various configurations.

Each external workspace defines the build target `//:note`, which is a genrule
for a document `note.txt` that contains the full name of the external workspace,
i.e. one of `external_{1,2,3}`.

Thus, by executing `bazel build @external//:note` and then inspecting the
content of the file `bazel-bin/external/external/note.txt`, it is easily
possible to observe which of the three external workspaces was actually imported
under the name `@external`.

The setup and observations are each descibed in a comment in the `WORKSPACE`
files of the `main_*` workspaces.

# Appendix

## Bazel error message

The error message can be reproduced by workspace [main_B](main_B/WORKSPACE) in
this repository:

```
mesch@macswell ~/pro/bazel_workspace_override/main_B $ bazel build @external//:note
Starting local Bazel server and connecting to it...
ERROR: Traceback (most recent call last):
	File "/Users/mesch/pro/bazel_workspace_override/main_B/WORKSPACE", line 26, column 17, in <toplevel>
		local_repository(
Error in local_repository: Cannot redefine repository after any load statement in the WORKSPACE file (for repository 'extern')
ERROR: error loading package 'external': Package 'external' contains errors
INFO: Elapsed time: 1.307s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (0 packages loaded)
```
