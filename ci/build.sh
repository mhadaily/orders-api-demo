#!/usr/bin/env bash
# Build, check, publish the web output and pack the contracts library.
# Run with `bash ci/build.sh` from anywhere; executable mode is not assumed.
# This script never pushes a package: feed publishing is a separate, opt-in
# pipeline step (publishPackages) that Module 1 never turns on.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
if [[ -e out ]]; then
  printf '%s\n' 'STOP: out already exists; inspect and remove only generated output before retry.'
  exit 2
fi
version="${PACKAGE_VERSION:-1.0.0-local}"
run_id="${RUN_ID:-local}"
revision="${SOURCE_REVISION:-unrecorded-local}"
mkdir -p out/web out/packages

dotnet --version
dotnet restore src/Orders.Api/Orders.Api.csproj
dotnet restore tests/Orders.Checks/Orders.Checks.csproj
dotnet build src/Orders.Api/Orders.Api.csproj --configuration Release --no-restore
dotnet build tests/Orders.Checks/Orders.Checks.csproj --configuration Release --no-restore
dotnet run --project tests/Orders.Checks/Orders.Checks.csproj --configuration Release --no-build
dotnet publish src/Orders.Api/Orders.Api.csproj --configuration Release --no-build --output "$root/out/web"
dotnet pack src/Orders.Contracts/Orders.Contracts.csproj --configuration Release --no-build "-p:PackageVersion=$version" --output "$root/out/packages"

printf 'workload=orders-api\nrun_id=%s\nsource_revision=%s\npackage_version=%s\n' \
  "$run_id" "$revision" "$version" | tee out/web/release-evidence.txt
test -f out/web/Orders.Api.dll
test -f "out/packages/Globomantics.Orders.Contracts.$version.nupkg"
printf '%s\n' 'PASS: deployable output and contracts package prepared'
