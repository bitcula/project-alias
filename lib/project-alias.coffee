ProjectAliasRenameView = require './project-alias-rename-view'
ProjectAliasViewModel = require './project-alias-view-model'
{CompositeDisposable} = require 'atom'

module.exports = ProjectAlias =
  projectAliasRenameView: null
  projectAliasViewModel: null
  modalRenamePanel: null
  subscriptions: null
  openSubscription: null

  activate: (state) ->
    @projectAliasRenameView = new ProjectAliasRenameView(state.projectAliasRenameViewState)
    @modalRenamePanel = atom.workspace.addModalPanel(item: @projectAliasRenameView.getElement(), visible: false)

    #TODO: Check if there are serialized objects in state param
    instanceModels = @retrieveInstanceModels()
    @projectAliasViewModel = new ProjectAliasViewModel(instanceModels)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'project-alias:rename': => @showRenameView()

    # The view has to execute its callback methods on this module
    @projectAliasRenameView.setCallback this

    @openSubscription = atom.workspace.onDidOpen =>
      @projectAliasViewModel.refreshProjects()
      @projectAliasViewModel.restoreAliasNames()

    @openSubscription = atom.workspace.onDidOpen =>
      @refreshToolTips()

    return

  deactivate: ->
    @modalRenamePanel.destroy()
    @subscriptions.dispose()
    @openSubscription.dispose()
    @projectAliasRenameView.destroy()
    @projectAliasViewModel.destroy()

  serialize: ->
    projectAliasRenameViewState: @projectAliasRenameView.serialize()

  retrieveInstanceModels: ->
    instanceModels = []
    return instanceModels

    # Called when the user right-clicks a project
  showRenameView: ->
    @modalRenamePanel.show()
    return

  # Will be called by modalRenamePanel when the user interacts with a button
  closeRenameView: (newName) ->
    @projectAliasViewModel.rename(newName)
    @modalRenamePanel.hide()

  refreshToolTips: () ->
    projects = @projectAliasViewModel.getProjectElements()
    for project in projects
        originalProjectName = @projectAliasViewModel.getOriginalProjectName(project)
        currentProjectName = @projectAliasViewModel.getProjectName(project)
        if originalProjectName isnt currentProjectName
          title = "Original Name: " + originalProjectName
          @subscriptions.add atom.tooltips.add(project, {title: title})
