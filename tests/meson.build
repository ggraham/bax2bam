bax2bam_gtest_dep = dependency('gtest', fallback : ['gtest', 'gtest_with_main_dep'])

bax2bam_TestData_h_config = configuration_data()
bax2bam_TestData_h_config.set('Bax2Bam_BinDir', meson.build_root())
bax2bam_TestData_h_config.set('Bax2Bam_TestsDir', meson.current_source_dir())
bax2bam_TestData_h_config.set('CMAKE_CURRENT_BINARY_DIR', meson.current_build_dir())

bax2bam_TestData_h = configure_file(
  input : 'src/TestData.h.in',
  output : 'TestData.h',
  configuration : bax2bam_TestData_h_config)

bax2bam_test_cpp_sources = files([
  'src/TestUtils.cpp',
  'src/test_polymerase.cpp',
  'src/test_subreads.cpp',
  'src/test_common.cpp',
  'src/test_ccs.cpp',
  'src/test_hqregions.cpp'])

bax2bam_test = executable(
  'bax2bam_test',
  bax2bam_test_cpp_sources,
  dependencies : [bax2bam_gtest_dep, bax2bam_libblasr_dep],
  cpp_args : [libhdf5_cflags, bax2bam_warning_flags],
  link_args : libhdf5_libs,
  install : false)

test('bax2bam test', bax2bam_test)
