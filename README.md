# Emily's systems' config

## Installation

### Install on Raspberry Pi Host:

On your system:
TODO: describe how to get the basic SD card flashed

if required: add a new host to `flake.nix` using `defineRpiSystem`. Add any services/applciations you wish to use to the list argument.

Make sure changes are pushed so the RPi can fetch them.

On the Raspberry Pi (you'll need keyboard/monitor for this one-off setup):
- Update bootloader (RPi4/5 only) TODO describe
- TODO: you might want to add a swapfile (10gb swapfile for rpi with 2gb ram -- does this fix the issues???) - without this, 2gb fills and then it crashes!
- switch to the desired host on this flake: (example with Snapdragon host)
```zsh
sudo nixos-rebuild boot --flake 'github:EmilyBoarer/SystemConfigs/optionalcommithashid#Snapdragon'
```
NB: `nixos-rebuild boot` makes it the default boot option, but does not apply until reboot
- reboot

TODO explain more:
command to run for remote building. run this on Orchid, assuming orchid has ssh key on remote's authorized\_files
```zsh
nixos-rebuild --target-host nixos@192.168.1.147 boot --flake '.#Snapdragon'

that nearly, worked, but broke at the final hurdle (could not symlink the system into the bootloader or something along those lines)

nixos-rebuild --target-host nixos@192.168.1.147 boot --use-remote-sudo --flake '.#Snapdragon'

but then reran this, and it didn't seem to do much, but then after a reboot it has taken effect!
```
This requires `boot.binfmt.emulatedSystems = ["aarch64-linux"];` to be set on the building machine, since it is doing cross-platform building

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
