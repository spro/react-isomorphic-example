polar = require 'polar'
browserify = require 'browserify'
coffee_reactify = require 'coffee-reactify'
React = require 'react'
require('node-cjsx').transform()

# Helper function for a fake definition
getDefinition = (word, cb) ->
    definition = 'this is the definition of ' + word + '.'
    definition += ' it has ' + word.length + ' letters and'
    definition += ' it starts with ' + word[0]
    cb null, definition

# Rendering
# ------------------------------------------------------------------------------

# Render a full response
render = (res, component, props) ->
    content = renderComponent component, props
    content += renderBootstrap props
    res.render 'index', {content}

# Render a bootstrap script tag
renderBootstrap = (props) ->
    bootstrap = "window.bootstrap = #{ JSON.stringify(props) };"
    "<script type='text/javascript'>#{ bootstrap }</script>"

# Render a component to HTML
renderComponent = (component, props) ->
    delete require.cache[require.resolve './static/components/' + component]
    _Component = require './static/components/' + component
    React.renderToString React.createFactory(_Component)(props)

# Routes
# ------------------------------------------------------------------------------

app = polar.setup_app port: 5828

# Compiling the script bundle
app.get '/bundle.js', (req, res) ->
    bundler = browserify(extensions: ['.coffee', '.cjsx'])
    bundler.transform coffee_reactify
    bundler.add('./static/base.coffee').bundle().pipe(res)

app.get '/definitions/:word.json', (req, res) ->
    word = req.params.word || 'hello'
    getDefinition word, (err, definition) ->
        res.json {word, definition}

app.get '/definitions/:word', (req, res) ->
    word = req.params.word || 'hello'
    getDefinition word, (err, definition) ->
        render res, 'test', {word, definition}

app.start()

