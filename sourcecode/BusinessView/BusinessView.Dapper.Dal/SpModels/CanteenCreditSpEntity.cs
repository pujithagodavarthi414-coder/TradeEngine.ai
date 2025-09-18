using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class CanteenCreditSpEntity
    {
        public Guid? CreditedTo { get; set; }
        public string CreditedToFirstName { get; set; }
        public string CreditedToSurName { get; set; }
        public decimal Amount { get; set; }
        public Guid? CreditedByUserId { get; set; }
        public string CreditedByFirstName { get; set; }
        public string CreditedBySurName { get; set; }
        public DateTime CreditedOn { get; set; }
        public Guid? CompanyId { get; set; }
    }
}
