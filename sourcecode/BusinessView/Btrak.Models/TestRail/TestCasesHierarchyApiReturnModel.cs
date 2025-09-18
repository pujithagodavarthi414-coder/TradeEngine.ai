using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TestRail
{
    public class TestCasesHierarchyApiReturnModel
    {
        public List<TestCaseApiReturnModel> TestCases { get; set; }

        public List<Guid> TestSuiteSections { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestCases = " + TestCases);
            stringBuilder.Append(", TestSuiteSections = " + TestSuiteSections);
            return stringBuilder.ToString();
        }
    }
}
