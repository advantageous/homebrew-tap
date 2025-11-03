class AwsSsoProfile < Formula
  desc "Generate and manage AWS CLI profiles using AWS SSO sessions"
  homepage "https://github.com/advantageous/AWS-SSO-Profile-Manager"
  url "https://github.com/advantageous/AWS-SSO-Profile-Manager/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d97723adb79b17b1285aaf74963bed7dfd43c414d83c47d4c98c9ec505a83b72"
  license "MIT"

  depends_on "bash"
  depends_on "jq"
  depends_on "yq"

  def install
    bin.install "aws-sso-profile"
  end

  test do
    (testpath/"sessions.yaml").write <<~YAML
      Advantageous:
        prefix: adv
        start_url: https://advantageous.awsapps.com/start
        sso_region: eu-central-1
    YAML

    assert_match "aws-sso-profile", shell_output("#{bin}/aws-sso-profile --version")
    assert_match "Advantageous",
      shell_output("#{bin}/aws-sso-profile list --import-file #{testpath}/sessions.yaml --dry-run")

    system "#{bin}/aws-sso-profile", "generate",
           "--import-file", testpath/"sessions.yaml",
           "--output-file", testpath/"config",
           "--sso-session", "Advantageous",
           "--dry-run", "--non-interactive", "--force"
  end
end
