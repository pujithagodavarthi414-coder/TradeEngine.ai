using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.CustomApplication
{
    public class CustomFieldMappingInputModel : InputModelBase
    {
        public CustomFieldMappingInputModel() : base(InputTypeGuidConstants.CustomFieldMappingInputModel)
        {
        }

        public Guid? MappingId { get; set; }

        public string MappingName { get; set; }

        public string MappingJson { get; set; }

        public Guid? CustomApplicationId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CustomApplicationId = " + CustomApplicationId);
            stringBuilder.Append(", MappingId = " + MappingId);
            stringBuilder.Append(", MappingName = " + MappingName);
            stringBuilder.Append(", MappingJson = " + MappingJson);
            return stringBuilder.ToString();
        }
    }
}
