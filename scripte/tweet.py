#!/usr/bin/python

import os
import tweepy
import sys

# This function pretty much taken directly from a tweepy example.
def setup_api():
  auth = tweepy.OAuthHandler('', '')
  auth.set_access_token('', '')
  return tweepy.API(auth)

# Authorize.
api = setup_api()

# Get the parameters from the command line. The first is the
# name of the image file. The second is the tweet text.
fn = os.path.abspath(sys.argv[1])
status = sys.argv[2]

# Send the tweet.
api.update_with_media(fn, status=status)

