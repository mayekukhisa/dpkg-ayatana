# Dpkg-ayatana

Dpkg-ayatana is a command-line tool for installing Debian packages (\*.deb files) that depend on the deprecated [libappindicator][1] package.

## Features

-  Install multiple packages.
-  Rebuild packages that depend on libappindicator to use [libayatana-appindicator][2].

## Getting started

This guide shows how to obtain a copy of the project and get the tool running on your local machine.

### System requirement

This project depends on the command-line tool below being available in your environment:

-  `bash`

### Downloading the codebase

[Fork this repo][3] on GitHub and clone your fork. Alternatively, you can [download this repo][4] as a zip file and extract it.

### Running the tool

1. Navigate into the project's bin directory.
2. Execute the command below to see usage info:

   ```shell
   ./dpkg-ayatana.sh --help
   ```

## Author

Mayeku Khisa - _Maintainer_ - [@mayekukhisa][5].

## License

Dpkg-ayatana is available under the [MIT License][6]. Copyright &copy; 2022 Mayeku Khisa.

[1]: https://tracker.debian.org/pkg/libappindicator
[2]: https://tracker.debian.org/pkg/libayatana-appindicator
[3]: https://github.com/mayekukhisa/dpkg-ayatana/fork
[4]: https://github.com/mayekukhisa/dpkg-ayatana/archive/refs/heads/main.zip
[5]: https://github.com/mayekukhisa
[6]: LICENSE
