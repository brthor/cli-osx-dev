#!/usr/bin/env bash

[ -z "$CLI_CLONE_PATH" ] && CLI_CLONE_PATH="~/code/cli" 

execute()
{
    if ! check_prereqs; then
        exit 1
    fi

    install_necessary_packages
    setup_ubuntu_dev_environment
    setup_docker_machine
    setup_ubuntu_dev_environment
    clone_repo
}

check_prereqs()
{
    local prereqs=("brew" "brew cask")
    local ret=0

    for prereq in "${prereqs[@]}"
    do
        $prereq --version > /dev/null 2> /dev/null
        if [[ "$?" != "0" ]]; then
            echo "$prereq must be installed to continue...."
            ret=1
        fi
    done
    return $ret
}

install_necessary_packages()
{
    local ret=0
    local packages=("docker" "docker-machine" "openssl")
    local applications=("virtualbox")

    for package in "${packages[@]}"
    do
        brew install $package
        if [[ "$?" != "0" ]]; then
            echo "error: $package failed to install..."
            ret=1
        fi
    done

    for app in "${applications[@]}"
    do
        brew cask install $app
        if [[ "$?" != "0" ]]; then
            echo "error: $app failed to install"
            ret=1
        fi
    done
}

setup_docker_machine()
{
    docker-machine create -d virtualbox cli
    eval $(docker-machine env cli)
}

setup_ubuntu_dev_environment()
{
    docker pull brthor/cli-ubuntu-dev

    echo "ubuntu dev shell: docker run -it brthor/cli-ubuntu-dev"
}

clone_repo()
{
    git clone https://github.com/dotnet/cli $CLI_CLONE_PATH
}

execute