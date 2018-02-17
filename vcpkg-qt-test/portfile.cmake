# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)

# Set the source path for this version..
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/vcpkg-qt-test-${VERSION})

# Clear the existing source for this version.
file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/src/vcpkg-qt-test-${VERSION})

# Clone the directory from GitHub.
vcpkg_from_github(OUT_SOURCE_PATH SOURCE_PATH REPO AshwinKumarVijay/vcpkg-qt-test HEAD_REF master)

# Build the Project.
vcpkg_build_msbuild(
    PROJECT_PATH ${SOURCE_PATH}/vsproject/test.sln
    OPTIONS /p:ForceImportBeforeCppTargets=${VCPKG_ROOT_DIR}/scripts/buildsystems/msbuild/vcpkg.targets
    ) 

# Copy over the needed include files.
file(COPY ${SOURCE_PATH}/code/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/vcpkg-qt-test)

# Handle copyright - transfer license from GitHub.
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/vcpkg-qt-test RENAME copyright)
