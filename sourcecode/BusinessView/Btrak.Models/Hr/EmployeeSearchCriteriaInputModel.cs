using System;
using BTrak.Common;

namespace Btrak.Models.Hr
{
    public class EmployeeSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeSearchCriteriaInputModel() : base(InputTypeGuidConstants.EmployeeSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeId { get; set; }
    }
}