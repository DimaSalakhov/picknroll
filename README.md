picknroll
=========

Keep environment specific attributes in separate configuration files and build desired config on demand.

Gem: <http://rubygems.org/gems/pick_and_roll>  
`gem install pick_and_roll`

## The problem ##
You may end up with the situation when you need different configurations for different circumstances which are the same in general, but differ in some parameters like connection string.

In that situation to do not repead parameters it's appropriate to split general parameters in one file and specific settings in number of separate ones, different file for each settings' collection.

### Usage ###

```
require 'pick_and_roll'
PickAndRoll.new().go #will look for <machine-name>.json file as custom config

PickAndRoll.new('custom_configuration').go #will execute with custom_configuration.json file as custom config. Could be used for test purposes or build servers
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


