using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class GetGenericFormTypesSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetGenericFormTypesSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetFormTypes)
        {
        }
        public Guid? FormTypeId { get; set; }
        public string FormTypeName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FormTypeId = " + FormTypeId);
            stringBuilder.Append(" FormTypeName = " + FormTypeName);
            return stringBuilder.ToString();
        }
    }
}
