ProjectAliasDomModel = require './project-alias-dom-model'
ProjectAliasInstanceModel = require './project-alias-instance-model'

module.exports =
class ProjectAliasViewModel
  projectAliasDomModel: null
  instanceModels: null

  constructor: () ->
    @projectAliasDomModel = new ProjectAliasDomModel()
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
        # The current name may differ from the original name so we have
        # to retrieve it since renameProject() needs the current name
        project = @projectAliasDomModel.getProjectByOriginalProjectName(originalName)
        currentName = @projectAliasDomModel.getProjectName(project)
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
