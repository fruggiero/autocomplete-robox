#
#Esempio:  https://github.com/Azakur4/autocomplete-php/blob/master/lib/provider.coffee
#          http://stackoverflow.com/questions/835682/how-does-intellisense-work-in-visual-studio

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
   # {editor, bufferPosition, scopeDescriptor, prefix, activatedManually}
  getSuggestions: (request) ->
    new Promise (resolve) =>

      # @getCompletions(line)

      console.log request
      if not @mustAutocomplete(request)
        resolve([])
      else
        resolve(@getAllCompletions(request))

  getAllCompletions: ({editor, prefix , activatedManually}) ->
    completions = []
    lowerCasePrefix = prefix.toLowerCase()

    if activatedManually
      for constants in @completions.constants
        completions.push(@buildCompletion(constants))
      for snippets in @completions.snippets
        completions.push(@buildCompletion(snippets))
      for types in @completions.types
        completions.push(@buildCompletion(types))
    else
      for constants in @completions.constants when constants.text.toLowerCase().indexOf(lowerCasePrefix) is 0
        completions.push(@buildCompletion(constants))
      for snippets in @completions.snippets when snippets.displayText.toLowerCase().indexOf(lowerCasePrefix) is 0
        completions.push(@buildCompletion(snippets))
      for types in @completions.types when types.text.toLowerCase().indexOf(lowerCasePrefix) is 0
        completions.push(@buildCompletion(types))

    completions

  mustAutocomplete: ({bufferPosition, editor}) ->
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition]).trim()
    if line.startsWith("function")
      return false
    else
      return true

  load: ->
    #Load completions from file
    @completions = {}
    fs.readFile path.resolve(__dirname, '..', 'completions.json'), (error, content) =>
      @completions = JSON.parse(content) unless error?
      return

  buildCompletion: (suggestion) ->
    text: suggestion.text ?= null
    type: suggestion.type  #variable, constant, property, value, method, function, class, type, keyword, tag, snippet, import, require.
    displayText: suggestion.displayText ?= null
    snippet: suggestion.snippet ?= null
    leftLabel: suggestion.leftLabel ?= null
    rightLabel: suggestion.rightLabel ?= null
    description: suggestion.description ?= null
    descriptionMoreURL: suggestion.descriptionMoreURL ?= null

  firstCharsEqual: (str1, str2) ->
    str1[0].toLowerCase() is str2[0].toLowerCase()

  # (optional): called _after_ the suggestion `replacementPrefix` is replaced
  # by the suggestion `text` in the buffer
  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

  # (optional): called when your provider needs to be cleaned up. Unsubscribe
  # from things, kill any processes, etc.
  dispose: ->
