using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CustomApplication
{
    public class CustomApplicationKeySearchInputModel : SearchCriteriaInputModelBase
    {
        public CustomApplicationKeySearchInputModel() : base(InputTypeGuidConstants.CustomApplicationSearchInputModel)
        {
        }

        public Guid? CustomApplicationId { get; set; }
        public Guid? CustomApplicationKeyId { get; set; }
        public Guid? GenericFormKeyId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" CustomApplicationId = " + CustomApplicationId);
            stringBuilder.Append(", CustomApplicationKeyId = " + CustomApplicationKeyId);
            stringBuilder.Append(", GenericFormKeyId = " + GenericFormKeyId);
            return stringBuilder.ToString();
        }
    }
}

