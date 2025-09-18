using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CustomApplication
{
    public class CustomApplicationSearchInputModel : SearchCriteriaInputModelBase
    {
        public CustomApplicationSearchInputModel() : base(InputTypeGuidConstants.CustomApplicationSearchInputModel)
        {
        }

        public Guid? CustomApplicationId { get; set; }
        public string CustomApplicationName { get; set; }
        public string Description { get; set; }
        public string Tag { get; set; }
        public string GenericFormName { get; set; }
        public Guid? FormTypeId { get; set; }
        public Guid? FormId { get; set; }
        public string FormName { get; set; }
        public bool IsCompanyBased { get; set; }
        public bool IsList { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" CustomApplicationId = " + CustomApplicationId);
            stringBuilder.Append(" CustomApplicationName = " + CustomApplicationName);
            stringBuilder.Append(" GenericFormName = " + GenericFormName);
            stringBuilder.Append(", FormTypeId = " + FormTypeId);
            stringBuilder.Append(", FormId = " + FormId);
            stringBuilder.Append(", FormName = " + FormName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }

}
