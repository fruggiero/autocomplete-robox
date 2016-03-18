#
#Esempio:  https://github.com/Azakur4/autocomplete-php/blob/master/lib/provider.coffee
#

fs = require 'fs'
path = require 'path'

module.exports =
  selector: '.source.r3'
  #disableForSelector: '.source.js .comment'
  filterSuggestions: true #Apply the default fuzzy filtering/sorting scheme

  # This will take priority over the default provider, which has a priority of 0.
  # `excludeLowerPriority` will suppress any providers with a lower priority
  # i.e. The default provider will be suppressed
  inclusionPriority: 1
  excludeLowerPriority: true

  # Required: Return a promise, an array of suggestions, or null.
  getSuggestions: (request) ->
    # editor: The current TextEditor
    # bufferPosition: The position of the cursor
    # scopeDescriptor: The scope descriptor for the current cursor position
    # prefix: The prefix for the word immediately preceding the current cursor position
    # activatedManually: Whether the autocomplete request was initiated by the user (e.g. with ctrl+space)

    new Promise (resolve) ->
      # line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
      # @getCompletions(line)

      if true
        resolve(@getAllCompletions(request))
      else
        resolve([])


  getAllCompletions: ({editor, prefix}) ->
    completions = []
    lowerCasePrefix = prefix.toLowerCase()

    for constants in @completions.constants when constants.text.toLowerCase().indexOf(lowerCasePrefix) is 0
      completions.push(@buildCompletion(constants))

    completions

  load: ->
    #Load completions from file
    @completions = {}
    fs.readFile path.resolve(__dirname, '..', 'completions.json'), (error, content) =>
      @completions = JSON.parse(content) unless error?
      return

  buildCompletion: (suggestion) ->
    text: suggestion.text
    type: suggestion.type
    displayText: suggestion.displayText ?= null
    snippet: suggestion.snippet ?= null
    leftLabel: suggestion.leftLabel ?= null
    description: suggestion.description ?= "R3 <#{suggestion.text}> #{suggestion.type}"
    descriptionMoreURL: suggestion.descriptionMoreURL ?= null

  firstCharsEqual: (str1, str2) ->
    str1[0].toLowerCase() is str2[0].toLowerCase()

  # (optional): called _after_ the suggestion `replacementPrefix` is replaced
  # by the suggestion `text` in the buffer
  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

  # (optional): called when your provider needs to be cleaned up. Unsubscribe
  # from things, kill any processes, etc.
  dispose: ->
