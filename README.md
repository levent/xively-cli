# Cosm CLI

A Cosm client tool

[![Build Status](https://secure.travis-ci.org/levent/cosm.png)](http://travis-ci.org/levent/cosm)
[![Dependency Status](https://gemnasium.com/levent/cosm.png)](https://gemnasium.com/levent/cosm)

## Installation

```bash
gem install cosm
```

## Usage

### Connect to the socket server

You can connect to a feed or datastream and receive realtime json updates in your terminal

```bash
cosm subscribe -k YOUR_API_KEY -f FEED_ID -d DATASTREAM_ID
```

