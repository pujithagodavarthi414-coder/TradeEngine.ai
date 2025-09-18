using System;
using System.Text;

namespace Btrak.Models.Features
{
    public class FeatureApiReturnModel
    {
        public Guid? FeatureId { get; set; }
        public string FeatureName { get; set; }
        public Guid? ParentFeatureId { get; set; }
        public string MenuItemName { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("FeatureId = " + FeatureId);
            stringBuilder.Append(", FeatureName = " + FeatureName);
            stringBuilder.Append(", ParentFeatureId = " + ParentFeatureId);
            stringBuilder.Append(", MenuItemName = " + MenuItemName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
