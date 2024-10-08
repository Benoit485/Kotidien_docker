Kotidien
========

Docker compiler / launcher for financial app from :
https://github.com/pantaflex44/kotidien

Tested in GNU/Linux Debian Bookworm

Use pypi libs version last update at 07/10/2024

Build :
```bash
docker compose build
```

Run :
```bash
docker compose up
```

Shortcut in menu :
```bash
ln -sf "$(pwd)/icon.png" "${HOME}/.local/share/icons/kotidien.png"
sed "s@^Exec=.*\$@Exec=docker compose -f $(pwd)/docker-compose.yml up@" kotidien.desktop.example > ./kotidien.desktop
ln -sf "$(pwd)/kotidien.desktop" "${HOME}/.local/share/applications/kotidien.desktop"
```
