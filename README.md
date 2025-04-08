# Emily's systems' config

## Installation

### Home-manager on existing Ubuntu:
#### 1. Install the Nix package manager:
Following https://nixos.org/download/ for single-user installation of Nix:
```sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon```

Follow the advice given by the output to activate the environment.

NB: Using single-user installation to avoid creating other users. This may be necessary to comply with the existing system that is being home-manager-ified.

To disable needing all the experimental features stuff: (untested)
```
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

#### 2. Initialise Flake
<!-- One-off: run the flake with a selected configuration.
Running the flake will cause it to take effect. This will install home-manager too, which is subsequently used to do everything. -->

<!-- List configurations available: (currently only lists nixos configs, so not super helpful)
```nix --experimental-features 'nix-command flakes' flake show github:EmilyBoarer/nix```

Run the desired flake:
<!-- ```nix --experimental-features 'nix-command flakes' run github:EmilyBoarer/nix#configurationgoeshere``` -->
<!-- ```nix --experimental-features 'nix-command flakes' run --refresh github:EmilyBoarer/nix#homeConfigurations.configurationgoeshere.activationPackage``` -->

<!-- Git clone the source tree, and then replace `github:EmilyBoarer/nix` with `.` or other path to the directory of the flake. -->

Create `~/.config/nix/nix.conf` with contents `experimental-features = nix-command flakes`

`git clone git@github.com:EmilyBoarer/nix.git` into a temp folder
__TODO: naming the repo `nix` was probably a bad idea - re-name to something better!__


```zsh
mkdir ~/.config/home-manager
mv ~/temp_nix/nix/* ~/.config/home-manager
mv ~/temp_nix/nix/.* ~/.config/home-manager
```

Run it manually once. This will install home-manager among other things!
`nix run ~/.config/home-manager`
(assuming that the username has a config defined for it to detect!)


TODO: things are not being sourced correctly!?? why??
manual sourcing: `source .nix-profile/etc/profile.d/nix.sh`
How to make automatic?


#### 3. Ongoing updates:

Once a new source tree for the flake is created (either by git pull or editing):
```home-manager switch```
to cause the new flake to be run and take effect.

To update the flake's versions of everything, run ```nix flake update``` to update `flake.lock` then ```home-manager switch``` to cause that change to take effect. Ideally then commit and push the new `flake.lock` file after doing this!



## Filestructure / Repo Overview

The files are located in `~/.config/home-manager` (or symlinked to that location)

#### `flake.nix`
Toplevel config.

#### `locale.nix`
Global locale, timezone, font, etc.. config:
The most general configs that don't change between any hosts.

#### `home/`
Nix files managed by home-manager

#### `home/cli`
Config for terminal tools etc..
This config is expected to be used on all hosts.

#### `home/gui`
Config for window manager and other graphical tools.
This config is expected to be used on all graphical NixOS hosts.
This config `imports` the `home/cli` config.

#### `home/emily/git.nix`
This config sets up Git for personal use.

#### `home/emily`
`emily` user config, intended to be used on personal & graphical NixOS hosts.
This config `imports` the `home/gui` and `home/emily/git.nix` configs.

#### `home/emily_headless`
TODO: implement when the need arises.
Config for the `emily` user when on a personal & headless host.
This config WILL `imports` the `home/cli` and `home/emily/git.nix` configs.

#### `home/emiboa01/git.nix`
This config sets up Git for work use.

#### `home/emiboa01`
TODO: implement
`emiboa01` user config, intended to be used for work hosts.
This config WILL `imports` the `home/cli` and `home/emiboa01/git.nix` configs

#### `hosts`
Nix files managed by NixOS

#### `hosts/nixos`
General config for all NixOS systems,

#### `hosts/Orchid`
Config specific to Orchid.
This config `imports` from `hosts/nixos`.

# long-term TODOs:
- manage SSH and other keys
