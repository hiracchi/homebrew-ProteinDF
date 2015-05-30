# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /home/hirano/.linuxbrew/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

require 'formula'

HOMEBREW_PROTEINDF_VERSION = '2014.0.3'

class Proteindf < Formula
  homepage 'https://github.com/ProteinDF/ProteinDF'
  url 'https://github.com/ProteinDF/ProteinDF.git', :tag => "#{HOMEBREW_PROTEINDF_VERSION}"
  version HOMEBREW_PROTEINDF_VERSION
  head 'http://github.com/ProteinDF/ProteinDF.git', :branch => 'master'

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on :fortran
  depends_on "lapack" => ["with-blas", "with-lapack"]

  depends_on :mpi => [:cc, :cxx, :f90, :recommended]
  if build.with? "mpi"
    depends_on "scalapack" => ["with-scalapack", :recomended]
  end
  option "with-openmp", "Build using OpenMP"


  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    ENV.append_to_cflags "-fopenmp" if build.with? "openmp"
    
    system "./bootstrap.sh"

    conf_args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-profile",
    ]
    conf_args << "--with-blas" if build.with? "blas"
    conf_args << "--with-lapack" if build.with? "lapack"

    if build.with? "mpi"
      conf_args << "--enable-parallel"
      if build.with? "scalapack"
        conf_args << "--with-scalapack"
      end
    end
    
    system "./configure", *conf_args
    system "make"
    system "make", "install"

    ohai "Set PDF_HOME env parameter to use ProteinDF,"
    ohai "PDF_HOME=#{PREFIX}" 
  end
end


  
