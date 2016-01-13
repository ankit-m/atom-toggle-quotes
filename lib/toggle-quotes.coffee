ToggleQuotesView = require './toggle-quotes-view'
{CompositeDisposable} = require 'atom'

isQuote = (text) ->
    return true

isDoubleQuote = (text) ->
    return true

toggleQuotes = (text) ->
    if isQuote(text)
        return '\"' + text + '\"'
    else if isDoubleQuote()
        return text.replace('\"', '')
    else
        return '\'' + text + '\''

module.exports = ToggleQuotes =
    toggleQuotesView: null
    modalPanel: null
    subscriptions: null

    activate: (state) ->
        @toggleQuotesView = new ToggleQuotesView(state.toggleQuotesViewState)
        @modalPanel = atom.workspace.addModalPanel(item: @toggleQuotesView.getElement(), visible: false)

        # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
        @subscriptions = new CompositeDisposable

        # Register command that toggles this view
        @subscriptions.add atom.commands.add 'atom-workspace', 'toggle-quotes:toggle': => @toggle()

    deactivate: ->
        @modalPanel.destroy()
        @subscriptions.dispose()
        @toggleQuotesView.destroy()

    serialize: ->
        toggleQuotesViewState: @toggleQuotesView.serialize()

    toggle: ->
        console.log 'ToggleQuotes toggled!'
        editor = atom.workspace.getActiveTextEditor()
        text = editor.selectWordsContainingCursors()
        words = toggleQuotes(text)
        editor.insertText(words)
