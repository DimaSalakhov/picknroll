picknroll
=========

Keep environment specific attributes in separate configuration files and build desired config on demand.

Gem: <http://rubygems.org/gems/pick_and_roll>  
`gem install pick_and_roll`

## The problem ##
When you deal with the project with more than one developer/environment, you may end up with the situation when you need different config files for different circumstances which are the same in general, but differ in some parameters like connection string.

In that situation to do not repeat parameters it's appropriate to move general parameters in one file and environment-specific settings to separate ones, separate file for each settings' collection.

This project will help to accomplish inverse process: build configuration file by the set of configs.

### Config splitting ###

Web.config:
```
<configuration>
  <appSettings>
    <add key="CMSProgrammingLanguage" value="C#" />
    <add key="BaseUri" value="@@baseurl@@" />
  </appSettings>
</configuration>
```

Michael.json:
```
{
  "baseuri":"http://localhost"
}
```

Scotty.json:
```
{
  "baseuri":"http://website"
}
```

### Usage ###

```
require 'pick_and_roll'
PickAndRoll.new().go #will look for <machine-name>.json file as custom config

PickAndRoll.new('custom_configuration').go #will execute with Michael.json file as custom config.
```

### Configuration ###

All configuration files are in json format, everything can be configured with `.parconfig` file:

```
{
    "config": "config.json",
    "customDir": "custom",
    "files": [
        "*.generic.xml",
        "*.generic.config"
    ]
}
```

`config` - path to file with global settings  
`customDir` - path to directory with custom configurations  
`files` - array of files to be parsed. If filename contain ".generic.", then new file without slug will be generated as a result, otherwise it will be replaced with substituted values.  
In example:

    web.generic.config -> web.generic.config + *web.config  
    app.config -> *app.config


