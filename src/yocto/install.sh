#!/usr/bin/env bash

set -e

# Map release to a version number
declare -A release_version_map
release_version_map[scarthgap]=4.4
release_version_map[nanbield]=4.3
release_version_map[mickledore]=4.2
release_version_map[langdale]=4.1
release_version_map[kirkstone]=4.0
release_version_map[honister]=3.4
release_version_map[hardknott]=3.3
release_version_map[gatesgarth]=3.2
release_version_map[dunfell]=3.1
release_version_map[zeus]=3.0
# I'm not bothering with pre-3.0 releases

# Map release version
if [[ ${release} =~ [0-9]+\.[0-9]+ ]] ; then
    # TODO: strip patch release if specified
    release_version=${RELEASE}
else
    release_version=${release_version_map[${RELEASE,,}]}
fi

if [[ -z "${release_version} "]] ; then
    echo "Unrecognized Yocto release ${RELEASE}"
    exit 1
fi

echo "Selected Yocto release version number is: ${release_version}"

# Clean up
rm -rf /var/lib/apt/lists/*

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi


# Debian / Ubuntu packages
install_debian_packages() {
    # Ensure apt is in non-interactive to avoid prompts
    export DEBIAN_FRONTEND=noninteractive

    local package_list="gawk \
        wget \
        git-core \
        subversion \
        diffstat \
        unzip \
        sysstat \
        texinfo \
        build-essential \
        chrpath \
        socat \
        python3 \
        python3-pip \
        python3-pexpect \
        xz-utils  \
        locales \
        cpio \
        screen \
        tmux \
        sudo \
        iputils-ping \
        python3-git \
        python3-jinja2 \
        python3-distutils \
        iproute2 \
        zstd \
        file \
        gcc-multilib \
        g++-multilib"


    # Include lz4 if available
    if [[ ! -z $(apt-cache --names-only search ^lz4$) ]]; then
        package_list="${package_list} lz4"
    fi

    # Get pylint, depending on base version
    # Old base images need pylint3
    if [[ ! -z $(apt-cache --names-only search ^pylint3$) ]]; then
        package_list="${package_list} pylint3"
    else
        package_list="${package_list} pylint"
    fi

    # If we're targeting an old version, install python2
    if (( $(echo 3.1  ${release_version} | awk '{if ($1 > $2) print 1;}') )); then
        if [[ ! -z $(apt-cache --names-only search ^python2$) ]]; then
            package_list="${package_list} python2"
        else
            package_list="${package_list} python"
        fi
    fi

    # Install the list of packages
    echo "Packages to verify are installed: ${package_list}"
    rm -rf /var/lib/apt/lists/*
    apt-get update -y
    apt-get -y install --no-install-recommends ${package_list} 2> >( grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2 )

    # Clean up
    apt-get -y clean
    rm -rf /var/lib/apt/lists/*
}


export DEBIAN_FRONTEND=noninteractive

# Install the requisite packages
. /etc/os-release
# Get an adjusted ID independent of distro variants
if [ "${ID}" = "debian" ] || [ "${ID_LIKE}" = "debian" ]; then
    ADJUSTED_ID="debian"
#elif [[ "${ID}" = "rhel" || "${ID}" = "fedora" || "${ID}" = "mariner" || "${ID_LIKE}" = *"rhel"* || "${ID_LIKE}" = *"fedora"* || "${ID_LIKE}" = *"mariner"* ]]; then
#    ADJUSTED_ID="rhel"
#elif [ "${ID}" = "alpine" ]; then
#    ADJUSTED_ID="alpine"
else
    echo "Linux distro ${ID} not supported."
    exit 1
fi

# Install packages for appropriate OS
if [ "${PACKAGES_ALREADY_INSTALLED}" != "true" ]; then
    case "${ADJUSTED_ID}" in
        "debian")
            install_debian_packages
            ;;
        "rhel")
            install_redhat_packages
            ;;
        "alpine")
            install_alpine_packages
            ;;
    esac
    PACKAGES_ALREADY_INSTALLED="true"
fi

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"
