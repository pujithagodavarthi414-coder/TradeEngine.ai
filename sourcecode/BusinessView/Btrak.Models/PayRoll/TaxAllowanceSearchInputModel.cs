using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class TaxAllowanceSearchInputModel : SearchCriteriaInputModelBase
    {
        public TaxAllowanceSearchInputModel() : base(InputTypeGuidConstants.PayRollResignationStatusGuid)
        {
        }

        public Guid? TaxAllowanceId { get; set; }
        public bool? IsMainPage { get; set; }
        public Guid? EmployeeId { get; set; }
        public string Name { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" TaxAllowanceId= " + TaxAllowanceId);
            stringBuilder.Append(", SearchText= " + SearchText);
            stringBuilder.Append(", IsArchived= " + IsArchived);
            stringBuilder.Append(", IsMainPage= " + IsMainPage);
            stringBuilder.Append(", Name= " + Name);
            return stringBuilder.ToString();
        }
    }
}
