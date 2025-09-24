# 🚀 Development Environment Features

> A curated collection of high-quality [dev container Features](https://containers.dev/implementors/features/) designed to enhance your development workflow. These features provide seamless integration of essential development tools into your containerized environments.

## ✨ Features Overview

This repository contains a collection of **4 specialized Features** that work together to create a powerful development environment. Each feature is designed with best practices, proper error handling, and cross-platform compatibility.

### 🐚 `antidote` - Supercharged Zsh with Plugin Management

Transform your shell experience with Antidote, a fast and modern Zsh plugin manager that provides autosuggestions, syntax highlighting, and enhanced completions out of the box.

**What it includes:**

- 🚀 **Antidote plugin manager** - Fast, static bundle generation for optimal performance
- 💡 **Smart autosuggestions** - Fish-like command suggestions as you type
- 🎨 **Syntax highlighting** - Real-time command validation and colorization
- 📚 **Enhanced completions** - Rich tab completions for better productivity
- 📂 **Directory jumping** - Quick navigation with `z` command
- ⚙️ **Optimized configuration** - Sensible defaults for history and shell behavior

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/pirpedro/features/antidote:1": {
      "setAsDefaultShell": true
    }
  }
}
```

**Dependencies:** Requires `common-utils` (with zsh) and `git` features.

### 📁 `chezmoi` - Dotfiles Management Made Easy

Seamlessly manage your dotfiles across different environments with chezmoi, ensuring consistent development setups everywhere.

**What it provides:**

- 🔧 **Automated dotfiles sync** - Initialize from any Git repository
- 🌿 **Branch support** - Use specific branches for different environments
- ⚡ **One-command setup** - Automatic init and apply functionality
- 🛡️ **Safe execution** - Runs in proper user context with secure PATH handling
- 🏠 **Cross-platform** - Works on Alpine, Ubuntu, Debian, and more

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/pirpedro/features/chezmoi:1": {
      "repoUrl": "https://github.com/yourusername/dotfiles",
      "branch": "main",
      "apply": true,
      "useLoginShell": true
    }
  }
}
```

**Quick setup without repository:**

```jsonc
{
  "features": {
    "ghcr.io/pirpedro/features/chezmoi:1": {}
  }
}
```

**Dependencies:** Requires `common-utils` and `git` features.

### 🔧 `dev-gadgets` - Enhanced Git Workflow Tools

Essential Git utilities and SSH client setup for seamless repository management and secure connections.

**What it includes:**

- 🔐 **SSH client** - Properly configured for Git over SSH
- 📁 **SSH directory setup** - Secure ~/.ssh with correct permissions
- 🌍 **Cross-platform support** - Works on Alpine, Debian/Ubuntu, and RHEL-based systems
- ⚡ **Automatic detection** - Smart OS detection with fallback mechanisms

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/pirpedro/features/dev-gadgets:1": {}
  }
}
```

**Dependencies:** Requires `common-utils` and `git` features.

## 🏗️ Complete Development Setup

For the ultimate development environment, combine all features:

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {
      "installZsh": true,
      "username": "vscode",
      "userUid": "1000",
      "userGid": "1000"
    },
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/pirpedro/features/dev-gadgets:1": {},
    "ghcr.io/pirpedro/features/chezmoi:1": {
      "repoUrl": "https://github.com/yourusername/dotfiles",
      "apply": true
    },
    "ghcr.io/pirpedro/features/antidote:1": {
      "setAsDefaultShell": true
    }
  }
}
```

This setup provides:

- ✅ Modern Zsh with plugins and enhancements
- ✅ Automated dotfiles management
- ✅ Enhanced Git workflow tools
- ✅ Secure SSH configuration
- ✅ Optimized shell experience

## 📁 Repository Structure

This repository follows the standard [dev container Features distribution specification](https://containers.dev/implementors/features-distribution/). Each Feature is self-contained in its own directory with proper configuration and installation scripts.

```
├── src/
│   ├── antidote/              # Zsh plugin manager
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
│   ├── chezmoi/               # Dotfiles management
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
│   ├── dev-gadgets/           # Git workflow enhancements
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
├── test/                      # Feature testing
│   ├── antidote/
│   ├── chezmoi/
│   └── dev-gadgets/
└── .github/workflows/         # CI/CD automation
    └── release.yaml
```

### 🔧 Feature Development

Each feature includes:

- **📋 Configuration** - `devcontainer-feature.json` with options and metadata
- **⚙️ Installation** - `install.sh` with cross-platform support and error handling
- **🧪 Tests** - Comprehensive testing across multiple Linux distributions
- **📖 Documentation** - Clear usage examples and option descriptions

### 🚀 Key Design Principles

- **🔗 Dependency Management** - Proper `installsAfter` declarations
- **🛡️ Error Handling** - Graceful failures with helpful error messages
- **🌍 Cross-Platform** - Support for Alpine, Ubuntu, Debian, and RHEL-based systems
- **👤 User Safety** - Proper user context and permission handling
- **⚡ Performance** - Optimized installations and static configurations

### Options

All available options for a Feature should be declared in the `devcontainer-feature.json`. The syntax for the `options` property can be found in the [devcontainer Feature json properties reference](https://containers.dev/implementors/features/#devcontainer-feature-json-properties).

For example, the `color` feature provides an enum of three possible options (`red`, `gold`, `green`). If no option is provided in a user's `devcontainer.json`, the value is set to "red".

```jsonc
{
  // ...
  "options": {
    "favorite": {
      "type": "string",
      "enum": ["red", "gold", "green"],
      "default": "red",
      "description": "Choose your favorite color."
    }
  }
}
```

Options are exported as Feature-scoped environment variables. The option name is captialized and sanitized according to [option resolution](https://containers.dev/implementors/features/#option-resolution).

```bash
#!/bin/bash

echo "Activating feature 'color'"
echo "The provided favorite color is: ${FAVORITE}"

...
```

## 📦 Using These Features

### 🌐 Public Registry

Features are automatically published to GitHub Container Registry (GHCR) and can be referenced in your `devcontainer.json`:

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/pirpedro/features/antidote:1": {},
    "ghcr.io/pirpedro/features/chezmoi:1": {},
    "ghcr.io/pirpedro/features/dev-gadgets:1": {}
  }
}
```

### 📋 Feature Reference

| Feature       | Description         | Key Benefits                                     |
| ------------- | ------------------- | ------------------------------------------------ |
| `antidote`    | Zsh plugin manager  | Fast shell, autosuggestions, syntax highlighting |
| `chezmoi`     | Dotfiles management | Consistent dev environments, automated setup     |
| `dev-gadgets` | Git workflow tools  | SSH support, enhanced Git functionality          |

### 🔄 Versioning & Updates

Features follow [semantic versioning](https://semver.org/). Pin to major versions for stability:

```jsonc
{
  "features": {
    "ghcr.io/pirpedro/features/antidote:1": {}, // Stable
    "ghcr.io/pirpedro/features/antidote:1.2": {}, // Specific minor
    "ghcr.io/pirpedro/features/antidote:1.2.3": {} // Exact version
  }
}
```

## 🧪 Development & Testing

### Running Tests

Test your features locally using the dev container CLI:

```bash
# Test individual features
devcontainer features test --features antidote
devcontainer features test --features chezmoi
devcontainer features test --features dev-gadgets

# Test with scenarios (includes dependencies)
devcontainer features test --features antidote --skip-autogenerated
```

### 🛠️ Contributing

1. **Fork** this repository
2. **Create** a feature branch: `git checkout -b feature/awesome-feature`
3. **Add tests** in `test/your-feature/`
4. **Test locally** with multiple distributions
5. **Submit** a pull request

### 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### 🙏 Acknowledgments

- [Dev Container Features Specification](https://containers.dev/implementors/features/)
- [Antidote Zsh Plugin Manager](https://github.com/mattmc3/antidote)
- [Chezmoi Dotfiles Manager](https://github.com/twpayne/chezmoi)

---

**Made with ❤️ for the dev container community**
