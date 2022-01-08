# Oraksil (추억의 오락실)

https://user-images.githubusercontent.com/2357381/148651036-8b7c5674-0c08-4e5e-aec7-29fe5b40c72f.mp4

_Captured by [Kropsaurus](https://kropsaurus.pineple.com/)_

## Give it a try

### Prerequisite

- Docker (with `docker-compose`)
- [MAME](https://github.com/mamedev/mame) Game ROMs
    - It's recommended that you get the game roms yourself due to some license issue.
    - The ROMs should be compatible to [MAME 0.223](https://github.com/mamedev/mame/releases/tag/mame0223)
    - Place ROM files under `./roms`

### Run
```
$ docker-compose up
```

If you'd like to play the specific game, use environment variable `GAME` by setting rom(zip) file name. For example, if you have `./roms/bublbobl.zip`
```
$ GAME=bublbobl docker-compose up
```

## Troubleshoot
- If you are stuck at creating a player on the modal form, please try to clear cookies and try again.
