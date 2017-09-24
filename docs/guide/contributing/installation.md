# Installing Nylas-Mail
### Note:
If you are looking to simply install Nylas-Mail on your system (and are not looking to debug or contribute) please use one of the normal packages or installers.

## Linux -- Debain/Ubuntu
1. Install the necessary dependincies
    ```bash
    sudo apt install build-essential clang fakeroot g++-4.8 git libgnome-keyring-dev xvfb rpm libxext-dev libxtst-dev libxkbfile-dev
    ```
1. Set the following environment variables with export:
    ```bash
    export NODE_VERSION=6.9 CC=gcc-4.8 CXX=g++-4.8 DEBUG="electron-packager:*" INSTALL_TARGET=client
    ```
1. [Follow the common instructions](#common)

## Mac OS
1. Download the latest XCode from the App Store then run the following to install CLI tools
    ```bash
    xcode-select --install
    ```
1. [Follow the common instructions](#common)

## Windows
1. Download and install Visual Studio 2013. The Community Edition works and is free with a Dev Essentials account; once you have a Dev Essentials account, you can access a download at https://my.visualstudio.com/Downloads?q=Visual%20Studio%202013%20with%20Update%205
1. Due to the way Windows filesystem is built, it is likely you'll need to run Command Prompt as administrator. We have seen issues with rename/symlink permissions.
1. Set the following environment variables:
    ```bash
    set NODE_VERSION=6.9
    set DEBUG=electron-windows-installer:*,electron-packager:*
    set SIGN_BUILD=false
    set INSTALL_TARGET=client

    set npm_config_arch=x64
    set npm_config_target_arch=x64
    set npm_config_msvs_version=2013

    npm config set arch x64
    npm config set target_arch x64
    npm config set msvs_version 2013
    ```
1. [Follow the common instructions; please follow for **Windows Developers Only** notes](#common)

## Common
1. Install Node.js version **6.9** (suggested using [NVM](https://github.com/creationix/nvm/blob/master/README.md#install-script) or the Windows version of [NVM Windows](https://github.com/coreybutler/nvm-windows/releases))
    * If using nvm, prepend all the coming `npm` commands with the following to use the correct NPM version:
    ```bash
    nvm exec 6.9
    ```
1. Clone this repo using git.
    ```bash
    git clone our-repo-link
    ```
   * The repo link can be found on the main page of this repository, simply click the green "Clone or download button", and copy its contents over the "our-repo-link" in the above command.
   * **Windows Devleopers Only**: Windows has issues with long paths. It is recommended that this repo is cloned to the root directory of a disk drive (not necessarily C:):
     ```bash
     git clone out-repo-link C:\nylas-mail
     ```
1. Install the necessary node packages using:
    ```bash
    npm install
    ```
1. If all packages installed without errors, you can run the app with:
    ```bash
    npm start
    ```
    * If an error was thrown during the build process, please make sure all of your dependencies were installed in step 2.
    
1. Furthermore, if all dependencies were installed successfully, you can the package the app for distribution on various platforms with:
    ```bash
    npm run build-client
    ```
    * If the above command threw an error, run the following and make sure your **node version is 6.9**:
      ```bash
      node -v
      ```
    * **Windows developers Only**: This step is required for Windows. However, to create an installer binary, you must execute another command:
      ```bash
      node packages\client-app\build\create-signed-windows-installer.js
      ```