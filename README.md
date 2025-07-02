- # Development-Setup

  A reproducible and performance-optimized Arch Linux environment tailored for development. This project audits your system, compiles key tools from source using all available CPU cores, and sets up a clean, minimal baseline for daily use.

  ------

  ## Purpose

  Setting up Arch from scratch can be time-consuming. This project automates that setup by:

  - Auditing your current system state
  - Installing missing dependencies
  - Compiling select tools from source
  - Applying lightweight configuration defaults

  Ideal for power users who want a fast, repeatable setup process without bloated frameworks.

  ------

  ## Components

  ### `install.sh`

  Top-level entry point. Wraps and executes the full setup sequence:

  1. `inspect/audit-system.sh`
  2. `setup/bootstrap.sh`
  3. `setup/core-utils.sh`

  Can be run standalone to fully provision a new system.

  ------

  ### `inspect/audit-system.sh`

  Performs a full system audit: package manager check, compiler availability, and system inventory logging.

  ------

  ### `setup/bootstrap.sh`

  Installs core packages and ensures the system has the necessary build tools and utilities.

  ------

  ### `setup/core-utils.sh`

  Builds tools from source using `make -j$(nproc)` for maximum performance. Designed for users who prefer compiling from scratch.

  ------

  ### `config/dotfiles/` (optional)

  Contains optional configuration files for shell and editor environments. Can be symlinked or installed based on user preference.

  ------

  ## Getting Started

  Clone the repository and run the installer:

  ```
  bashCopyEditgit clone git@github.com:c1nderscript/Development-Setup.git
  cd Development-Setup
  chmod +x install.sh
  ./install.sh
  ```

  This will audit, install, and compile the environment in a single sequence.

  ------

  ## License

  MIT License

  ------

  ## 
# Development-Setup
