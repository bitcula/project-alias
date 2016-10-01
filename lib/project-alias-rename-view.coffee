jQuery = require 'jquery'
$ = jQuery

# Textedit holds the name given by the user
textEdit = undefined

module.exports =
class ProjectAliasRenameView
  constructor: (serializedState) ->
    # Create root element
    @root = document.createElement('div')
    @root.classList.add 'atom-project-alias'

    # Create text edit element
    textEdit = atom.workspace.buildTextEditor(mini: true)
    textEdit.setText 'MyProject'
    line_edit = atom.views.getView(textEdit)
    @root.appendChild line_edit

    # Create inputs div wrapper
    inputs = undefined
    inputs = document.createElement('div')
    inputs.classList.add 'btn-toolbar'
    @root.appendChild inputs

    # Create OK Button
    @submitButton = $('<button/>').attr(class: 'btn').html('Ok')
    @submitButton.appendTo inputs
    # Add Submit callback function to OK Button
    @submitButton.on 'click', ((_this) ->
      (e) ->
        _this.submit()
    )(this)

    # Create Cancel Button
    @cancelButton = $('<button/>').attr(class: 'btn').html('Cancel')
    @cancelButton.appendTo inputs
    # Add Cancel callback function to Button
    @cancelButton.on 'click', ((_this) ->
      (e) ->
        _this.cancel()
    )(this)

    # Used to call setProjectName on
    @callback = undefined

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @root.remove()

  getElement: ->
    @root

  setCallback: (callbackModule) ->
    @callback = callbackModule
    return

  submit: ->
    console.log 'Submit'
    projectName = textEdit.getText()
    @callback.closeRenameView projectName
    return

  cancel: ->
    console.log 'Cancel'
    @callbackcallback.closeRenameView ''
    return
