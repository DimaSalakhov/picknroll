picknroll
=========

Keep environment specific attributes in separate configuration files and build desired config on demand.

Gem: <http://rubygems.org/gems/pick_and_roll>  
`gem install pick_and_roll`

## The problem ##
Michael and Scotty work on the same website.  
Michael use url "http://localhost", Scotty - "http://website".  
Configuration lives in repository.  

Basically guys have to options:  
 1. store 2 configuration files and duplicate common settings
 2. manually change url setting after checkout

Their problems may be overcome with the following solution:
 1. Keep common settings in configuration file
 2. Separate distinct settings to custom files: Michael.json and Scotty.json respectively
 3. Build configuration result configuration file based on common and custom files on demand

### Config splitting ###

Web.config:
```
<configuration>
  <appSettings>
    <add key="Language" value="@@language@@" />
    <add key="BaseUri" value="@@baseurl@@" />
  </appSettings>
</configuration>
```

config.json
```
{ "language":"C#" }
```

Michael.json:
```
{ "baseuri":"http://localhost" }
```

Scotty.json:
```
{
    "language":"Ruby"
    "baseuri":"http://website"
}
```

where *config.json* accumulates settings which is true for the majority, but should be customizable

### Usage ###

`PickAndRoll.new().go` - will look for *config.json* and *<machine-name>.json* file as custom config  
or  
`PickAndRoll.new('Scotty').go` - will look for *config.json* and execute with *Scotty.json* file as custom config, overriding *language* setting

### Configuration ###

All configuration files are in json format, process can be configured with `.parconfig` file:

```
{
    "customDir": "_configs",
    "config": "config.json",
    "files": [
        "*.generic.xml",
        "*.generic.config"
    ]
}
```

`customDir` - path to directory with configuration files (default: `_configs`) 
`config` - path to file with common settings (default: `config.json`; expected to be placed inside `customDir`)  
`files` - array of files to be parsed. If filename contain ".generic.", then new file without slug will be generated, otherwise values will be substituted in original file.  

### Example ###

.parconfig:
```
{
    "files": [
        "*.generic.xml",
        "*.config"
    ]
}
```

Web.generic.xml:
```
<configuration>
    <add key="BaseUri" value="@@baseurl@@" />
</configuration>
```

App.config:
```
<configuration>
    <add key="uri" value="@@baseurl@@" />
</configuration>
```

config.json:
```
{ "baseuri":"http://domain.name" }
```

Michael.json:
```
{ "baseuri":"http://localhost" }
```

If we run PickAndRoll on PC called *Michael* we'll get

*web.generic.xml* - untouched  
*web.xml*:
```
<configuration>
    <add key="BaseUri" value="http://localhost" />
</configuration>
```
*App.config*:
```
<configuration>
    <add key="uri" value="http://localhost" />
</configuration>
```

