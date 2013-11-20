# Description:
#   cat me is the most important thing in your life (ΦωΦ)
#   Interacts with The Cat API. (http://thecatapi.com/)
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot cat me <category> - Receive a cat
#   hubot cat bomb N - get N cats
#   hubot show me cat's categories - show cat's active categories.
 
xml2js = require 'xml2js'
 
module.exports = (robot) ->
  robot.respond /cat me( (.*))?/i, (msg) ->
    url = if msg.match[2]? then "http://thecatapi.com/api/images/get?format=xml&category=" + msg.match[2] else "http://thecatapi.com/api/images/get?format=xml"
    msg.http(url)
      .get() (err, res, body) ->
        parser = new xml2js.Parser()
        parser.parseString body, (err, result) ->
          msg.send if result["response"]["data"][0]["images"][0]["image"]? then result["response"]["data"][0]["images"][0]["image"][0]["url"] else "image not found."
 
  robot.respond /cat bomb( (\d+))?/i, (msg) ->
    count = msg.match[2] || 5
    msg.http("http://thecatapi.com/api/images/get?format=xml&results_per_page=" + count)
      .get() (err, res, body) ->
        parser = new xml2js.Parser()
        parser.parseString body, (err, result) ->
          msg.send image["url"] for image in result["response"]["data"][0]["images"][0]["image"]
 
  robot.respond /show me cat's categories/i, (msg) ->
    msg.http("http://thecatapi.com/api/categories/list")
      .get() (err, res, body) ->
        parser = new xml2js.Parser()
        parser.parseString body, (err, result) ->
          msg.send image["name"] for image in result["response"]["data"][0]["categories"][0]["category"]