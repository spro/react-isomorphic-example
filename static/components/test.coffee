React = require 'react'

randomString = (len=8) ->
    s = ''
    while s.length < len
        s += Math.random().toString(36).slice(2, len-s.length+2)
    return s

Test = React.createClass
    render: ->
        {word, definition} = @props

        <div className='tester'>
            <p><strong>{word}</strong>: {definition}</p>
            <TestInner />
        </div>

TestInner = React.createClass

    render: ->
        next_word = randomString(Math.round(Math.random() * 5 + 5))
        next_word_url = '/definitions/' + next_word
        <a href={next_word_url}>Ok</a>

module.exports = Test

