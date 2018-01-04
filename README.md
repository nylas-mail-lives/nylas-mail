# Nylas Mail - the open-source, extensible mail client

![N1 Screenshot](https://www.nylas.com/hs-fs/hubfs/%20Nylas%20May%202017%20/Images/hero_graphic_mac@2x.png?t=1496457553218&width=1572&name=hero_graphic_mac@2x.png)

**Nylas Mail is an open-source mail client built on the modern web with [Electron](https://github.com/atom/electron), [React](https://facebook.github.io/react/), and [Flux](https://facebook.github.io/flux/).**

It is designed to be extensible, so it's easy to create new experiences and workflows around email.

Want to learn more? Check out the [full documentation](https://nylas.github.io/nylas-mail).

[Join us on Slack!](https://join.slack.com/nylasisalive/shared_invite/MjAzMDE1NTU0MDM2LTE0OTgyNzM3MTItODY4OWNlNTdkMw)

## Download Nylas Mail Lives

You can download the latest release of Nylas Mail Lives [here](https://github.com/nylas-mail-lives/nylas-mail/releases/latest).

⚠️ Please note that these releases currently have no update functionality. In order to get bug fixes and new features you will need to manually reinstall the package from the above link.

To our Arch Linux friends, a community member has generously created an [AUR package](https://aur.archlinux.org/packages/nylas-mail-lives-bin).

## This is a Fork

This is a fork from the project currently hosted at [nylas/nylas-mail](https://github.com/nylas/nylas-mail). A bunch of developers who really liked this open source project got upset on [this issue thread](https://github.com/nylas/nylas-mail/issues/3564) and wondered if they could contribute to the project, as the main development team had stopped to look into issues and pull requests from the community.

Our main objective is to maintain this amazing project alive and actively accepting contributions from the community. We believe this is the true life behind any open source endeavour.

We are still figuring out how to manage this fork, our relationship with the original repository maintainers, how to deploy and etc. We welcome contributions of all kinds as we try to get the house in order.

We will, naturally, honor the licenses as they were written by Nylas on the original project.

Please, feel free to contact any of the developers or, preferably, use our Slack team linked above to look into the discussions.

## Build A Plugin

1. Install Node 6+ via NodeSource (trusted):
  1. `curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -`
  1. `sudo apt-get install -y nodejs`
1. Install Redis locally `sudo apt-get install -y redis-server redis-tools`
benefit of letting us use subdomains.
1. `npm install`

## Running Nylas Mail

1. `npm run client`: Starts the app
1. `npm run test-client`: Run the tests
1. `npm run lint-client`: Lint the source (ESLint + Coffeelint + LESSLint)

### Exploring the Source

This repository contains the full source code to the Nylas Mail client and it's backend services. It is divided into the following packages:

1. [**Isomorphic Core**](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/isomorphic-core): Shared code across local client and cloud servers
1. [**Client App**](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app): The main Electron app for Nylas Mail
   mirrored to open source repo.
1. [**Client Sync**](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-sync): The local mailsync engine integreated in Nylas Mail
1. [**Cloud API**](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/cloud-api): The cloud-based auth and metadata APIs for N1
1. [**Cloud Core**](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/cloud-core): Shared code used in all remote cloud services
1. [**Cloud Workers**](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/cloud-workers): Cloud workers for services like send later

See `/packages` for the separate pieces. Each folder in `/packages` is
designed to be its own stand-alone repository. They are all bundled here
for the ease of source control management.

## Digging Deeper

In early 2016, the Nylas Mail team wrote [extensive documentation](https://nylas.github.io/nylas-mail/) for the app that was intended for plugin developers. This documentation lives on GitHub Pages and offers a great overview of the app's architecture and important classes. Here are some good places to get started:

- [Application Architecture](https://nylas.github.io/nylas-mail/guides/Architecture.html)
- [Debugging Nylas Mail](https://nylas.github.io/nylas-mail/guides/Debugging.html)

The team has also given conference talks and published blog posts about the client:

- [ReactEurope: How React & Flux Turn Apps Into Extensible Platforms](https://www.youtube.com/watch?v=Uu4Yz2HmCgE)
- [ForwardJS: Electron, React & Pixel Perfect Experiences](https://www.youtube.com/watch?v=jRPUB-D1Wx0&list=PL7i8CwZBnlf7iUTn2JMVLLWofAhaiK7l3)

- [Blog: Splitting from Atom](https://github.com/nylas/nylas-mail/raw/master/blog-posts/splitting-from-atom.pdf)
- [Blog: Building Plugins for React Apps](https://github.com/nylas/nylas-mail/raw/master/blog-posts/plugins.pdf)
- [Blog: Nylas Mail Build Process](https://github.com/nylas/nylas-mail/raw/master/blog-posts/build-process.pdf)
- [Blog: Low level Electron Debugging](https://github.com/nylas/nylas-mail/raw/master/blog-posts/electron-debugging.pdf)
- [Blog: A New Search Parser](https://github.com/nylas/nylas-mail/raw/master/blog-posts/search-parser.pdf)
- [Blog: Developers Guide to Emoji](https://github.com/nylas/nylas-mail/raw/master/blog-posts/emoji.pdf)
- [Blog: Nylas Pro](https://github.com/nylas/nylas-mail/raw/master/blog-posts/nylas-pro.pdf)
- [Blog: Nylas Mail & PGP](https://github.com/nylas/nylas-mail/raw/master/blog-posts/pgp.pdf)
- [Blog: Calendar Events and RRULEs](https://github.com/nylas/nylas-mail/raw/master/blog-posts/rrules.pdf)

## Running the Cloud

When you download and build Nylas Mail from source it runs without its cloud components. The concept of a "Nylas ID" / subscription has been removed, and plugins that require server-side processing are disabled by default. (Plugins like Snooze, Send Later, etc.)

In order to use these plugins and get the full Nylas Mail experience, you need to deploy the backend infrastructure located in the `cloud-*` packages. Deploying these services is challenging because they are implemented as microservices and designed to be run at enterprise scale with Redis, Postgres, etc. Because these backend services must access your email account, it is also important to use security best-practices (at the very least, SSL, encryption at rest, and a partitioned VPC). For more information about building and deploying this part of the stack, check out the [cloud-core README](https://github.com/nylas/nylas-mail/blob/master/packages/cloud-core/README.md).

## Themes

The Nylas Mail user interface is styled using CSS, which means it's easy to modify and extend. Nylas Mail comes stock with a few beautiful themes, and there are many more which have been built by community developers

<p align="center">
    <img width="550" src="http://i.imgur.com/PWQ7NlY.jpg">
</p>

### Bundled Themes

- [Dark](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/ui-dark)
- [Darkside](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/ui-darkside) (designed by [Jamie Wilson](https://github.com/jamiewilson))
- [Less Is More](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/ui-less-is-more) (designed by [Alexander Adkins](https://github.com/P0WW0W))
- [Taiga](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/ui-taiga) (designed by [Noah Buscher](https://github.com/noahbuscher))
- [Ubuntu](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/ui-ubuntu) (designed by [Ahmed Elhanafy](https://github.com/ahmedlhanafy))

### Community Themes

- [Agapanthus](https://github.com/taniadaniela/n1-agapanthus) — Inbox-inspired theme
- [Arc Dark](https://github.com/varlesh/Nylas-Arc-Dark-Theme)
- [Bemind](https://github.com/bemindinteractive/Bemind-N1-Theme)
- [Berend](https://github.com/Frique/N1-Berend)
- [BoraBora](https://github.com/arimai/N1-BoraBora)
- [Darkish](https://github.com/dyrnade/N1-Darkish)
- [DarkSoda](https://github.com/adambullmer/N1-theme-DarkSoda)
- [Dracula](https://github.com/dracula/nylas-n1)
- [ElementaryOS](https://github.com/edipox/elementary-nylas)
- [Express](https://github.com/oeaeee/n1-express)
- [Firefox](https://github.com/darshandsoni/n1-firefox-theme)
- [Gmail](https://github.com/dregitsky/n1-gmail-theme)
- [Honeyduke](https://github.com/arimai/n1-honeyduke)
- [Hull](https://github.com/unity/n1-hull)
- [Ido](https://github.com/edipox/n1-ido) — Polymail-inspired theme
- [Kleinstein](https://github.com/diklein/Kleinstein) — Hide the account list sidebar
- [LevelUp](https://github.com/stolinski/level-up-nylas-n1-theme)
- [Material](https://github.com/jackiehluo/n1-material)
- [Monokai](https://github.com/dcondrey/n1-monokai)
- [MouseEatsCat](https://github.com/MouseEatsCat/MouseEatsCat-N1)
- [Predawn](https://github.com/adambmedia/N1-Predawn)
- [Snow](https://github.com/Wattenberger/N1-snow-theme)
- [Solarized Dark](https://github.com/NSHenry/N1-Solarized-Dark)
- [Stripe](https://github.com/oeaeee/n1-stripe)
- [Sublime Dark](https://github.com/rishabhkesarwani/Nylas-Sublime-Dark-Theme)
- [Sunrise](https://github.com/jackiehluo/n1-sunrise)
- [ToogaBooga](https://github.com/brycedorn/N1-ToogaBooga)

#### Installing Community Themes

1. Download and unzip the repo
2. In Nylas Mail, select `Developer > Install a Package Manually... `
3. Navigate to where you downloaded the theme and select the root folder. The theme is copied into the `~/.nylas-mail` folder for your convenience
4. Select `Change Theme...` from the top level menu, and you'll see the newly installed theme. That's it!

Want to dive in more? Try [creating your own theme](https://github.com/nylas/nylas-mail-theme-starter)!

## Plugin List

We're working on building a plugin index that makes it super easy to add them to Nylas Mail. For now, check out the list below! (Feel free to submit a PR if you build a plugin and want it featured here.)

### Bundled Plugins

Great starting points for creating your own plugins!

- [Translate](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/composer-translate) — Works with 10 languages
- [Quick Replies](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/composer-templates) — Send emails faster with templates
- [Emoji Keyboard](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/composer-emoji) — Insert emoji by typing a colon `:` followed by the name of an emoji symbol
- [GitHub Sidebar Info](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/github-contact-card)
- [View on GitHub](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/message-view-on-github)
- [Personal Level Indicators](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/personal-level-indicators)
- [Phishing Detection](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/phishing-detection)
- [Unsubscribe](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/unsubscribe)
- [Keybase](https://github.com/nylas-mail-lives/nylas-mail/tree/master/packages/client-app/internal_packages/keybase)

#### Community Plugins

Note these are not tested or officially supported by Nylas, but we still think they are really cool!

If you find bugs with them, please open GitHub issues on their individual project pages, not the Nylas Mail (N1) repo page.

Thanks!

- [Avatars](https://github.com/unity/n1-avatars)
- [Events Calendar (WIP)](https://github.com/nerdenough/n1-events-calendar)
- [Evernote](https://github.com/grobgl/n1-evernote)
- [GitHub](https://github.com/ForbesLindesay/N1-GitHub)
- [Jiffy](http://noahbuscher.github.io/N1-Jiffy/) — Insert animated GIFs
- [Mail in Chat (WIP)](https://github.com/yjchen/mail_in_chat)
- [Participants Display](https://github.com/kbruccoleri/nylas-participants-display)
- [Squirt Speed Reader](https://github.com/HarleyKwyn/squirt-reader-N1-plugin/)
- [Todoist](https://github.com/alexfruehwirth/N1TodoistIntegration)
- [Weather](https://github.com/jackiehluo/n1-weather)
- [Website Launcher](https://github.com/adriangrantdotorg/nylas-n1-background-webpage) — Opens a URL in separate window
- [Wunderlist](https://github.com/miguelrs/n1-wunderlist)

When you install packages, they're moved to `~/.nylas-mail/packages`, and Nylas Mail runs apm install on the command line to fetch dependencies listed in the package's package.json

## Feature Requests / Plugin Ideas

Have an idea for a package or a feature you'd love to see in Nylas Mail?

Search for existing [GitHub issues](http://github.com/nylas-mail-lives/nylas-mail/issues) and join the conversation!

## Contributing

If you would like to contribute to the project, but aren't sure where to start, please take a look at the [Guide](docs/guide/README.md#contributing).
