using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using JsonFx.Json;

namespace PickAndRoll
{
    class Program
    {
        static void Main(string[] args)
        {
            var configsDirectory = @"d:\Temp\configs";

            if(Directory.Exists(configsDirectory) == false)
                throw new Exception("Configuration directory was not defined");

            

            var configurator = new Configurator();
            var configs = configurator.Read(configsDirectory);
            var configuration = configurator.Merge(configs);
            var evaledConfiguration = configurator.Eval(configuration);
        }
    }

    public class Configurator
    {
        private static readonly Regex ParameterRegex = new Regex(@"\@\{([\w\.]*)\}");

        public Dictionary<string, string> Merge(IEnumerable<string> jsons)
        {
            if(jsons == null || jsons.Any() == false)
                throw new ArgumentNullException();

            var jsonReader = new JsonReader();

            return jsons.Select(jsonReader.Read<Dictionary<string, string>>)
                        .SelectMany(x => x)
                        .ToLookup(x => x.Key, x => x.Value)
                        .ToDictionary(x => x.Key, x => x.Last());
        }

        public IEnumerable<string> Read(string configsDirectory)
        {
            return Directory
                .GetFiles(configsDirectory, "*.json", SearchOption.AllDirectories)
                .Select(File.ReadAllText);
        }

        public Dictionary<string,string> Eval(Dictionary<string, string> configuration)
        {
            var beforeReplace = configuration.Count(x => ParameterRegex.IsMatch(x.Value));
            foreach (var pair in configuration.Where(x => ParameterRegex.IsMatch(x.Value)).ToArray())
            {
                configuration[pair.Key] = ParameterRegex.Replace(pair.Value, match => configuration
                                                                     .FirstOrDefault(x => match.Groups[1].Value == x.Key)
                                                                     .Value
                                                                 );
            }
            var afterReplace = configuration.Count(x => ParameterRegex.IsMatch(x.Value));
            
            if (beforeReplace > afterReplace)
                Eval(configuration);

            return configuration;
        }
    }
}
