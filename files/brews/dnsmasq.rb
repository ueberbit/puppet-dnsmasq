require 'formula'

class Dnsmasq < Formula
  homepage 'http://www.thekelleys.org.uk/dnsmasq/doc.html'
  url 'http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.71.tar.gz'
  sha1 'b0a39f66557c966629a0ed9282cd87df8f409004'
  version '2.71-boxen1'

  bottle do
    sha1 "96d2784aa36024ce06c727c323c211b0f278950f" => :mavericks
    sha1 "ede61cf944079d566a059bd4638c75df22bc7057" => :mountain_lion
    sha1 "a65ee0871fb0dd2d037d1742ca51d38f56005bb4" => :lion
  end

  option 'with-idn', 'Compile with IDN support'
  option 'with-dnssec', 'Compile with DNSSEC support'

  depends_on "libidn" if build.with? "idn"
  depends_on "nettle" if build.with? "dnssec"
  depends_on 'pkg-config' => :build

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace "src/config.h", "/etc/dnsmasq.conf", "#{etc}/dnsmasq.conf"

    # Optional IDN support
    if build.with? "idn"
      inreplace "src/config.h", "/* #define HAVE_IDN */", "#define HAVE_IDN"
    end

    # Optional DNSSEC support
    if build.with? "dnssec"
      inreplace "src/config.h", "/* #define HAVE_DNSSEC */", "#define HAVE_DNSSEC"
    end

    # Fix compilation on Lion
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542" if MacOS.version >= :lion
    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
    end

    system "make", "install", "PREFIX=#{prefix}"
  end
end
