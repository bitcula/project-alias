ProjectAliasDomController = require './project-alias-dom-controller'
ProjectAliasInstanceModel = require './project-alias-instance-model'

module.exports =
class ProjectAliasViewModel
  projectAliasDomController: null
  instanceModels: null

  constructor: () ->
    @projectAliasDomController = new ProjectAliasDomController()
    @instanceModels = @deserialize()

  # We have to use localStorage for serialization because the usual atom
  # way wont restore data between atom restarts
  serialize: () ->
    localStorage.setItem('project-alias', JSON.stringify({InstanceModels: @instanceModels}))

  deserialize: () ->
    modelInstances = []
    jsonObj = localStorage.getItem('project-alias')
    if jsonObj
      jsonObj = JSON.parse(jsonObj)
      for o in jsonObj["InstanceModels"]
        originalProjectName = o.originalProjectName
        aliasProjectName = o.aliasProjectName
        projectPath = o.projectPath
        modelInstances.push(new ProjectAliasInstanceModel(originalProjectName, aliasProjectName, projectPath))

    return modelInstances

  refreshProjectElements: () ->
    @projectAliasDomController.refreshProjectElements()

  deactivate: ->
    @projectAliasDomController.destroy()
    # openSubscription.dispose()

  getProjectElements: () ->
    projectElements = @projectAliasDomController.getProjectElements()
    projectElements

  getCurrentProjectName: (projectElement) ->
    @projectAliasDomController.getCurrentProjectName(projectElement)

  getOriginalProjectName: (projectElement) ->
    name = @projectAliasDomController.getOriginalProjectName(projectElement)
    name

  restoreAliasNames: () ->
    projectPaths = @projectAliasDomController.getProjectPaths()
    for instanceModel in @instanceModels
      # The only way to identify a project within the workspace
      # is its path on the local storage. So we check if the path of the current
      # instance is included in the current workspace before renaming anything
      projectPath = instanceModel.getProjectPath()
      if projectPath in projectPaths
        originalName = instanceModel.getOriginalProjectName()
        aliasName = instanceModel.getAliasProjectName()
        # The current name may differ from the original name so we have
        # to retrieve it since renameProject() needs the current name
        project = @projectAliasDomController.getProjectElementByOriginalName(originalName)
        currentName = @projectAliasDomController.getCurrentProjectName(project)
        @projectAliasDomController.renameProject(currentName, aliasName)

  rename: (aliasName) ->
    if aliasName
      # The original may differ from the current name since it may has
      # been changed before
      originalName = @projectAliasDomController.getSelectedProjectOriginalName()
      # Current name represents the name which is currently set
      currentName = @projectAliasDomController.getSelectedProjectCurrentName()
      projectPath = @projectAliasDomController.getSelectedProjectPath()
      # The instance model is used for serialization
      instanceModel = new ProjectAliasInstanceModel(originalName, aliasName, projectPath)
      @_storeInstance(instanceModel)
      @projectAliasDomController.renameProject(currentName, aliasName)
      @serialize()

  # Iterate over instance models to check if an alias changed and store it
  # for serialization
  _storeInstance: (instanceModel) ->
    for im in @instanceModels
      # The alias may have changed for a project so we will update the original
      # reference
      if instanceModel.getProjectPath() is im.getProjectPath()
        im.update(instanceModel)
        return
    # We have a completly new alias so we have to store it
    @instanceModels.push(instanceModel)
    return
