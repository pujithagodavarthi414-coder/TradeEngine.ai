using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class LeadStagesSearchInputModel:SearchCriteriaInputModelBase
    {
        public LeadStagesSearchInputModel() : base(InputTypeGuidConstants.SearchLeadStatusCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public string Name { get; set; }
    }
}
