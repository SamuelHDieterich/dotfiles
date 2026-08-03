{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  beads, # bd CLI — the app shells out to it for real (non-demo) data
}:

buildNpmPackage {
  pname = "bead-me-up-scotty";
  version = "0-unstable-2026-07-27";

  src = fetchFromGitHub {
    owner = "brendan-appstart";
    repo = "bead-me-up-scotty";
    rev = "e26e446cba697a522ecceabdeeb11dc99239a071";
    hash = "sha256-NZDins8ZZdbFdTk8MBXbD83Q89INz/ZXWDFc6jKkfNo=";
  };

  npmDepsHash = "sha256-Yr3l6WD1B1sTD3UxiHW5yZUiSNAfyrZpL0nFvBBUZcU=";

  # next/font/google fetches font files from Google over the network at build time,
  # which the sandboxed build has no access to.
  # Drop it in favor of a plain system-font stack instead of vendoring/mocking Google's CDN.
  postPatch = ''
        substituteInPlace app/layout.tsx \
          --replace-fail 'import { Geist, Geist_Mono } from "next/font/google";
    ' "" \
          --replace-fail 'const geistSans = Geist({ variable: "--font-geist-sans", subsets: ["latin"] });
    const geistMono = Geist_Mono({ variable: "--font-geist-mono", subsets: ["latin"] });
    ' "" \
          --replace-fail '`''${geistSans.variable} ''${geistMono.variable} h-full antialiased`' '"h-full antialiased"'

        substituteInPlace app/globals.css \
          --replace-fail '--font-sans: var(--font-geist-sans);' '--font-sans: ui-sans-serif, system-ui, sans-serif;' \
          --replace-fail '--font-mono: var(--font-geist-mono);' '--font-mono: ui-monospace, "Cascadia Code", monospace;' \
          --replace-fail '--font-heading: var(--font-geist-sans);' '--font-heading: ui-sans-serif, system-ui, sans-serif;'
  '';

  env.NEXT_TELEMETRY_DISABLED = "1";

  # The bin launchers require an ordinary (non-standalone) `next build` output
  # plus the full node_modules tree — see bin/bead-me-up-scotty.mjs,
  # which runs `next start` against this package's own .next dir.
  npmBuildScript = "build";

  # `bd` on PATH so real-data mode works without a separate beads install.
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [ beads ]}"
  ];

  meta = {
    description = "Local web UI for the beads (bd) issue tracker — board, epics, dependency graph, drag-and-drop";
    homepage = "https://github.com/brendan-appstart/bead-me-up-scotty";
    license = lib.licenses.mit;
    mainProgram = "scotty";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
