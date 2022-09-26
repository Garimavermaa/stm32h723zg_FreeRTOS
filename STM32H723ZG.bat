@echo off
cd C:\Garima\Project\std_1
cmake -BC:/Garima/Project/std_1/Build/debug -DCMAKE_TOOLCHAIN_FILE=C:/PNIDE/cmake/CMake_Threadx/cortex_m7.cmake -DCMAKE_BUILD_TYPE=debug -GNinja
cmake --build ./Build/debug

echo "Debug completed."

cmake -BC:/Garima/Project/std_1/Build/release -DCMAKE_TOOLCHAIN_FILE=C:/PNIDE/cmake/CMake_Threadx/cortex_m7.cmake -DCMAKE_BUILD_TYPE=release -GNinja
cmake --build ./Build/release

echo "release completed."
pause