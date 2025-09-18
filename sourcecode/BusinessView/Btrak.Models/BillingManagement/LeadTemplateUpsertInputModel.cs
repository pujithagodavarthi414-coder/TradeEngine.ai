using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class LeadTemplateUpsertInputModel
    {
        public Guid? TemplateId { get; set; }
        public string FormName { get; set; }
        public string FormJson { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
