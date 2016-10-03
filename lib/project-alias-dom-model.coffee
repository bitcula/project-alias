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
    projectNames = (p.header.innerText for p in @projects)
    projectNames

  getProjectPaths: () ->
    projectPaths = (@getProjectPath(p) for p in @projects)
    projectPaths

  getProjectElement: (name) ->
    project = (p for p in @projects when p.getElementsByClassName('name')[0].innerHTML is name)
    return project[0]

  getProjectByPath: (path) ->
    project = (p for p in @projects when @getProjectPath(p) is path)
    return project[0]

  getProjectByOriginalProjectName: (name) ->
    project = (p for p in @projects when @getOriginalProjectName(p) is name)
    if project
      return project[0]
    else
      return null

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
