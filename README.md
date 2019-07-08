# Bash-CreateDomain

Simple tool for creating an apache user/group and a home directory in /var/www.

*Note: I use this script for my own projects, it contains only the features I need.*

## Table of Contents

[Installation](#installation) | [Features](#features) | [Test](#test) | [Contributing](#contributing) | [License](#license)

## Installation

Requires: a Debian/Ubuntu version of linux and a Bash version ~4.4. [bash-sys](https://github.com/ojullien/bash-sys) installed.

1. [Download a release](https://github.com/ojullien/bash-createdomain/releases) or clone this repository.
2. Use [scripts/install.sh](scripts/install.sh) to automatically install the application in the /opt/oju/bash project folder.
3. If needed, add `PATH="$PATH:/opt/oju/bash/bin"` to the .profile files.

## Features

This tool allows you to create an apache user/group and a home directory in /var/www.

```bash
Usage: createdomain.sh [options] <domain 1> [domain 2 ...]

<domain 1>  User, group and domain name to create.

options
  -h | --help           Show this help.
  -l | --active-log     Log mode. Content outputs are logged in a file.
  -n | --no-display     Display mode. Nothing is displayed in terminal.
  -t | --trace          Display var and constants.
  -v | --version        Show the version.
  -w | --wait           Wait user. Wait for user input between actions.
```

## Test

I didn't write any line of 'unit test' code. Sorry.

## Contributing

Thanks you for taking the time to contribute. Please fork the repository and make changes as you'd like.

As I use these scripts for my own projects, they contain only the features I need. But If you have any ideas, just open an [issue](https://github.com/ojullien/bash-createdomain/issues/new/choose) and tell me what you think. Pull requests are also warmly welcome.

If you encounter any **bugs**, please open an [issue](https://github.com/ojullien/bash-createdomain/issues/new/choose).

Be sure to include a title and clear description,as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## License

This project is open-source and is licensed under the [MIT License](LICENSE).
