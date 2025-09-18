using System;
using System.Text;

namespace Btrak.Models.StatusReportingConfiguration
{
    public class StatusReportApiReturnModel
    {
        public Guid Id { get; set; }
        public Guid StatusReportingConfigurationOptionId { get; set; }

        public string FilePath { get; set; }
        public string FileName { get; set; }
        public string FormDataJson { get; set; }
        public string Description { get; set; }

        public string FormName { get; set; }
        public string FormJson { get; set; }

        public bool? Seen { get; set; }

        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public string CreatedByUserName { get; set; }

        public DateTime UpdatedDateTime { get; set; }
        public Guid UpdatedByUserId { get; set; }

        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("StatusReportingConfigurationOptionId = " + StatusReportingConfigurationOptionId);
            stringBuilder.Append(", Id = " + Id);
            stringBuilder.Append(", FilePath = " + FilePath);
            stringBuilder.Append(", FileName = " + FileName);
            stringBuilder.Append(", FormDataJson = " + FormDataJson);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", FormName = " + FormName);
            stringBuilder.Append(", Seen = " + Seen);
            stringBuilder.Append(", FormJson = " + FormJson);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedByUserName = " + CreatedByUserName);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
