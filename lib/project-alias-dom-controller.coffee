path = require 'path'
jQuery = require 'jquery'
$ = jQuery

module.exports =
class ProjectAliasDomController
  projects: null

  constructor: () ->
    @refreshProjectElements()

  refreshProjectElements: () ->
    @projects = document.getElementsByClassName 'project-root'

  getProjectElements: () ->
    return @projects

  getProjectElementByCurrentName: (currentName) ->
    project = (p for p in @projects when p.getElementsByClassName('name')[0].innerHTML is currentName)
    return project[0]

  getProjectElementByOriginalName: (originalName) ->
    project = (p for p in @projects when @getOriginalProjectName(p) is originalName)
    if project
      return project[0]
    else
      return null

  getProjectElementByPath: (path) ->
    project = (p for p in @projects when @getProjectPath(p) is path)
    return project[0]

  getProjectPaths: () ->
    projectPaths = (@getProjectPath(p) for p in @projects)
    projectPaths

  # Renames a project within the DOM
  renameProject: (originalName, aliasName) ->
    project = @getProjectElementByCurrentName(originalName)
    projectNameElement = project.getElementsByClassName('name')[0]
    projectNameElement.innerHTML = aliasName
    return

  # Returns the directory of a project
  getProjectPath: (projectElement) ->
    projectPath = $(projectElement).find("span").filter($(".name"))[0].attributes['data-path'].value
    projectPath

  # The original project name is the last folder within the path
  getOriginalProjectName: (projectElement) ->
    projectPath = @getProjectPath(projectElement)
    name = path.basename(projectPath)
    name

  getCurrentProjectName: (projectElement) ->
    projectName = $(projectElement).find("span").filter($(".name"))[0].innerHTML
    projectName

  # A project is selected when the user right clicks on it
  getSelectedProjectElement: ->
    project = $('.tree-view .selected')
    project

  getSelectedProjectCurrentName: ->
    project = @getSelectedProjectElement()
    projectName = @getCurrentProjectName(project)
    return projectName

  getSelectedProjectOriginalName: ->
    project = @getSelectedProjectElement()
    originalProjectName = @getOriginalProjectName(project)
    return originalProjectName

  getSelectedProjectPath: ->
    project = @getSelectedProjectElement()
    projectPath = @getProjectPath(project)
