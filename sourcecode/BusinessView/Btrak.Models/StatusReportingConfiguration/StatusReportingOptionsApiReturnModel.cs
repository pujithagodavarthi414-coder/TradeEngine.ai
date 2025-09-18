using System;
using System.Text;

namespace Btrak.Models.StatusReportingConfiguration
{
    public class StatusReportingOptionsApiReturnModel
    {
        public Guid Id { get; set; }
        public string OptionName { get; set; }
        public string DisplayName { get; set; }
        public int SortOrder { get; set; }
        public int TotalCount { get; set; }
        public Guid? CompanyId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", OptionName = " + OptionName);
            stringBuilder.Append(", DisplayName = " + DisplayName);
            stringBuilder.Append(", SortOrder = " + SortOrder);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(",  IsArchived = " + IsArchived);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
