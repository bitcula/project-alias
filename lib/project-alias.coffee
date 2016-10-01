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

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'project-alias:rename': => @showRenameView()

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

    # Called when the user right-clicks a project
  showRenameView: ->
    @modalRenamePanel.show()
    return

  # Will be called by modalRenamePanel when the user interacts with a button
  closeRenameView: (newName) ->
    @projectAliasViewModel.rename(newName)
    @modalRenamePanel.hide()

  #updateTooltips = ->
    #console.log 'Update Tooltips'
    #projects = @projectAliasController.getProjectElements()
    #for p of projects
    #  console.dir p
    #return
