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

  getSelectedProject: ->
    p = @projectAliasDomModel.getSelectedProject()
    p

  getOriginalProjectName: (project) ->
    n = @projectAliasDomModel.getOriginalProjectName(project)
    n

  renameProject: (originalName, aliasName) ->
    @projectAliasDomModel.renameProject(originalName, aliasName)
