using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CustomApplication
{
    public class CustomApplicationKeyUpsertInputModel: InputModelBase
    {
        public CustomApplicationKeyUpsertInputModel() : base(InputTypeGuidConstants.CustomApplicationUpsertInputModel)
        {
        }
        public Guid? CustomApplicationKeyId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? GenericFormKeyId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CustomApplicationKeyId = " + CustomApplicationKeyId);
            stringBuilder.Append(", CustomApplicationId = " + CustomApplicationId);
            stringBuilder.Append(", GenericFormKeyId = " + GenericFormKeyId);
            return stringBuilder.ToString();
        }
    }
}
