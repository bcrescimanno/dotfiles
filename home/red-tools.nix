# home/red-tools.nix — Tools for RED (Redacted.sh) music uploads.
#
# Imported only by machines/liquidark.nix.
#
# Scripts (eac-to-flac, flac-to-mp3, mktorrent-wrap) live in ~/code/red-tools.
# They are wrapped here so they use a Nix-managed Python with mutagen without
# putting a Nix python3 on PATH (which would shadow the system pacman Python).
#
# Provides:
#   - beets with MusicBrainz auto-tagging (used by eac-to-flac)
#   - wrapped red-tools scripts using python3 with mutagen
{ pkgs, ... }:

let
  redToolsPython = pkgs.python3.withPackages (ps: [ ps.mutagen ]);
  redToolsDir = "$HOME/code/red-tools";
  wrapScript = name: pkgs.writeShellScriptBin name ''
    exec ${redToolsPython}/bin/python3 ${redToolsDir}/${name} "$@"
  '';
in

{
  home.packages = [
    pkgs.chromaprint           # fpcalc binary — required by beets chroma plugin
    (wrapScript "eac-to-flac")
    (wrapScript "flac-to-mp3")
    (wrapScript "mktorrent-wrap")
    (wrapScript "rip-to-library")
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
      plugins = [ "fetchart" "embedart" "chroma" "fromfilename" "musicbrainz" "discogs" ];
      fetchart.auto = true;
      embedart.auto = true;
      # For EAC rips: files are untagged, so acoustic fingerprinting (chroma)
      # is the primary match signal. Loosen thresholds so good fingerprint
      # matches aren't discarded before you even see them.
      match = {
        # Default strong_rec_thresh is 0.04 (distance); raise it slightly so
        # high-confidence chroma hits are auto-recommended.
        strong_rec_thresh = 0.10;
        # Show more candidates so you can pick the right edition/release.
        candidates = 10;
      };
    };
  };

}
