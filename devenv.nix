{ pkgs, ... }:

{
  languages.ruby.enable = true;

  packages = with pkgs; [
    bash
    curl
    git
    jq
    ripgrep
    ruby
  ];

  enterShell = ''
    echo "homebrew-tap dev env"
    echo "  devenv test"
    echo "  devenv tasks run tap:syntax"
    echo "  devenv tasks run tap:brew-test"
  '';

  tasks = {
    "tap:syntax".exec = ''
      for formula in Formula/*.rb; do
        ruby -c "$formula"
      done
    '';

    "tap:audit".exec = ''
      if ! command -v brew >/dev/null 2>&1; then
        echo "brew not found; install Homebrew or run this task on a Homebrew host"
        exit 1
      fi

      for formula in Formula/*.rb; do
        brew audit --strict "$formula"
      done
    '';

    "tap:brew-test".exec = ''
      if ! command -v brew >/dev/null 2>&1; then
        echo "brew not found; install Homebrew or run this task on a Homebrew host"
        exit 1
      fi

      for formula in Formula/*.rb; do
        brew test "$formula"
      done
    '';

    "tap:validate".exec = ''
      devenv tasks run tap:syntax

      if command -v brew >/dev/null 2>&1; then
        devenv tasks run tap:audit
        devenv tasks run tap:brew-test
      else
        echo "brew not found; skipped brew audit/test"
      fi
    '';
  };

  enterTest = ''
    devenv tasks run tap:validate
  '';
}
