#!/usr/bin/env Rscript
##keynote.R v1.1 Damon Kiesow @dkiesow
##Use with the Keynote rTweet AppleScript app to automate threaded tweeting during Keynote presentations
##
## load rtweet package
library(rtweet)
me <- rtweet:::home_user()

## Pull parameters from command line (first_status will be "yes" or "no" and provided from the AppleScript)
args <- commandArgs(trailingOnly = TRUE)

## Check to make sure there are two parameters
if (length(args) < 2) {
  stop("Two arguments must be supplied")
} else if (length(args) == 2) {
  keynote_status <- args[1]
  first_status <- args[2]
}
keynote_status = iconv(keynote_status, "UTF-8", "cp1252"); 
keynote_status = gsub("(\x93|\x94)", "\"", keynote_status, perl = T)
keynote_status = gsub("(\x92)", "'", keynote_status, perl = T)
## Send a new tweet if first_status is "Yes" and reply tweet if "No"
## If you neglect to set the "[first]" flag in Keynote it will thread from your most recent tweet
## rtweet uses "get_timeline" to pull the last 3 tweets from your account
## It then uses "reply_id" to pull your last tweet's "status_id" from the data table of "my_timeline"
if (first_status == 'yes') {
  post_tweet(status = keynote_status) 
} else {
  my_timeline <- get_timeline(user = me, 3) 
  reply_id <- my_timeline[1, 2]
  post_tweet(status = keynote_status, in_reply_to_status_id = reply_id)
}
