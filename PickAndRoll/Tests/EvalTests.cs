using System.Collections.Generic;
using PickAndRoll;
using Xunit;

namespace Tests
{
    public class EvalTests
    {
        private Configurator _configurator;

        public EvalTests()
        {
            _configurator = new Configurator();
        }

        [Fact]
        public void ReturnSameDictionaryIfValuesHaveNotParameters()
        {
            var config = new Dictionary<string, string>
                                                    {
                                                        {"a","1"},
                                                        {"b","2"}
                                                    };
            var evaledConfig = _configurator.Eval(config);

            Assert.Equal(config, evaledConfig);
        }

        [Fact]
        public void ReturnDictionaryWithReplacedParameter()
        {
            var expected = new Dictionary<string, string>
                                                    {
                                                        {"a","1"},
                                                        {"b","1"}
                                                    };

            var config = new Dictionary<string, string>
                                                    {
                                                        {"a","1"},
                                                        {"b","@{a}"}
                                                    };

            Assert.Equal(expected, _configurator.Eval(config));
        }

        [Fact]
        public void ReturnDictionaryWithReplacedParameters()
        {
            var expected = new Dictionary<string, string>
                                                    {
                                                        {"a","1"},
                                                        {"c", "a:1 in b:(b is 1) with a=1"},
                                                        {"b","(b is 1)"},
                                                    };

            var config = new Dictionary<string, string>
                                                    {
                                                        {"a","1"},
                                                        {"c", "a:@{a} in b:@{b} with a=@{a}"},
                                                        {"b","(b is @{a})"},
                                                    };

            Assert.Equal(expected, _configurator.Eval(config));
        }
    }
}