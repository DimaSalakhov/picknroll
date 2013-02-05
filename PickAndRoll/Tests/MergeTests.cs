using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using PickAndRoll;
using Xunit;

namespace Tests
{
    public class MergeTests
    {
        private readonly Configurator _configurator;

        public MergeTests()
        {
            _configurator = new Configurator();
        }

        [Fact]
        public void ThrowsException_IfInputFilesWereNotFound()
        {
            Assert.Throws<ArgumentNullException>(() => { _configurator.Merge(null); });
        }

        [Fact]
        public void ReturnsDictionaryWithJson_ForOneFlatJson()
        {
            var expected = new Dictionary<string, string>()
                                                      {
                                                          {"one", "1"},
                                                          {"two", "2"}
                                                      };

            const string json1 = "{" +
                                 "\"one\":\"1\"," +
                                 "\"two\":\"2\"" +
                                 "}";

            Assert.Equal(expected, _configurator.Merge(new []{json1}));
        }

        [Fact]
        public void ReturnMergedOfMultipleDictionaries_ValuesOfLastDictionaryOverridesEarlierDictionaries()
        {
            var expected = new Dictionary<string, string>()
                                     {
                                         {"one.a", "1a"},
                                         {"one.b", "1b"},
                                         {"two", "22"},
                                         {"one", "1"}
                                     };

            const string json1 = "{" +
                                 "\"one.a\": \"1a\"," +
                                 "\"one.b\": \"1b\"," +
                                 "\"two\": \"2\"" +
                                 "}";
            const string json2 = "{" +
                                 "\"one\":\"1\"," +
                                 "\"two\":\"22\"" +
                                 "}";

            Assert.Equal(expected, _configurator.Merge(new[] { json1, json2 }));
        }

        [Fact(Skip = "For future release")]
        public void ReturnsDictionaryWithJson_ForOneComplexJson()
        {
            var expected = new Dictionary<string, string>()
                               {
                                   {"one.a", "1a"},
                                   {"one.b", "1b"},
                                   {"two", "2"}
                               };

            const string file = "{" +
                                "\"one\": {" +
                                        "\"a\":\"1a\", " +
                                        "\"b\":\"1b\"}," +
                                "\"two\":\"2\"" +
                                "}";

            Assert.Equal(expected, _configurator.Merge(new[] { file }));
        }

        private string ReadResourseFile(string fileName)
        {
            var fileStream = GetType().Assembly.GetManifestResourceStream(fileName);
            using (var reader = new StreamReader(fileStream))
            {
                return reader.ReadToEnd();
            }
        }
    }
}
