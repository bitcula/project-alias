module.exports =
class ProjectAliasInstanceModel
  atom.deserializers.add(this)

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

  update: (instanceModel) ->
    @aliasProjectName = instanceModel.getAliasProjectName()

  serialize: () ->
    deserializer: 'MyObject', data: @data
