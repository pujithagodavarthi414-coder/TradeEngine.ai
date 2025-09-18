using System;
using BTrak.Common;

namespace Btrak.Models.Crm
{
    public class LeadSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public LeadSearchCriteriaInputModel() : base(InputTypeGuidConstants.LeadSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? LeadId { get; set; }
    }
}
