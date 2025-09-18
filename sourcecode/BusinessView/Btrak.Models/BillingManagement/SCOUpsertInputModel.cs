using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class SCOUpsertInputModel : InputModelBase
    {
        public SCOUpsertInputModel() : base(InputTypeGuidConstants.UpsertSCOGenerationInputCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public Guid? LeadSubmissionId { get; set; }
        public Guid? ClientId { get; set; }
        public string Comments { get; set; }
        public decimal CreditsAllocated { get; set; }
        public bool IsArchived { get; set; }
        public bool? IsScoAccepted { get; set; }
        public bool? IsForPdfs { get; set; }
        public string ScoPdf { get; set; }
        public string PerformaPdf { get; set; }

    }
}
