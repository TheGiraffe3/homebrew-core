require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/http-party/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-14.0.0.tgz"
  sha256 "fbe42ce2338184bc08c414f98b512d272039803f93c3759ecb0678deaa728c7e"
  license "MIT"
  head "https://github.com/http-party/http-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "acc77203811de4c980baa662d356213361c567a08f66bf0eaef620bdcc9b2980"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/http-server", "-p#{port}"
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "200 OK", output
  ensure
    Process.kill("HUP", pid)
  end
end
