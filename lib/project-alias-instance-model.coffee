module.exports =
class ProjectAliasInstanceModel
  originalProjectName: null
  aliasProjectName: null
  projectPath: null

  constructor: (originalProjectName, aliasProjectName, projectPath) ->
    @originalProjectName = originalProjectName
    @aliasProjectName = aliasProjectName
    @projectPath = projectPath

  getOriginalProjectName: () ->
    @originalProjectName

  getAliasProjectName: () ->
    @aliasProjectName

  getProjectPath: () ->
    @projectPath
  
