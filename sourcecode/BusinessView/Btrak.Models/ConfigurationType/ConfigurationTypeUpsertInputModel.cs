using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ConfigurationType
{
    public class ConfigurationTypeUpsertInputModel : InputModelBase
    {
        public ConfigurationTypeUpsertInputModel() : base(InputTypeGuidConstants.ConfigurationTypeUpsertInputCommandTypeGuid)
        {
        }

        public Guid? ConfigurationTypeId { get; set; }
        public string ConfigurationTypeName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ConfigurationTypeId = " + ConfigurationTypeId);
            stringBuilder.Append(", ConfigurationTypeName = " + ConfigurationTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
