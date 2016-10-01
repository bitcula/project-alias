path = require 'path'
jQuery = require 'jquery'
$ = jQuery

module.exports =
class ProjectAliasDomModel
  projects: null

  constructor: () ->
    @refreshProjects()

  refreshProjects: () ->
    @projects = document.getElementsByClassName 'project-root'

  getProjectElements: () ->
    return @projects

  getProjectNames: () ->
    projectNames = []
    Array::forEach.call @projects, (pl) ->
      projectNames.push pl.header.innerText
      return
    projectNames

  getProjectElement: (name) ->
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
    project = @getProjectElement(originalName)
    projectNameElement = project.getElementsByClassName('name')[0]
    projectNameElement.innerHTML = aliasName
    return

  # Returns the directory of a project
  getProjectPath: (projectElement) ->
    projectPath = projectElement.attributes['data-path'].value
    projectPath

  # The original project name is the last folder of the path
  getOriginalProjectName: (projectElement) ->
    projectPath = @getProjectPath(projectElement)
    console.log path.basename(projectPath)
    return

    # A project is selected when the user right clicks on it
  getSelectedProject: ->
    project = $('.tree-view .selected').find('span')[0]
    project
