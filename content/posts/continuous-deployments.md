---
title: "Short Words on Continuous Deployments"
date: 2017-08-19T09:40:51+02:00
---

Planning and maintaining continuous integration can be tough. Keep it stable,
handle multiple projects, environments, build scenarios, and in some bad cases
private dependencies. With the following post I'd like to share some experience
from lessons learned when dealing with continuous integrations and deployments
specifically.

TL;DR

  - Build your own test container image.
  - Keep any output.
  - Extend output by environment info.
  - Setup ssh and inject key in before script.
  - Build you own docker deployment image.

Recently a friend asked me on some advise to setup continuous integration
using [gitlab], that's why I'll stick to gitlab for this post, things will be
very similar for any other environment.

Firsty first it does not make sense to install libraries, drivers or tools in a
script when you use containers running your software. Build your own test
image, that's super easy with docker. You can then host it on docker-hub or
even in your own gitlabs registry.

Don't suppress any output when running a job. It will not harm to have lots of
output whereas help you when something goes wrong.

A good practice is that you use a before script to collect some additional
infos about your environment. E.g. output a `ruby --version`,
`python --version`, etc. If some test fails on CI but not on local, you have a
good starting point at comparing those values.

To connect to some remote machine inside your docker instance, simply configure
an SSH client. Same as you would do on any development machine. There's [a
documented way how gitlab recommends to do](gitlab-ci-ssh), that I'd say is the
simplest way of doing. You have to generate some ssh-key, put the public key on
your target machine and put the private one in the gitlab project (or group)
secret variables. For sure this is a deployment access, so it should have its
own user with limited rights on the target. For sure it will make sense to
also build your own deployment image, for several reasons: Keep it small (e.g.
use an alpine image and just add ssh), keep it secure (know exactly what is
executed on this box), keep it fast (smaller is faster), keep it stable (don't
make your deployment fail just because someone updated an image).

[gitlab]: https://about.gitlab.com/
[gitlab-ci-ssh]: https://docs.gitlab.com/ee/ci/ssh_keys/README.html
