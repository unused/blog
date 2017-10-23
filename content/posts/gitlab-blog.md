---
title: "Create an awesome gitlab blog from zero to 💯"
date: 2017-10-21T20:57:11+02:00
---

**TL;DR** Lets create a blog powered by [hugo static site generator][hugo] hosted on
[gitlab pages][gitlab-pages] with a custom HTTPS domain registered at
[zeit.co][zeit] and [letsencrypt] for free.

[skip to action](#build-a-blog)

## Some Details

As christmas present on 24th of December 2016 GitLab brought a new feature
called GitLab pages to the community edition. This features offers to use
static files and serve them by using a golang webserver. To trigger an update
one enables the GitLab continuous integration using a `.gitlab-ci.yml` file
inside a git repository containing a recipe that will result in collecting
certain assets, so called artefacts, in a pipeline conventionally named
"pages". The corresponding website can afterwards be found at
`https://<username-or-namespace>.gitlab.io/<project>/`. A custom domain for this
website can be easily configured in the settings. If none is available zeit.co
is a pretty nice and nerdy host, offering an API that can be controlled using
an official JavaScript CLI tool called `now`. With `now` we can quickly
register a new domain - that costs about **15$** for a *.com* domain - and
further create a HTTPS certificate for free using let's encrypt.

## Build a Blog

*The following gives a brief step-to-step tutorial, if something is not working
as expected [please leave me a message][issues].*

- Create a new project on [GitLab][gitlab].
- [Install hugo][hugo-install] if you've not done so yet. It might be already
  available on your linux machines package management, check `dnf install
  hugo`, `apt-get install hugo`, `apk install hugo`, download the executeables
  directly, build the gocode or use one of the many available docker container.
  Mine is at `docker.io/unused/hugo`.
- Start a new site using `hugo new site blog`.
- Download any [theme][hugo-themes] and extracted it into the themes folder -
  as a reference you can use the [minimo-hugo-theme][minimo-hugo-theme]. Adapt
  the `config.toml` file, set a minimum of configuration: theme to minimo and
  adapt the baseURL.  You can find the projects pages url on GitLab in the
  project settings in the pages section.
- Init and update a local git repository with `git init && git ci -am "No time
  for proper git usage..."`. Please use a more appropriate message. Don't
  headstart with a bad history. Afterwards push the project to GitLab via `git
  push origin master`.
- One step away to finally activate your pages for the first time. Create a new
  file `.gitlab-ci.yml` using the GitLab web UI, then choose the predefined
  auto-template for `hugo`.  Unfortunately the docker image used in the
  gitlab-ci recipe template did not match the template requirements for me, the
  hugo version was outdated. On demand feel free to use [my hugo
  image][docker-hugo] and replace the images used in the `.gitlab-ci.yml` with
  `unused/hugo`. *Let me know if it is out of date again.*
- If you want to register your domain at zeit.co, go there, create an account,
  log in and add your payment details. Afterwards get the CLI tool using
  `npm i -g now` or use yarn if you prefer it.
- Execute `now domain buy DOMAIN.com` to buy a new domain.
- Execute `now dns add DOMAIN.com @ A 52.167.214.135` to point your domain on
  the official GitLab public IP address. If you setup the domain now in the
  gitlab project settings, your website will already be available on the HTTP
  version of your address.
- Finally create a certificate for the domain with the letsencrypt auto tool,
  first `git clone https://github.com/letsencrypt/letsencrypt`, then execute
  `./letsencrypt-auto certonly -a manual -d DOMAIN.com` and follow the
  instructions. You will be asked to create a file on your webhost. Simply
  create the file with described content in the `static/` directory of your
  hugo repository and push it. It should be available as soon as the pipeline
  is processed successfully - check the jobs section of your GitLab project.
- As last step update the GitLab project settings, remove the domain and create
  a new one now using the *fullchain.pem* and *private.pem* keys in your
  configuration. Have fun!

[docker-hugo]: https://hub.docker.com/r/unused/hugo/ "Hugo Docker Image"
[gitlab-pages]: https://about.gitlab.com/features/pages/ "GitLab Pages"
[gitlab]: https://gitlab.com/ "GitLab Pages"
[hugo-install]: https://gohugo.io/getting-started/installing/ "Hugo Install"
[hugo-themes]: https://themes.gohugo.io/ "Hugo Themes"
[hugo]: https://gohugo.io/ "Hugo open-source static site generator"
[issues]: https://github.com/unused/blog/issues "Unused Blog Issues"
[letsencrypt]: https://letsencrypt.org/ "Let's Encrypt CA"
[minimo-hugo-theme]: https://themes.gohugo.io/minimo/ "Minimo Hugo Theme"
[zeit]: https://zeit.co/ "Serverless Hosting Platform"
