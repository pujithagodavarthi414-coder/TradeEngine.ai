using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class ReportingMethodsSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public ReportingMethodsSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetReportingMethods)
        {
        }
        public Guid? ReportingMethodId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ReportingMethodId = " + ReportingMethodId);
            return stringBuilder.ToString();
        }
    }
}
