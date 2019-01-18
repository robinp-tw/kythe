package(default_visibility = ["//kythe:default_visibility"])

filegroup(
    name = "ui",
    srcs = [":prod-js"] + glob(["resources/public/**"]),
    tags = ["manual"],
)

genrule(
    name = "prod-js",
    srcs = glob([
        "project.clj",
        "src-cljs/**/*.cljs",
    ]),
    outs = [
        "resources/public/js/main.js",
        "resources/public/js/licenses.txt",
    ],
    cmd = "\n".join([
        "lein=\"$$PWD/$(location //third_party/leiningen:lein)\"",
        "export HOME=/tmp/lein",
        "mkdir -p $$HOME",
        "export WGET_DIR=$$(dirname $(location @wget//:bin))",
        "export JAVA_DIR=$$(dirname $(location @jre//:bin/java))",
        "export PATH=$$(readlink -f $$WGET_DIR):$$(readlink -f $$JAVA_DIR):$$PATH",
        "cd kythe/web/ui",
        "$$lein deps",
        "$$lein cljsbuild once prod",
        "$$lein licenses | sort > licenses.txt",
        "cd ../../..",
        "cp kythe/web/ui/resources/public/js/main.js $(location resources/public/js/main.js)",
        "mv kythe/web/ui/licenses.txt $(location resources/public/js/licenses.txt)",
    ]),
    heuristic_label_expansion = False,
    local = 1,
    tags = ["manual"],
    tools = [
        "//third_party/leiningen:lein",
        "@wget//:bin",
        "@jre//:bin/java",
    ],
)
