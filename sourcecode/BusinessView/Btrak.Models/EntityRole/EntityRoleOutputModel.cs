using System;
using System.Collections.Generic;
using System.Text;
using Btrak.Models.EntityType;

namespace Btrak.Models.EntityRole
{
    public class EntityRoleOutputModel
    {
        public Guid? EntityRoleId { get; set; }
        public string EntityRoleName { get; set; }
        public Guid? CompanyId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public int? VersionNumber { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public Guid? OriginalId { get; set; }
        public byte[] TimeStamp { get; set; }
        public DateTime AsAtInActiveDateTime { get; set; }
        public List<EntityRoleFeatureApiReturnModel> EntityRoleFeaturesList { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EntityRoleId = " + EntityRoleId);
            stringBuilder.Append(", EntityRoleName = " + EntityRoleName);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", VersionNumber = " + VersionNumber);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", OriginalId = " + OriginalId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", AsAtInActiveDateTime = " + AsAtInActiveDateTime);
            return stringBuilder.ToString();
        }
    }
}
