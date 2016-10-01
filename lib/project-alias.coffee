ProjectAliasRenameView = require './project-alias-rename-view'
ProjectAliasViewModel = require './project-alias-view-model'
{CompositeDisposable} = require 'atom'

module.exports = ProjectAlias =
  projectAliasRenameView: null
  projectAliasViewModel: null
  modalRenamePanel: null
  subscriptions: null

  activate: (state) ->
    @projectAliasRenameView = new ProjectAliasRenameView(state.projectAliasRenameViewState)
    @projectAliasViewModel = new ProjectAliasViewModel()
    @modalRenamePanel = atom.workspace.addModalPanel(item: @projectAliasRenameView.getElement(), visible: false)

    # Used to store the name of a project which shall be renamed
    @currentName = undefined

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'project-alias:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'project-alias:rename': => @renameWrapper()

    # The view has to execute its callback methods on this module
    @projectAliasRenameView.setCallback this

    return

  deactivate: ->
    @modalRenamePanel.destroy()
    @subscriptions.dispose()
    @openSubscription.dispose()
    @projectAliasRenameView.destroy()
    @projectAliasViewModel.destroy()

  serialize: ->
    projectAliasRenameViewState: @projectAliasRenameView.serialize()

  renameWrapper: ->
    project = @projectAliasViewModel.getSelectedProject()
    oriName = @projectAliasViewModel.getOriginalProjectName(project)
    @currentName = project.innerHTML
    @modalRenamePanel.show()
    return

  setProjectName: (newName) ->
    if newName
      @projectAliasViewModel.renameProject(@currentName, newName)
    @modalRenamePanel.hide()
    return

  #updateTooltips = ->
    #console.log 'Update Tooltips'
    #projects = @projectAliasController.getProjectElements()
    #for p of projects
    #  console.dir p
    #return

  toggle: ->
    console.log 'ProjectAlias was toggled!'

    if @modalRenamePanel.isVisible()
      @modalRenamePanel.hide()
    else
      @modalRenamePanel.show()
