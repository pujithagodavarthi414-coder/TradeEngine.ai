using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class SCOGenerationSerachInputModel : SearchCriteriaInputModelBase
    {
        public SCOGenerationSerachInputModel() : base(InputTypeGuidConstants.SearchSCOGenerationCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public Guid? ScoId { get; set; }
        public Guid? LeadSubmissionId { get; set; }
        public bool IsScoAccepted { get; set; }
    }
}
