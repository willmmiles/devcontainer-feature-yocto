
# Yocto Embedded Linux (yocto)

Installs the build tool dependencies for bitbake and Yocto Linux development

## Example Usage

```json
"features": {
    "ghcr.io/willmmiles/devcontainer-feature-yocto/yocto:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| release | Target yocto release.  This is used to validate the base image and select appropriate packages.  Version numbers such as 4.3 are also accepted. | string | scarthgap |

## OS Support

This Feature should work on recent versions of Debian/Ubuntu-based distributions with the `apt` package manager installed.

`bash` is required to execute the `install.sh` script.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/willmmiles/devcontainer-feature-yocto/blob/main/src/yocto/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
