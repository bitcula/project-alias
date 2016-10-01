ProjectAliasDomModel = require './project-alias-dom-model'

module.exports =
class ProjectAliasViewModel
  projectAliasDomModel:null

  constructor: () ->
    @projectAliasDomModel = new ProjectAliasDomModel()
    @projectAliasDomModel.refreshProjects()

    # TODO: Subscribe somehow on "Open Project" event
    #@openSubscription = atom.workspace.onDidOpen =>
      #@projectAliasController.getProjectElements()

  deactivate: ->
    @projectAliasDomModel.destroy()
    # openSubscription.dispose()

  rename: (aliasName) ->
    if aliasName
      currentName = @projectAliasDomModel.getSelectedProjectName()
      @projectAliasDomModel.renameProject(currentName, aliasName)
