# TODO: move this sort of package management for work projects to another flake?

{ pkgs, ... }:
{
  # Enable podman
  home.packages = [ pkgs.podman ];
  xdg.configFile = {
    "containers/policy.json".text = ''
      {
        "default": [
            {
                "type": "insecureAcceptAnything"
            }
        ]
      }'';
    # For dockerfiles that assume that containers come from docker.io.
    "containers/registries.conf".text = "unqualified-search-registries = ['docker.io']";
    };
}
