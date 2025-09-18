using System;
using System.Text;

namespace Btrak.Models.ConfigurationType
{
    public class ConfigurationTypeApiReturnModel
    {
        public Guid? ConfigurationTypeId { get; set; }
        public string ConfigurationTypeName { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public Guid? FieldId { get; set; }
        public string FieldName { get; set; }
        public bool IsMandatory { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ConfigurationTypeId = " + ConfigurationTypeId);
            stringBuilder.Append(", ConfigurationTypeName = " + ConfigurationTypeName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", FieldId = " + FieldId);
            stringBuilder.Append(", FieldName = " + FieldName);
            stringBuilder.Append(", IsMandatory = " + IsMandatory);
            return stringBuilder.ToString();
        }
    }
}
