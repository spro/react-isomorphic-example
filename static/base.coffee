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

# Make href clicks trigger the router
$(document).on 'click', "a[href^='/']", (e) ->
    return if e.ctrlKey
    e.preventDefault()
    app_router.navigate $(e.currentTarget).attr('href'), trigger: true

AppRouter = Backbone.Router.extend
    routes:
        "definitions/:word": "showDefinition"

    showDefinition: (word) ->
        getDefinition word, (err, definition) ->
            React.render React.createFactory(Test)({word, definition}), $('#main')[0]

app_router = new AppRouter()

$ ->
    Backbone.history.start(pushState: true)

