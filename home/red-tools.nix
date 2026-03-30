# home/red-tools.nix — Tools for RED (Redacted.sh) music uploads.
#
# Imported only by machines/liquidark.nix.
#
# Scripts (eac-to-flac, flac-to-mp3, mktorrent-wrap) live in ~/code/red-tools
# and are added to PATH when that directory is present.
#
# Provides:
#   - beets with MusicBrainz auto-tagging (used by eac-to-flac)
#   - python3 with mutagen (used by flac-to-mp3 for ID3v2.4 tag copying)
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python with mutagen for ID3v2.4 tag copying in flac-to-mp3.
    # This python3 takes precedence over the pacman one on PATH.
    (python3.withPackages (ps: [ ps.mutagen ]))
  ];

  programs.beets = {
    enable = true;
    settings = {
      import = {
        move  = false;
        copy  = false;
        write = true;
        # timid requires confirmation even for high-confidence matches —
        # important for private tracker accuracy.
        timid = true;
      };
      plugins = [ "fetchart" "embedart" ];
      fetchart.auto = true;
      embedart.auto = true;
    };
  };

  # Add red-tools scripts to PATH when the repo is checked out locally.
  programs.zsh.initContent = ''
    [[ -d ~/code/red-tools ]] && path=("$HOME/code/red-tools" $path)
  '';
}
