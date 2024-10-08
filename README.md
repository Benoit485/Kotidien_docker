Kotidien
========

Docker compiler / launcher for financial app from :
https://github.com/pantaflex44/kotidien

Tested in GNU/Linux Debian Bookworm

Use pypi libs version last update at 07/10/2024

Build :
```bash
# Use id of user for continue to access data files
cp ./docker-compose.override.example.yml ./docker-compose.override.yml
sed -i "s@PUID: 1000@PUID: $(id -u)@" ./docker-compose.override.yml
sed -i "s@PGID: 1000@PGID: $(id -g)@" ./docker-compose.override.yml
docker compose build
```

Run :
```bash
# Create dir with user for keep id
mkdir -p ./data/{config,data}
docker compose up
```

Shortcut in menu :
```bash
ln -sf "$(pwd)/icon.png" "${HOME}/.local/share/icons/kotidien.png"
sed "s@^Exec=.*\$@Exec=docker compose -f $(pwd)/docker-compose.yml up@" kotidien.desktop.example > ./kotidien.desktop
ln -sf "$(pwd)/kotidien.desktop" "${HOME}/.local/share/applications/kotidien.desktop"
```
