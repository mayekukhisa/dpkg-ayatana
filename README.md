# Dpkg-ayatana

Dpkg-ayatana is a command-line tool for installing Debian packages (\*.deb files) that depend on the deprecated [libappindicator][1] package.

## Features

-  Install multiple packages.
-  Rebuild packages that depend on libappindicator to use [libayatana-appindicator][2].

## Getting started

This guide shows how to install the tool on your local machine.

### System requirement

Dpkg-ayatana depends on the command-line tool below being available in your environment:

-  `bash`

### Installation

To get Dpkg-ayatana, run the installation script as shown below:

```shell
curl -sS -- "https://raw.githubusercontent.com/mayekukhisa/dpkg-ayatana/main/installer.sh" | sudo bash
```

## Author

Mayeku Khisa - _Maintainer_ - [@mayekukhisa][3].

## License

Dpkg-ayatana is available under the [MIT License][4]. Copyright &copy; 2022] Mayeku Khisa.

[1]: https://tracker.debian.org/pkg/libappindicator
[2]: https://tracker.debian.org/pkg/libayatana-appindicator
[3]: https://github.com/mayekukhisa
[4]: LICENSE
