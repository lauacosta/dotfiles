
# dotfiles
Este repositorio contiene las aplicaciones y la configuracion que uso en mi maquina. Utilizo [`chezmoi`](https://github.com/twpayne/chezmoi). Hasta ahora esta configurada unicamente para Ubuntu.

## Instalación:

    export GITHUB_USERNAME=lauacosta
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
