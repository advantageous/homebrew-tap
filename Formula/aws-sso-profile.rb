class AwsSsoProfile < Formula
  desc "Generate and manage AWS CLI profiles using AWS SSO sessions"
  homepage "https://github.com/advantageous/AWS-SSO-Profile-Manager"
  url "https://github.com/advantageous/AWS-SSO-Profile-Manager/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "e6058cae35258f32e3b269057654fd25e2358d684b2c0b8cc2957d274cbac0b9"
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
