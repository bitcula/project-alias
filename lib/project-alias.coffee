ProjectAliasView = require './project-alias-view'
ProjectAliasController = require './project-alias-controller'
{CompositeDisposable} = require 'atom'

jQuery = require 'jquery'
$ = jQuery

module.exports = ProjectAlias =
  projectAliasView: null
  projectAliasController:null
  modalPanel: null
  subscriptions: null


  activate: (state) ->
    @projectAliasView = new ProjectAliasView(state.projectAliasViewState)
    @projectAliasController = new ProjectAliasController
    @modalPanel = atom.workspace.addModalPanel(item: @projectAliasView.getElement(), visible: false)

    # Used to store the name of a project which shall be renamed
    @currentName = undefined

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'project-alias:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'project-alias:rename': => @renameWrapper()

    @openSubscription = atom.workspace.onDidOpen =>
      @projectAliasController.getProjectElements()

    # The view has to execute its callback methods on this module
    @projectAliasView.setCallback this

    return

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @openSubscription.dispose()
    @projectAliasView.destroy()
    @projectAliasController.destroy()

  serialize: ->
    projectAliasViewState: @projectAliasView.serialize()

  renameWrapper: ->
    project = @getSelectedProject()
    oriName = @projectAliasController.getOriginalProjectName project
    @currentName = project.innerHTML
    @modalPanel.show()
    return

  setProjectName: (newName) ->
    if newName
      @projectAliasController.renameProject @currentName, newName
    @modalPanel.hide()
    return

  # A project is selected when the user right clicks on it
  getSelectedProject: ->
    project = $('.tree-view .selected').find('span')[0]
    project

  #updateTooltips = ->
    #console.log 'Update Tooltips'
    #projects = @projectAliasController.getProjectElements()
    #for p of projects
    #  console.dir p
    #return

  toggle: ->
    console.log 'ProjectAlias was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
