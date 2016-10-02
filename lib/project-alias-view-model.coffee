ProjectAliasDomModel = require './project-alias-dom-model'
ProjectAliasInstanceModel = require './project-alias-instance-model'

module.exports =
class ProjectAliasViewModel
  projectAliasDomModel: null
  instanceModels: null

  constructor: (instanceModels) ->
    @projectAliasDomModel = new ProjectAliasDomModel()
    @instanceModels = instanceModels

    # TODO: Subscribe somehow on "Open Project" event
    #@openSubscription = atom.workspace.onDidOpen =>
      #@projectAliasController.refreshProjects()

  refreshProjects: () ->
    @projectAliasDomModel.refreshProjects()

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

  # TODO:
  # Currently, I am searching for a way to serialize all aliases to local
  # storage so you are able to restore alias names after restarting atom
  restoreAliasNames: () ->
    projectPaths = @projectAliasDomModel.getProjectPaths()
    for instanceModel in @instanceModels
      # The only way to identify a project within the workspace
      # is its path on the local storage. So we check if the path of the current
      # instance is included in the current workspace before renaming anything
      projectPath = instanceModel.getProjectPath()
      if projectPath in projectPaths
        originalName = instanceModel.getOriginalProjectName()
        aliasName = instanceModel.getAliasProjectName()
        @projectAliasDomModel.renameProject(currentName, aliasName)

  rename: (aliasName) ->
    if aliasName
      # The original may differ from the current name since it may has
      # been changed before
      originalName = @projectAliasDomModel.getSelectedOriginalProjectName()
      # Current name represents the name which is currently set
      currentName = @projectAliasDomModel.getSelectedProjectName()
      projectPath = @projectAliasDomModel.getSelectedProjectPath()
      # The instance model is used for serialization
      instanceModel = new ProjectAliasInstanceModel(originalName, aliasName, projectPath)
      @_storeInstance(instanceModel)
      @projectAliasDomModel.renameProject(currentName, aliasName)

  # Iterate over instance models to check if
  _storeInstance: (instanceModel) ->
    for im in @instanceModels
      # The alias may have changed for a project so we will update the original
      # reference
      debugger
      if instanceModel.getProjectPath() is im.getProjectPath()
        im.update(instanceModel)
        return
    # We have a completly new alias so we have to store it
    @instanceModels.push(instanceModel)
    return
