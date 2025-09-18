using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestRunAndPlansOverviewModel : ReportModel
    {
        public Guid? Id { get; set; }

        public Guid? ProjectId { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public string CreatedBy { get; set; }

        public string CreatedOn { get; set; }

        public bool IsArchived { get; set; }

        public bool IsCompleted { get; set; }

        public bool IsTestRun { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(" ProjectId = " + ProjectId);
            stringBuilder.Append(", Name = " + Name);
            stringBuilder.Append(", Description =" + Description);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedBy = " + CreatedBy);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", IsTestRun = " + IsTestRun);
            stringBuilder.Append(", PassedCount = " + PassedCount);
            stringBuilder.Append(", BlockedCount = " + BlockedCount);
            stringBuilder.Append(", UntestedCount = " + UntestedCount);
            stringBuilder.Append(", FailedCount = " + FailedCount);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", PassedPercent = " + PassedPercent);
            stringBuilder.Append(", UntestedPercent = " + UntestedPercent);
            stringBuilder.Append(", RetestPercent = " + RetestPercent);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
