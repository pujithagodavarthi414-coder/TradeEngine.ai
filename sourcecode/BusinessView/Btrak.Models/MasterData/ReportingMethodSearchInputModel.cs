using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class ReportingMethodSearchInputModel :SearchCriteriaInputModelBase
    {
        public ReportingMethodSearchInputModel() : base(InputTypeGuidConstants.GetEducationLevel)
        {
        }

        public Guid? ReportingMethodId { get; set; }
        public string ReportingMethodName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ReportingMethodId  = " + ReportingMethodId);
            stringBuilder.Append("ReportingMethodName = " + ReportingMethodName);
            stringBuilder.Append("IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
