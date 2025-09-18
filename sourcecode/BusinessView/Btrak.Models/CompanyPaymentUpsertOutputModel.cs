using System;

namespace Btrak.Models
{
    public class CompanyPaymentUpsertOutputModel
    {
        public Guid? PaymentId { get; set; }
        public int? PurchasedLicensesCount { get; set; }
        public bool? IsCancelled { get; set; }
        public string PurchaseType { get; set; }
        public DateTime? RenewalDate { get; set; }
        public string SubscriptionType { get; set; }
        public bool? IsShowCurrentPlan { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? Id { get; set; }
        public Guid? CompanyId { get; set; }
        public int? Noofpurchasedlicences { get; set; }
        public decimal TotalAmountPaid { get; set; }

    }
}
