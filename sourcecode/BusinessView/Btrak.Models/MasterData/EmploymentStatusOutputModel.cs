using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class EmploymentStatusOutputModel
    {
        public Guid? EmploymentStatusId { get; set; }
        public Guid? CompanyId { get; set; }
        public string EmploymentStatusName { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsPermanent { get; set; }
        public bool? IsArchived { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmploymentStatusId = " + EmploymentStatusId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", EmploymentStatusName = " + EmploymentStatusName);
            stringBuilder.Append(", IsPermanent = " + IsPermanent);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
