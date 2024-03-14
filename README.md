
# dotfiles
Este repositorio contiene las aplicaciones y la configuracion que uso en mi maquina. Utilizo [`chezmoi`](https://github.com/twpayne/chezmoi).

## Instalación:
Si no tenés instalado chezmoi, usa el siguiente comando:

    export GITHUB_USERNAME=windrnr
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME

Si ya lo tenés instalado:

    export GITHUB_USERNAME=windrnr
    chezmoi init --apply $GITHUB_USERNAME

