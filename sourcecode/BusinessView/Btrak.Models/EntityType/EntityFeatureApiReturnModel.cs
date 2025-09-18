using System;
using System.Text;

namespace Btrak.Models.EntityType
{
    public class EntityFeatureApiReturnModel
    {
        public Guid? EntityFeatureId { get; set; }

        public Guid? EntityTypeId { get; set; }
        public Guid? ParentFeatureId { get; set; }

        public string EntityFeatureName { get; set; }

        public DateTime? CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }

        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EntityFeatureId = " + EntityFeatureId);
            stringBuilder.Append(", EntityTypeId = " + EntityTypeId);
            stringBuilder.Append(", ParentFeatureId = " + ParentFeatureId);
            stringBuilder.Append(", EntityFeatureName = " + EntityFeatureName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
