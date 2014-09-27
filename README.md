# Bucky Box Web Store

[![Build Status](https://travis-ci.org/buckybox/webstore.svg?branch=master)](https://travis-ci.org/buckybox/webstore)
[![Code Climate](https://codeclimate.com/github/buckybox/webstore/badges/gpa.svg)](https://codeclimate.com/github/buckybox/webstore)
[![Dependency Status](https://gemnasium.com/buckybox/webstore.svg)](https://gemnasium.com/buckybox/webstore)

**THIS IS A WORK-IN-PROGESS. You should not use this quite yet. A functional version will be released in a couple of weeks.**

Bucky Box Web Store is an extraction from the [Bucky Box](http://www.buckybox.com/) platform.

![Screenshot](doc/screenshot.jpg)

## Ruby version

See [.travis.yml](https://github.com/buckybox/webstore/blob/master/.travis.yml).

## Configuration

See [config/application.yml](https://github.com/buckybox/webstore/blob/master/config/application.yml).
The required settings are `BUCKYBOX_API_KEY`, `BUCKYBOX_API_SECRET` and `SECRET_KEY_BASE`. You can leave the rest blank.

## Services

You must have [Redis](http://redis.io/) running. It is used as a cache and for transient data.

## Deployment instructions

TBD

## Contributing

TBD

We look forward to seeing your pull requests!

## License

GPLv3+

