class AwsSsoProfile < Formula
  desc "Generate and manage AWS CLI profiles using AWS SSO sessions"
  homepage "https://github.com/advantageous/AWS-SSO-Profile-Manager"
  url "https://github.com/advantageous/AWS-SSO-Profile-Manager/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "74d3de2"
  license "MIT"

  depends_on "bash" # ensures bash >= 5 on macOS
  depends_on "jq"
  depends_on "yq" # mike-farah/yq

  def install
    bin.install "aws-sso-profile"
    # Optional: man page or completions if you add them later
  end

  test do
    # Must not hit network or open a browser; use dry-run & local files only
    (testpath/"sessions.yaml").write <<~YAML
      Advantageous:
        prefix: adv
        start_url: https://advantageous.awsapps.com/start
        sso_region: eu-central-1
    YAML
    # help/version smoke tests
    assert_match "aws-sso-profile", shell_output("#{bin}/aws-sso-profile --help")
    assert_match "aws-sso-profile", shell_output("#{bin}/aws-sso-profile --version")
    # list from import file
    assert_match "Advantageous", shell_output("#{bin}/aws-sso-profile list --import-file #{testpath}/sessions.yaml --dry-run")
    # generate dry-run for specific session (no network)
    system "#{bin}/aws-sso-profile", "generate",
           "--import-file", testpath/"sessions.yaml",
           "--output-file", testpath/"config",
           "--sso-session", "Advantageous",
           "--dry-run", "--non-interactive", "--force"
  end
end
