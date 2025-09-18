using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.StatusReportingConfiguration
{
    public class StatusReportUpsertInputModel : InputModelBase
    {
        public StatusReportUpsertInputModel() : base(InputTypeGuidConstants.StatusReportUpsertInputCommandTypeGuid)
        {
        }

        public Guid? StatusReportingConfigurationOptionId { get; set; }
        public Guid? Id { get; set; }
        public string FilePath { get; set; }
        public string FileName { get; set; }
        public string FormDataJson { get; set; }
        public string Description { get; set; }
        public DateTime SubmittedDateTime { get; set; }
        public bool IsArchived { get; set; }
        public string FormName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("StatusReportingConfigurationOptionId = " + StatusReportingConfigurationOptionId);
            stringBuilder.Append(", Id = " + Id);
            stringBuilder.Append(", FilePath = " + FilePath);
            stringBuilder.Append(", FileName = " + FileName);
            stringBuilder.Append(", FormDataJson = " + FormDataJson);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", SubmittedDateTime = " + SubmittedDateTime);
            stringBuilder.Append(", SubmittedDateTime = " + SubmittedDateTime);
            stringBuilder.Append(", FormName = " + FormName);
            return stringBuilder.ToString();
        }
    }
}
