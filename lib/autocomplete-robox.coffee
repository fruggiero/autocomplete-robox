AutocompleteRoboxView = require './autocomplete-robox-view'
{CompositeDisposable} = require 'atom'

module.exports = AutocompleteRobox =
  autocompleteRoboxView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @autocompleteRoboxView = new AutocompleteRoboxView(state.autocompleteRoboxViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @autocompleteRoboxView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'autocomplete-robox:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @autocompleteRoboxView.destroy()

  serialize: ->
    autocompleteRoboxViewState: @autocompleteRoboxView.serialize()

  toggle: ->
    console.log 'AutocompleteRobox was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
