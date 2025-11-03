class AwsSsoProfile < Formula
  desc "Generate and manage AWS CLI profiles using AWS SSO sessions"
  homepage "https://github.com/advantageous/AWS-SSO-Profile-Manager"
  url "https://github.com/advantageous/AWS-SSO-Profile-Manager/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "76a11287a2ce8e6c438c8123062b3bcebe2b465b319e293214951ea5d5ad6aff"
  license "MIT"

  depends_on "bash"
  depends_on "jq"
  depends_on "yq"
  depends_on "awscli"

  def install
    bin.install "aws-sso-profile"
  end

  test do
    (testpath/"sessions.yaml").write <<~YAML
      adv:
        start_url: https://advantageous.awsapps.com/start
        sso_region: eu-central-1
    YAML

    assert_match "aws-sso-profile", shell_output("#{bin}/aws-sso-profile --version")
    assert_match "adv",
      shell_output("#{bin}/aws-sso-profile list --import-file #{testpath}/sessions.yaml --dry-run")

    system "#{bin}/aws-sso-profile", "generate",
           "--import-file", testpath/"sessions.yaml",
           "--output-file", testpath/"config",
           "--sso-session", "Advantageous",
           "--dry-run", "--non-interactive", "--force"
  end
end
