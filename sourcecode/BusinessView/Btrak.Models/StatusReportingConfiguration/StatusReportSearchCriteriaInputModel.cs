using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.StatusReportingConfiguration
{
    public class StatusReportSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public StatusReportSearchCriteriaInputModel() : base(InputTypeGuidConstants.StatusReportSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid Id { get; set; }
        public Guid StatusReportingConfigurationOptionId { get; set; }
        public string Description { get; set; }
        public string FilePath { get; set; }
        public string FileName { get; set; }
        public DateTime? CreatedOn { get; set; }
        public string AssignedTo { get; set; }
        public bool? IsUnread { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("StatusReportingConfigurationOptionId = " + StatusReportingConfigurationOptionId);
            stringBuilder.Append(", Id = " + Id);
            stringBuilder.Append(", FilePath = " + FilePath);
            stringBuilder.Append(", FileName = " + FileName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", AssignedTo = " + AssignedTo);
            return stringBuilder.ToString();
        }
    }
}
