using System;
using System.Text;

namespace Btrak.Models.EntityType
{
    public class EntityRoleFeatureApiReturnModel
    {
        public Guid? EntityRoleFeatureId { get; set; }

        public Guid? EntityFeatureId { get; set; }
        public string EntityFeatureName { get; set; }

        public Guid? EntityRoleId { get; set; }
        public string EntityRoleName { get; set; }

        public Guid? ProjectId { get; set; }

        public DateTime? CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }

        public byte[] TimeStamp { get; set; }

        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EntityRoleFeatureId = " + EntityRoleFeatureId);
            stringBuilder.Append(", EntityFeatureId = " + EntityFeatureId);
            stringBuilder.Append(", EntityFeatureName = " + EntityFeatureName);
            stringBuilder.Append(", EntityRoleId = " + EntityRoleId);
            stringBuilder.Append(", EntityRoleName = " + EntityRoleName);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
