bax2bam_cram_script = find_program('cram')

bax2bam_gtest_dep = dependency('gtest_main', fallback : ['gtest', 'gtest_main_dep'])

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

bax2bam_unit_test = executable(
  'bax2bam_test', [
    bax2bam_TestData_h,
    bax2bam_test_cpp_sources],
  install : false,
  dependencies : [bax2bam_gtest_dep, bax2bam_deps],
  cpp_args : bax2bam_warning_flags)

test(
  'bax2bam unit tests',
  bax2bam_unit_test,
  args : [
    '--gtest_output=xml:' + join_paths(meson.build_root(), 'bax2bam_results.xml')],
  workdir : meson.source_root(),
  timeout : 3600)

test(
  'bax2bam cram tests',
  bax2bam_cram_script,
  args : [
    '--xunit-file=' + join_paths(meson.build_root(), 'bax2bam-cram_xunit.xml'),
    '--verbose',
    files(['bax2bam.t'])],
  env : [
    'BAX2BAM=' + bax2bam_exe.full_path()],
  timeout : 3600)
