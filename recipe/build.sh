#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname)" == "Linux" ]]; then
    ORT_TAG="v1.24.4"
    ORT_SRC="${SRC_DIR}/_onnxruntime"
    ORT_BUILD_CONFIG="Release"

    git clone --depth 1 --branch "${ORT_TAG}" --recurse-submodules \
        https://github.com/microsoft/onnxruntime.git "${ORT_SRC}"

    (
        cd "${ORT_SRC}"
        ./build.sh \
            --config "${ORT_BUILD_CONFIG}" \
            --parallel "${CPU_COUNT}" \
            --compile_no_warning_as_error \
            --skip_submodule_sync \
            --skip_tests \
            --allow_running_as_root
    )

    export ORT_LIB_PATH="${ORT_SRC}/build/Linux/${ORT_BUILD_CONFIG}"

    ${PYTHON} -m pip install . -vv \
        --config-settings=build-args='--no-default-features --features ort-static'
else
    ${PYTHON} -m pip install . -vv
fi

cd rust
cargo-bundle-licenses --format yaml --output ../THIRDPARTY.yml
