{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "yaziPlugins-bookmarks";
  version = "unstable-2025-07-09";

  src = fetchFromGitHub {
    owner = "dedukun";
    repo = "bookmarks.yazi";
    rev = "9ef1254d8afe88aba21cd56a186f4485dd532ab8";
    hash = "sha256-GQFBRB2aQqmmuKZ0BpcCAC4r0JFKqIANZNhUC98SlwY=";
  };

  buildPhase = ''
    mkdir $out
    cp $src/* $out
  '';

  meta = with lib; {
    description =
      "A Yazi plugin that adds the basic functionality of vi-like marks.";
    homepage = "https://github.com/dedukun/bookmarks.yazi";
    license = licenses.free;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
