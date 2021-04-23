cmake_minimum_required(VERSION 3.16.3)
project(bax2bam)

include(FetchContent)
FetchContent_Declare(
  googletest
  # Specify the commit you depend on and update it regularly.
  URL https://github.com/google/googletest/archive/609281088cfefc76f9d0ce82e1ff6c30cc3591e5.zip
)

FetchContent_Declare(
    blasr_libcpp
    # URL https://github.com/PacificBiosciences/blasr_libcpp.git
    URL https://github.com/PacificBiosciences/blasr_libcpp/archive/refs/heads/develop.zip
)

FetchContent_Declare(
    pbbam
    URL https://github.com/PacificBiosciences/pbbam/archive/refs/heads/develop.zip
)

FetchContent_MakeAvailable(googletest)
FetchContent_MakeAvailable(blasr_libcpp)
FetchContent_MakeAvailable(pbbam)

file(GLOB SOURCES src/*.cpp)

add_executable(bax2bam ${SOURCES})

# Now simply link against gtest or gtest_main as needed. Eg
#target_link_libraries(example gtest_main)
#add_test(NAME example_test COMMAND example)