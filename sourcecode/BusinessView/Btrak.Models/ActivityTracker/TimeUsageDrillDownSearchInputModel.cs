using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.ActivityTracker
{
    public class TimeUsageDrillDownSearchInputModel : SearchCriteriaInputModelBase
    {
        public TimeUsageDrillDownSearchInputModel() : base(InputTypeGuidConstants.TimeUsageDrillDownSearchInputCommandTypeGuid)
        {

        }

        public Guid UserId { get; set; }
        public DateTime Date { get; set; }
        public string ApplicationType { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId" + UserId);
            stringBuilder.Append(", DateTo = " + Date);
            stringBuilder.Append(", AplicationType = " + ApplicationType);
            return stringBuilder.ToString();
        }
    }
}
