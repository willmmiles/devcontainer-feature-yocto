# Yocto dev container feature

This repo provides dev container features to support [Yocto Project](https://www.yoctoproject.org/) embedded Linux development using Visual Studio Code.

Inspired by (and borrowing ideas from) the crops project container images at https://github.com/crops/poky-container and https://github.com/crops/poky-container.

Two features are included:

- "yocto" - installs build tools for supporting Bitbake
- "yocto-sstate" - adds download and sstate cache volumes to build/ , shared among all dev containers

## Usage

```json
"features": {
    "ghcr.io/willmmiles/devcontainer-feature-yocto/yocto:1": {
        "release": "scarthgap"
    },
    "ghcr.io/willmmiles/devcontainer-feature-yocto/yocto-sscache:1": {}
}
```

## Limitations

- Only supports debian based images at the moment
- No testing (yet)

