class Aarg < Formula
  desc "The Adversarial Agentic Resume Generator - a local-first CLI that tailors resumes to job descriptions without fabricating experience"
  homepage "https://github.com/joseym/aarg"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/joseym/aarg/releases/download/v0.5.0/aarg-aarch64-apple-darwin.tar.xz"
      sha256 "a77816a26eca5b1f76c30c8cc4030b60ac4b5a34a3ca13853154775cdb854934"
    end
    if Hardware::CPU.intel?
      url "https://github.com/joseym/aarg/releases/download/v0.5.0/aarg-x86_64-apple-darwin.tar.xz"
      sha256 "7300e5d84d4d0d8782aae196e1ef0766400cb19faa42c5d23631a6fcd07e0086"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/joseym/aarg/releases/download/v0.5.0/aarg-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "69a4a230ead49c2e46e1a22754e86d721a1dd0c00f1245bc0606db0d5db66b73"
  end
  license any_of: ["MIT", "Apache-2.0"]
  depends_on "typst"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "aarg" if OS.mac? && Hardware::CPU.arm?
    bin.install "aarg" if OS.mac? && Hardware::CPU.intel?
    bin.install "aarg" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
