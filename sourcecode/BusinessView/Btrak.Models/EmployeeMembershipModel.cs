using BTrak.Common;
using System;
using System.ComponentModel.DataAnnotations;

namespace Btrak.Models
{
   public  class EmployeeMembershipModel
    {
        public Guid Id
        {
            get;
            set;
        }
        public Guid EmployeeId
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Please select Membership.")]
        public Guid MembershipId
        {
            get;
            set;
        }
        public string Membership
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Please select Subscription paid by.")]
        public Guid? SubscriptionId
        {
            get;
            set;
        }

        [Required]
        [Range(1, 9999999999999999.99, ErrorMessage = UserDisplayMessages.PleaseEnterValidPrice)]
        public decimal? SubscriptionAmount
        {
            get;
            set;
        }
        public string SubscriptionPaidBy
        {
            get;
            set;
        }
        [Required(ErrorMessage = "Please select Currency.")]
        public Guid? CurrencyId
        {
            get;
            set;
        }
        public string CurrencyName
        {
            get;
            set;
        }

        [Required]
        public DateTime? CommenceDate
        {
            get;
            set;
        }
        public DateTime? RenewalDate
        {
            get;
            set;
        }
       
    }
}
