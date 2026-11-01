{pkgs, ...}: let
  freecadMcpSrc = pkgs.fetchFromGitHub {
    owner = "neka-nat";
    repo = "freecad-mcp";
    rev = "8babe9927ce8e6e8fe7dd6ae2ffa2c93776e845a";
    hash = "sha256-dryocwUb26S1+msUTZDUYGoyizxKuAeqMiTqyD8/ybo=";
  };

  freecadMcp = pkgs.writeShellApplication {
    name = "freecad-mcp";
    runtimeInputs = [pkgs.uv];
    text = ''
      exec uvx --from ${freecadMcpSrc} freecad-mcp "$@"
    '';
  };
in {
  home.packages = [freecadMcp];

  # FreeCAD 1.1 discovers user workbenches from this versioned Mod directory.
  home.file.".local/share/FreeCAD/v1-1/Mod/FreeCADMCP".source =
    "${freecadMcpSrc}/addon/FreeCADMCP";
}
