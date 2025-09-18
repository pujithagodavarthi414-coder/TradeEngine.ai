using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestRailAuditSearchModel : SearchCriteriaInputModelBase
    {
        public TestRailAuditSearchModel() : base(InputTypeGuidConstants.TestRailAuditSearchCommandTypeGuid)
        {
        }

        public string Activity { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("@Activity =" + Activity);
            stringBuilder.Append("@PageNumber =" + PageNumber);
            stringBuilder.Append("@PageSize =" + PageSize);
            return stringBuilder.ToString();
        }
    }
}
