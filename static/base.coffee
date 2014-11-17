window.$ = require 'jquery'
Backbone = require 'backbone'; Backbone.$ = $
React = require 'react'

Test = require './components/test'

getDefinition = (word, cb) ->

    # Pull out of bootstrapped props if they match
    if word == bootstrap.word
        cb null, bootstrap.definition

    # Otherwise fetch from the API
    else
        $.get "/definitions/#{ word }.json", (response) ->
            cb null, response.definition

AppRouter = Backbone.Router.extend
    routes:
        "definitions/:word": "showDefinition"

    showDefinition: (word) ->
        getDefinition word, (err, definition) ->
            React.render React.createFactory(Test)({word, definition}), $('#main')[0]

$ ->
    window.app_router = new AppRouter()
    Backbone.history.start(pushState: true)

