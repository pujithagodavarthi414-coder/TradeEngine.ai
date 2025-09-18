using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class CopyOrMoveTestCasesApiInputModel : SearchCriteriaInputModelBase
    {
        public CopyOrMoveTestCasesApiInputModel() : base(InputTypeGuidConstants.TestSuiteSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? TestSuiteId { get; set; }

        public bool IsCopy { get; set; }

        public bool IsCasesOnly { get; set; }

        public List<Guid?> SelectedSections { get; set; }

        public bool IsCasesWithSections { get; set; }

        public Guid? AppendToSectionId { get; set; }

        public bool IsAllParents { get; set; }

        public string  SelectedSectionsxml { get; set; }

        public List<SelectedTestCaseModel> TestCasesList { get; set; }

        public string TestCasesXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", IsCopy = " + IsCopy);
            stringBuilder.Append(", IsCasesOnly = " + IsCasesOnly);
            stringBuilder.Append(", IsCasesWithSections = " + IsCasesWithSections);
            stringBuilder.Append(", IsCasesWithSectionsAndParentSections = " + IsAllParents);
            stringBuilder.Append(", TestCasesList = " + TestCasesList);
            return stringBuilder.ToString();
        }
    }
}
