# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /home/hirano/.linuxbrew/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

require 'formula'

HOMEBREW_PROTEINDF_VERSION = '2014.0.3'

class Proteindf < Formula
  homepage 'https://github.com/ProteinDF/ProteinDF'
  url 'https://github.com/ProteinDF/ProteinDF.git', :tag => "#{HOMEBREW_PROTEINDF_VERSION}"
  version #{HOMEBREW_PROTEINDF_VERSION}
  head 'http://github.com/ProteinDF/ProteinDF.git', :branch => 'master'

  depends_on :automake
  depends_on :autoconf
  depends_on :libtool
  depends_on :fortran
  depends_on :lapack

  depends_on :mpi => [:cc, :cxx, :recommended ]
  depends_on :scalapack => :recommended
  option "without-openmp", "Build using OpenMP"


  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    ENV.append_to_cflags "-fopenmp" if build.with? "openmp"
    
    system "./bootstrap.sh"

    conf_args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-profile",
      "--with-blas",
      "--with-lapack"
    ]

    if build.with? "mpi"
      conf_args << "--enable-parallel"
      if build.with? "scalapack"
        conf_args << "--with-scalapack"
      end
    end
    
    system "./configure", *conf_args
    system "make"
    system "make", "install"
  end

  def caveats
    ohai "Set PDF_HOME env parameter to use ProteinDF, PDF_HOME=#{prefix}"
  end

end

__END__

