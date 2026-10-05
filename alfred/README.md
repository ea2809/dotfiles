# Alfred workflows

## Restart Bluetooth

Use this when a paired keyboard or another Bluetooth device is unavailable or
its Connect action is greyed out.

1. Open Alfred.
2. Type `bt restart`.
3. Press Return.

Bluetooth turns off for two seconds and then turns on again. Connected
Bluetooth devices will briefly disconnect and should reconnect automatically.
Keep the Mac's built-in keyboard/trackpad or a wired input device available in
case a device needs to be paired again.

The workflow includes its restart script and shows an Alfred notification when
the power cycle is complete. The same command can be run through the repository
wrapper from a terminal:

```sh
~/dotfiles/bin/restart-bluetooth
```

### Installation

The script requires `blueutil`, declared in the repository `Brewfile`. Running
`install.sh` installs it through `brew bundle` and links the workflow into
Alfred 5. For a standalone installation of the dependency, run:

```sh
brew install blueutil
```

The installer leaves an existing workflow at the same destination untouched.
To install only the Alfred workflows without running the full setup, run:

```sh
bash ~/dotfiles/scripts/mac/install-alfred-workflows.sh
```

To import or update the workflow manually, zip the contents of
`alfred/restart-bluetooth` as an `.alfredworkflow` file and open it with Alfred.
Because the restart script is bundled, the exported workflow does not depend on
the location of this repository.

### If the device still does not connect

Open System Settings > Bluetooth, turn the keyboard off and on, and try Connect
again. If it remains unavailable, remove and pair the keyboard again. Updating
the keyboard firmware is a separate maintenance step and is not performed by
this workflow.
