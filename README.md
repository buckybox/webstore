# Bucky Box Web Store

[![Build Status](https://travis-ci.org/buckybox/webstore.svg?branch=master)](https://travis-ci.org/buckybox/webstore)
[![Code Climate](https://codeclimate.com/github/buckybox/webstore/badges/gpa.svg)](https://codeclimate.com/github/buckybox/webstore)
[![Dependency Status](https://gemnasium.com/buckybox/webstore.svg)](https://gemnasium.com/buckybox/webstore)
[![Coverage Status](https://coveralls.io/repos/buckybox/webstore/badge.svg?branch=master&service=github)](https://coveralls.io/github/buckybox/webstore?branch=master)
[![PullReview stats](https://www.pullreview.com/github/buckybox/webstore/badges/master.svg?)](https://www.pullreview.com/github/buckybox/webstore/reviews/master)
[![security](https://hakiri.io/github/buckybox/webstore/master.svg)](https://hakiri.io/github/buckybox/webstore/master)

Bucky Box Web Store is an extraction from the [Bucky Box](http://www.buckybox.com/) platform.
It allows customers to place orders and communicates with the [Bucky Box API](https://api.buckybox.com/docs/).

![Screenshot](doc/screenshot.jpg)

## Configuration

See [config/application.yml](https://github.com/buckybox/webstore/blob/master/config/application.yml.example).
The required settings are `BUCKYBOX_API_KEY`, `BUCKYBOX_API_SECRET` and `SECRET_KEY_BASE`. You can leave the rest blank.

## Services

You must have [Redis](http://redis.io/) running - it is used for transient data.

## Deployment instructions

```bash
cp config/application.yml.example config/application.yml
foreman start
```

## Contributing

Any bug fix or tweak is welcomed but if you have bigger plans, please drop us a line at `support AT buckybox.com` first.

## Translation

You can help translate it into your favorite language. We use [Transifex](https://www.transifex.com/projects/p/buckybox-webstore/).

New translations can be fetched with `tx pull -af`.

## License

GPLv3+

