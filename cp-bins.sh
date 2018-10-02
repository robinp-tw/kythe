cp bazel-bin/kythe/go/serving/tools/write_tables/write_tables /opt/kythe-local/tools/

cp bazel-bin/kythe/go/storage/tools/write_entries/write_entries /opt/kythe-local/tools/

cp bazel-bin/kythe/go/serving/tools/http_server/http_server /opt/kythe-local/tools/

cp bazel-bin/kythe/cxx/extractor/cxx_extractor /opt/kythe-local/extractors/
# TODO(robinp): don't hardcode store path, rather query
patchelf --set-rpath $(patchelf --print-rpath /opt/kythe-local/extractors/cxx_extractor):/nix/store/s2n99784krxl91mfw3cnn9ylbb5fjvkx-ncurses-6.1/lib /opt/kythe-local/extractors/cxx_extractor

cp bazel-bin/kythe/cxx/indexer/cxx/indexer /opt/kythe-local/indexers/cxx_indexer
patchelf --set-rpath $(patchelf --print-rpath /opt/kythe-local/indexers/cxx_indexer):/nix/store/s2n99784krxl91mfw3cnn9ylbb5fjvkx-ncurses-6.1/lib /opt/kythe-local/indexers/cxx_indexer

