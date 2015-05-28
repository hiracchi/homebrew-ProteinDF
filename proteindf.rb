require 'formula'

HOMEBREW_PROTEINDF_VERSION = '2014.0.3'
class ProteinDF < Formula
  homepage 'https://github.com/ProteinDF/ProteinDF'
  url 'https://github.com/ProteinDF/ProteinDF.git', :tag => "#{HOMEBREW_PROTEINDF_VERSION}"
  version HOMEBREW_PROTEINDF_VERSION
  head 'http://github.com/ProteinDF/ProteinDF.git', :branch => 'master'

  depends_on "automake"
  depends_on "autoconf"
  depends_on "libtool"
  
  def install
    system "./bootstrap.sh"
    system "./configure",
           "--prefix=#{prefix}",
           "--with-blas",
           "--with-lapack"
    system "make"
    system "make", "install"
  end
end

  
