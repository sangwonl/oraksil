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

If you'd like to play the specific game, use environment variable `GAME` by setting it to rom(zip) file name. For example, if you have `./roms/bublbobl.zip`
```
$ GAME=bublbobl docker-compose up
```

## How it works

### Sytem Architecture

#### Overview

![](./assets/service-architecture.png)

#### [Esekki](https://github.com/oraksil/esekki) (Frontend)

A web application running on a browser. It provides user with games catalog and to play game. Game frames to be rendered and player control data are transfered via WebRTC session. So, any kind of clients can be possible if it supports WebRTC. `Esseki` is built on [Next.js](https://nextjs.org/) using `redux`, `redux-saga` together.

#### [Azumma](https://github.com/oraksil/azumma) (API Server)

`Azumma` is a REST API server that provides player creation, games catalog and WebRTC signaling proxy. In a cluster mode, it's responsible to provision `Orakki` instance on demand. It is built with [Golang](https://go.dev/).

#### [Orakki](https://github.com/oraksil/orakki) (Game Streaming Server)

`Orakki` means an arcade gaming console in Korean. It is a core instance that provides clients with game streaming via WebRTC. It fetches encoded video/audio frames from `Gipan` and sends those packets to client. And it receives player controller input and forwards it to `Gipan`.

`Orakki` instance should be provisioned on demand in a cluster mode. It might need TURN server in some cases where client cannot communicate with server directly. It's built with Golang.

#### [Gipan](https://github.com/oraksil/gipan) (MAME Emulator Driver & Encoder)

`Gipan` means a (green) main board in the game console box. It integrates MAME emulator as a game engine, encodes video/audio frames MAME renders and provides IPC or TCP channels for `Orakki` to fetch the encoded data. (It's the same for player control data) It's built with [Rust](https://www.rust-lang.org/).

### [MAME as a headless lib](https://github.com/oraksil/mame)

[MAME](https://www.mamedev.org/https://en.wikipedia.org/wiki/MAME) is a free and open-source emulator designed to recreate the hardware of arcade game systems in software on modern personal computers and other platforms. It supports over 7,000 unique games.

Since [MAME open source](https://github.com/mamedev/mame) is made for standalone application which has its own GUI, it was needed to modify MAME as a headless library which has no GUI. So, we made some changes to add headless osd interface. If you're interested in it, please refer to [this PR](https://github.com/oraksil/mame/pull/10).

### Encoding game frames

Raw game frames are generated from MAME. There're two types of game frames. One is image frame which is captured at 24fps, another is audio frame which is captured at 48,000 sampling rates for two channels. `libmame` provides those frames to `Gipan` via callback functions.

The, `Gipan` encodes video frame with H.264 (using `libx264`) and audio frame with OPUS (using `libopus`) respectively. When it comes to game streaming, it's especially important to transmit video frames in low latency so that user doesn't feel some lags. So, we've used [encoding parameters for `ultrafast` preset](https://dev.beandog.org/x264_preset_reference.html).


### WebRTC Signaling

WebRTC signaling is divided into two stages. The first stage is exchanging offer/answer by [SDP(Session Description Protocol)](https://datatracker.ietf.org/doc/html/rfc4566), the second one is exchanging connection info between peers by [ICE(Interactive Connectivity Establishment)](https://datatracker.ietf.org/doc/html/rfc5245).

Server side peer `Orakki` can be provisioned or removed on request. So, from a scalability point of view, we decided that it would be better to put it on the backend without exposing to public network directly. If so, the problem is that `Orakki` on the backend cannot exchange SDP/ICE data directly with client, but this can be solved by Message Queue such as [`RabbitMQ`](https://www.rabbitmq.com/) and `Azumma` proxying signaling.

#### Media Offer/Answer Exchange (SDP)

![](./assets/sig-sdp.png)

#### Peer Connection Info Exchange (ICE)

![](./assets/sig-ice.png)

## Troubleshoot
- If you are stuck at creating a player on the modal form, please try to clear cookies and try again.

## Contributors
- [@onejae](https://github.com/onejae)
