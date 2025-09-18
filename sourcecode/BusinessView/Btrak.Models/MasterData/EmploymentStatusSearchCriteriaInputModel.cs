using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class EmploymentStatusSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public EmploymentStatusSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetEmploymentStatus)
        {
        }
        public Guid? EmploymentStatusId { get; set; }
        public string EmploymentStatusName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmploymentStatusId = " + EmploymentStatusId);
            stringBuilder.Append(", EmploymentStatusName = " + EmploymentStatusName);
            return stringBuilder.ToString();
        }
    }
}
