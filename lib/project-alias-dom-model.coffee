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

  getProjectPaths: () ->
    projectPaths = []
    for p in @projects
      projectPaths.push(@getProjectPath(p))
    projectPaths

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
    projectPath = $(projectElement).find("span").filter($(".name"))[0].attributes['data-path'].value
    projectPath

  # The original project name is the last folder of the path
  getOriginalProjectName: (projectElement) ->
    projectPath = @getProjectPath(projectElement)
    name = path.basename(projectPath)
    name

    # A project is selected when the user right clicks on it
  getSelectedProject: ->
    project = $('.tree-view .selected')
    project

  getProjectName: (projectElement) ->
    projectName = $(projectElement).find("span").filter($(".name"))[0].innerHTML
    projectName

  getSelectedProjectName: ->
    project = @getSelectedProject()
    projectName = @getProjectName(project)
    return projectName

  getSelectedOriginalProjectName: ->
    project = @getSelectedProject()
    originalProjectName = @getOriginalProjectName(project)
    return originalProjectName

  getSelectedProjectPath: ->
    project = @getSelectedProject()
    projectPath = @getProjectPath(project)
