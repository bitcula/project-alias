# project-alias package

Atom uses the name of the selected folder as the project name.  
If you have multiple projects, which for example have the same name of the parent directory, it easily gets confusing.  
This package allows you to rename existing projects.  
Additionally, these projects aliases will be restored whenever you restart the Editor.

Features:
* Rename projects
* Shows a tooltip with the original name when the user hovers with the cursor over a renamed project

Roadmap:
* Add a CSS class to a project element when the project name is changed. This makes it possible to add a specific style to renamed projects

Known Bugs:
* The previously saved project names are restored whenever a file is opened. I am still searching for some callbacks like "project was added" or "atom has loaded completly"

![Screenshot](https://cloud.githubusercontent.com/assets/1751865/19036233/e21ea0ec-896e-11e6-86b5-d24d28129a3e.png)
