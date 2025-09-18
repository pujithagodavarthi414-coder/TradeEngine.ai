using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TestRail
{
    public class SearchTestCaseDetailsInputModel : SearchCriteriaInputModelBase
    {
        public SearchTestCaseDetailsInputModel() : base(InputTypeGuidConstants.TestCaseSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? TestCaseId { get; set; }
        public Guid? SectionId { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TestCaseId = " + TestCaseId);
            stringBuilder.Append(", SectionId = " + SectionId);
            return stringBuilder.ToString();
        }
    }
}
