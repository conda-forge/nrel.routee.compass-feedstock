%PYTHON% -m pip install . -vv
if errorlevel 1 exit 1

cd rust
if errorlevel 1 exit 1

cargo-bundle-licenses --format yaml --output ..\THIRDPARTY.yml
if errorlevel 1 exit 1
