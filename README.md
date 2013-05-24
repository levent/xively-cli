# Xively CLI

A Xively client tool

[![Build Status](https://secure.travis-ci.org/levent/xively.png)](http://travis-ci.org/levent/xively)
[![Dependency Status](https://gemnasium.com/levent/xively.png)](https://gemnasium.com/levent/xively)

## Installation

```bash
gem install xively
```

## Usage

### Connect to the socket server

You can connect to a feed or datastream and receive realtime json updates in your terminal

```bash
xively subscribe -k YOUR_API_KEY -f FEED_ID -d DATASTREAM_ID
```

