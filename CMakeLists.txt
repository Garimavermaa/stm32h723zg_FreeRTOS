cmake_minimum_required(VERSION 3.5.0)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/STM32H723ZG.cmake)
project(STD1)
set_property(SOURCE C:/Garima/Project/std_1/startup_stm32h723xx.s PROPERTY LANGUAGE C)


set(FREERTOS_DIR C:/Garima/Project/std_1/Middlewares/Third_Party/FreeRTOS/Source)
set(DRIVERS_DIR C:/Garima/Project/std_1/Drivers)

if(${CMAKE_BUILD_TYPE} STREQUAL "debug")
    set(BUILD_DIR C:/Garima/Project/std_1/Build/debug)
elseif(${CMAKE_BUILD_TYPE} STREQUAL "release")
    set(BUILD_DIR C:/Garima/Project/std_1/Build/release)
endif()

file(GLOB_RECURSE USER_SOURCES "Core/Src/*.c")
file(GLOB_RECURSE HAL_SOURCES "Drivers/STM32H7xx_HAL_Driver/Src/*.c")
file(
    GLOB_RECURSE
    FREERTOS_SOURCES
    "${FREERTOS_DIR}/*.c"
    "${FREERTOS_DIR}/CMSIS_RTOS_V2/*.c"
    "${FREERTOS_DIR}/portable/GCC/ARM_CM4F/*.c"
)

add_library(
    CMSIS
    C:/Garima/Project/std_1/Core/Src/system_stm32h7xx.c
    C:/Garima/Project/std_1/startup_stm32h723xx.s
    C:/Garima/Project/std_1/Drivers/BSP/STM32H7xx_Nucleo/stm32h7xx_nucleo.c
)

include_directories(C:/Garima/Project/std_1/Core/Inc)
include_directories(${DRIVERS_DIR}/STM32H7xx_HAL_Driver/Inc)
include_directories(${DRIVERS_DIR}/CMSIS/Include)
include_directories(${DRIVERS_DIR}/CMSIS/Device/ST/STM32H7xx/Include)
include_directories(${DRIVERS_DIR}/BSP/STM32H7xx_Nucleo)

include_directories(${FREERTOS_DIR})
include_directories(${FREERTOS_DIR}/CMSIS_RTOS_V2)
include_directories(${FREERTOS_DIR}/include)
include_directories(${FREERTOS_DIR}/portable/GCC/ARM_CM4F)
include_directories(${FREERTOS_DIR}/portable/GCC/MemMang)

# target_include_directories(${PROJECT_NAME} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>/Drivers/STM32H7xx_HAL_Driver/Inc)

SET(LINKER_SCRIPT ${PROJECT_SOURCE_DIR}/STM32H723ZGTx_FLASH.ld)

add_executable(${PROJECT_NAME}.elf ${USER_SOURCES} ${HAL_SOURCES} ${LINKER_SCRIPT} ${FREERTOS_SOURCES})

target_link_libraries(${PROJECT_NAME}.elf CMSIS)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${BUILD_DIR}/${PROJECT_NAME}.map")
set(HEX_FILE ${BUILD_DIR}/${PROJECT_NAME}.hex)
set(BIN_FILE ${BUILD_DIR}/${PROJECT_NAME}.bin)

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${HEX_FILE}
        COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}.elf> ${BIN_FILE}
        COMMENT "Building ${HEX_FILE} \nBuilding ${BIN_FILE}")
