# Java Spring Boot Toolkit

A collection of bash scripts to manage a Java Spring Boot project with flyway.

## Description

Uses a lot of maven and flyway commands along with some bash script magic.

## Getting Started

### Dependencies

* bash (recomended: 5.1; minimum required version: 4.2)
    * brew install bash
* mvn (recommended: 3.8.6; minimum required version: 3.6)
    * brew install mvn
* java (11+)
* postgres command line tools
    * brew install libpq


### Configuration

* The configuration should be set in the `_config.sh` module.
* Command line arguments can be used to override the `_config.sh` settings and provide more flexibility

### Executing program

* Ensure you are using bash v4.2 - 5.1.
```
$ bash -v
```

* Run the toolkit
```
$ chmod +x toolkit.sh
$ bash toolkit.sh  or  ./toolkit.sh
```

## Help

* If facing issues with Unicode icons not showing up, check your bash version and trying updating.

## Authors

Contributors names and contact info

ex. Devin TM
ex. [@devintm](https://github.com/devintm)

## Version History

* 0.2
    * Various bug fixes and optimizations
* 0.1
    * Initial Release


## TODO

* Print pom.xml information
```
    [DEBUG]   (f) packaging = jar
    [DEBUG]   (f) pomFile = /Users/dev/repos/java-backend/pom.xml
```

## License

[![License](https://img.shields.io/badge/License-Apache_2.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)  

## Acknowledgments

Inspiration, code snippets, etc.
* [prettytable.sh](https://github.com/jakobwesthoff/prettytable.sh)
* [Bash Colors](https://gist.github.com/allthingscode/801002)

