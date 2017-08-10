project(
  'bax2bam',
  'cpp',
  version : '0.0.8',
  default_options : [
    'buildtype=release',
    'warning_level=3',
    'cpp_std=c++14'],
  license : 'BSD-3',
  meson_version : '>= 0.41.1')

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

################
# dependencies #
################

# HDF5
libhdf5_cflags = []
if get_option('HDF5_CFLAGS') != ''
  libhdf5_cflags = get_option('HDF5_CFLAGS').split(' ')
endif

libhdf5_libs = []
if get_option('HDF5_LIBS') != ''
  libhdf5_libs = get_option('HDF5_LIBS').split(' ')
endif

# boost
bax2bam_boost_dep = dependency('boost', required : true)

# libblasr
bax2bam_libblasr_dep = dependency('libblasr', fallback : ['blasr_libcpp', 'libblasr_dep'])

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
  dependencies : [bax2bam_libblasr_dep, bax2bam_boost_dep],
  cpp_args : [libhdf5_cflags, bax2bam_warning_flags],
  link_args : libhdf5_libs)

#########
# tests #
#########

if get_option('enable-bax2bam-tests')
  subdir('tests')
endif
