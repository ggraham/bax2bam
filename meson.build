project(
  'bax2bam',
  'cpp',
  version : '0.0.9',
  default_options : [
    'buildtype=release',
    'warning_level=3',
    'cpp_std=c++14',
    'b_ndebug=false'],
  license : 'BSD-3',
  meson_version : '>= 0.46.0')

# TODO:
# try to reenable 'b_ndebug=true'
# this will require replacing a number of asserts
# with proper throw statements

############
# CXXFLAGS #
############

bax2bam_warning_flags = []
cpp = meson.get_compiler('cpp')
foreach cflag: [
  '-Wno-non-virtual-dtor',
  '-Wno-unused-parameter',
  '-Wno-unused-variable']
    if cpp.has_argument(cflag)
      bax2bam_warning_flags += cflag
    endif
endforeach

if cpp.get_id() == 'clang'
  foreach cflag: [
    '-Wno-overloaded-virtual']
      if cpp.has_argument(cflag)
        bax2bam_warning_flags += cflag
      endif
  endforeach
endif

################
# dependencies #
################

# boost
bax2bam_boost_dep = dependency('boost', required : true)

# libblasr
bax2bam_libblasr_dep = dependency('libblasr', fallback : ['blasr_libcpp', 'libblasr_dep'])

# zlib
bax2bam_zlib_dep = dependency('zlib', required : true, fallback : ['zlib', 'zlib_dep'])

# htslib
bax2bam_htslib_dep = dependency('htslib', required : true, version : '>=1.4', fallback : ['htslib', 'htslib_dep'])

bax2bam_deps = [
  bax2bam_boost_dep,
  bax2bam_libblasr_dep,
  bax2bam_zlib_dep,
  bax2bam_htslib_dep]

########################
# sources + executable #
########################

bax2bam_sources = files([
  'src/HqRegionConverter.cpp',
  'src/IConverter.cpp',
  'src/PolymeraseReadConverter.cpp',
  'src/Settings.cpp',
  'src/main.cpp',
  'src/CcsConverter.cpp',
  'src/SubreadConverter.cpp',
  'src/OptionParser.cpp',
  'src/Bax2Bam.cpp'])

bax2bam_exe = executable(
  'bax2bam',
  bax2bam_sources,
  install : true,
  dependencies : bax2bam_deps,
  cpp_args : bax2bam_warning_flags)

#########
# tests #
#########

if get_option('tests')
  subdir('tests')
endif
