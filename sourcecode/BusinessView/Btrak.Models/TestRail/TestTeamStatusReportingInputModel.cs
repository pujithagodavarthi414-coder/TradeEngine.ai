using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TestRail
{
    public class TestTeamStatusReportingInputModel : InputModelBase
    {
        public TestTeamStatusReportingInputModel() : base(InputTypeGuidConstants.TestTeamStatusReportingInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }

        public string CreatedOn { get; set; }

        public DateTime? DateFrom { get; set; }
        public DateTime? SelectedDate { get; set; }

        public DateTime? DateTo { get; set; }
        public Guid? ProjectId { get; set; }



        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", SelectedDate = " + SelectedDate);
            stringBuilder.Append(", DateTo = " + DateTo);
            return stringBuilder.ToString();
        }
    }
}