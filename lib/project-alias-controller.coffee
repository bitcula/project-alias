jQuery = require 'jquery'
path = require 'path'

$ = jQuery

module.exports =
class ProjectAliasController
  constructor: () ->
    debugger
    @projects = @getProjectElements()

  getProjectElements: () ->
    projects = document.getElementsByClassName 'project-root'
    projects

  getProjectNames: () ->
    projectNames = []
    Array::forEach.call @projects, (pl) ->
      projectNames.push pl.header.innerText
      return
    projectNames

  getProject: (name) ->
    ret = null
    Array::forEach.call @projects, (project) ->
      projectNameElement = project.getElementsByClassName('name')[0]
      projectName = projectNameElement.innerHTML
      if projectName == name
        ret = project
        return
      return
    ret

  # Renames a project within the DOM
  renameProject: (originalName, aliasName) ->
    debugger
    project = @getProject(originalName)
    projectNameElement = project.getElementsByClassName('name')[0]
    projectNameElement.innerHTML = aliasName
    return

  # Returns the directory of a project
  getProjectPath: (project) ->
    projectPath = project.attributes['data-path'].value
    projectPath

  # The original project name is the last folder of the path
  getOriginalProjectName: (project) ->
    projectPath = @getProjectPath(project)
    console.log path.basename(projectPath)
    return
