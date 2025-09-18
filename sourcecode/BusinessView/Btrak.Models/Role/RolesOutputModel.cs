using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Role
{
    public class RolesOutputModel
    {
        public Guid? Id { get; set; }
        public Guid? OriginalId { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? CompanyId { get; set; }
        public string RoleName { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public string Features { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsDeveloper { get; set; }
        public List<Guid> FeatureIds { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Id = " + Id);
            stringBuilder.Append(", OriginalId = " + OriginalId);
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", RoleName = " + RoleName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", Features = " + Features);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsDeveloper = " + IsDeveloper);
            return stringBuilder.ToString();
        }
    }
}
