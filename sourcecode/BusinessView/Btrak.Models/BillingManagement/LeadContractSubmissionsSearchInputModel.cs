using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class LeadContractSubmissionsSearchInputModel : SearchCriteriaInputModelBase
    {
        public LeadContractSubmissionsSearchInputModel() : base(InputTypeGuidConstants.SearchLeadContractSubmissionCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public Guid? UserId { get; set; }
        public Guid? SalesPersonId { get; set; }
        public Guid? ProductId { get; set; }
        public Guid? GradeId { get; set; }
        public Guid? PaymentTypeId { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? CountryOriginId { get; set; }
    }
}
