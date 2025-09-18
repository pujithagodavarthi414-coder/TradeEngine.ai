using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class LeadTemplateSearchInputModel : SearchCriteriaInputModelBase
    {
        public LeadTemplateSearchInputModel() : base(InputTypeGuidConstants.ProjectMemberSearchCriteriaInputCommandTypeGuid)
        {

        }
        public Guid? TemplateId { get; set; }
        public string FormName { get; set; }
       
    }
}
