using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class LeadSubmissionsDetails
    {
        public Guid? ClientId { get; set; }
        public Guid? LeadFormId { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? StatusName { get; set; }
        public Guid? ScoId { get; set; }
        public Guid UserId { get; set; }
        public string FormJson { get; set; }
        public string FormData { get; set; }
        public string FullName { get; set; }
        public Guid CompanyId { get; set; }
        public string SearchText { get; set; }
        public string ClientType { get; set; }
        public bool isClientKyc { get; set; }
        public int CreditLimit { get; set; }
        public string Comments { get; set; }
        public string Email { get; set; }
        public bool? IsScoAccepted { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int AvailableCreditLimit { get; set; }
        public string CompanyName { get; set; }


    }
}
