---
title: "Setup Blocky on MikroTik RouterOS"
date: 2023-07-10T20:24:02+02:00
tags:
  - guide
  - software
  - docker
description: "How to setup Blocky (DNS proxy and ad-blocker written in Go) inside MikroTik RouterOS Containers."
---

Recently I purchased a couple of MikroTik ax^2 to upgrade my network. Here's a short review - pros/cons: stable wifi, small form factor, setup freedom, cheap / harder initial setup - routeros.

Now let's setup Blocky on RouterOS 7.10.1 (latest stable at the time of writing this guide).

Prerequisites:
- Running latest stable RouterOS (>=v7.4 required for containers)
- [Install Container package](https://help.mikrotik.com/docs/display/ROS/Packages) (Upload package to the device (Files inside WinBox) -> Reboot)
- [Enabled Container mode inside RouterOS](https://help.mikrotik.com/docs/display/ROS/Container#Container-EnableContainermode)

RouterOS setup:

```properties
/interface/bridge/add name=containers
/ip/address/add address=172.17.0.1/24 interface=containers
/interface/bridge/port add bridge=containers interface=veth1
/interface/veth/add name=veth1 address=172.17.0.2/24 gateway=172.17.0.1
/ip/firewall/nat/add chain=srcnat action=masquerade src-address=172.17.0.0/24
/container/config/set registry-url=https://registry-1.docker.io tmpdir=docker/temp
/container/add remote-image=spx01/blocky:latest interface=veth1 root-dir=docker/blocky start-on-boot=yes logging=yes
```

You will need to make Blocky configuration file after the image gets pulled from Docker Hub, I've included mine below:

```yml
upstream:
  default:
    - tcp-tls:1.1.1.1:853
    - tcp-tls:1.0.0.1:853

bootstrapDns:
  - tcp+udp:1.1.1.1

connectIPVersion: v4

minTlsServeVersion: 1.3

blocking:
  blackLists:
    ads:
      - https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
      - https://raw.githubusercontent.com/blocklistproject/Lists/master/ads.txt
      - https://raw.githubusercontent.com/blocklistproject/Lists/master/tracking.txt
  clientGroupsBlock:
    default:
      - ads
  blockTTL: 1h
  refreshPeriod: 4h
  downloadTimeout: 2m
  downloadAttempts: 5
  downloadCooldown: 10s

log:
  level: error

ports:
  dns: 6969
```

There's one issue that I've faced when trying to set this up. The image from Docker Hub runs as USER 100 (see Dockerfile in the repo), since you are not root you are not able to bind to any port =<1024 without set capabilities (CAP_NET_BIND_SERVICE). The solution is to run the DNS on a different port. I've used port 6969.

To comment on my config, I use Cloudflare DoT for upstream DNS and just a couple of popular blocklists (less is more). Read the [Blocky documentation](https://0xerr0r.github.io/blocky/v0.21/configuration/), there are a lot of options you can adjust.

Now upload your Blocky config to your Router. 

If you have your SSH port open, you can use scp (CLI) or a SFTP client (FileZilla for example).

`scp config.yml <user>@<router-ip>:/docker/blocky/app/config.yml`

After you've successfully uploaded your config to the router, all you have to do now is to start the container with this command: `/container/start 0` 

*(if you have multiple containers setup, replace 0 with the correct container id - use `/container/print` to figure that out)*

Container is successfully running, but you are not using your Blocky DNS yet, to set this up I use [destination NAT](https://help.mikrotik.com/docs/display/ROS/Container#Container-Forwardportstointernalcontainer) from LAN (bridge-1) port 53 to port 6969, both for UDP and TCP. To start using your Blocky DNS, run these commands. Make sure to replace `<router-ip>` accordingly.

```properties
/ip firewall nat add action=dst-nat chain=dstnat dst-port=53 in-interface=bridge-1 protocol=udp to-addresses=172.17.0.2 to-ports=6969
/ip firewall nat add action=dst-nat chain=dstnat dst-port=53 in-interface=bridge-1 protocol=tcp to-addresses=172.17.0.2 to-ports=6969
/ip dns set servers=<router-ip>
```

Now everything should be setup and ready to use. I've used these websites to verify my setup:

- https://d3ward.github.io/toolz/adblock.html
- https://dnscheck.tools/#results
- https://one.one.one.one/help/

P.S. Happy blocking!