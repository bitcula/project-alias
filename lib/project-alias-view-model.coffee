ProjectAliasDomModel = require './project-alias-dom-model'

module.exports =
class ProjectAliasViewModel
  projectAliasDomModel:null

  constructor: () ->
    @projectAliasDomModel = new ProjectAliasDomModel()
    @projectAliasDomModel.refreshProjects()

    # TODO: Subscribe somehow on "Open Project" event
    #@openSubscription = atom.workspace.onDidOpen =>
      #@projectAliasController.refreshProjects()

  deactivate: ->
    @projectAliasDomModel.destroy()
    # openSubscription.dispose()

  getProjectElements: () ->
    projectElements = @projectAliasDomModel.getProjectElements()
    projectElements

  getProjectName: (projectElement) ->
    @projectAliasDomModel.getProjectName(projectElement)

  getOriginalProjectName: (projectElement) ->
    name = @projectAliasDomModel.getOriginalProjectName(projectElement)
    name

  rename: (aliasName) ->
    if aliasName
      currentName = @projectAliasDomModel.getSelectedProjectName()
      @projectAliasDomModel.renameProject(currentName, aliasName)
