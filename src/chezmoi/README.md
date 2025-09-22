
# chezmoi (dotfiles manager) (chezmoi)

Installs chezmoi and optionally initializes dotfiles for the target user from a git repository.

## Example Usage

```json
"features": {
    "ghcr.io/pirpedro/features/chezmoi:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| repoUrl | Git URL for dotfiles (e.g., https://github.com/user/dots or git@github.com:user/dots.git). Empty = do not init. | string | - |
| branch | Branch to checkout (optional). | string | - |
| apply | Run `chezmoi init --apply` if repoUrl is set. | boolean | true |
| useLoginShell | Execute init/apply in a login shell for the target user (safer PATH/XDG). | boolean | true |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/pirpedro/features/blob/main/src/chezmoi/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
