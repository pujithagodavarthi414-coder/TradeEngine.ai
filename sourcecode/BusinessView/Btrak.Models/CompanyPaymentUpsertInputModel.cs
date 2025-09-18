using BTrak.Common;
using System;

namespace Btrak.Models
{
    public class CompanyPaymentUpsertInputModel : SearchCriteriaInputModelBase
    {
        public CompanyPaymentUpsertInputModel() : base(InputTypeGuidConstants.CompanyPaymentInputCommandTypeGuid)
        {
        }
        public Guid? PaymentId { get; set; }
        public decimal? TotalAmount {get;set;}
        public string CardHolderName { get; set; }
        public string CardHolderBillingAddress { get; set; }
        public string StripeTokenId { get; set; }
        public string StripeCustomerId { get; set; }
        public string StripePaymentId { get; set; }
        public string Status { get; set; }
        public string CardNumber { get; set; }
        public string CardExpiryDate { get; set; }
        public string CardSecurityCode { get; set; }
        public int? NoOfPurchases { get; set; }
        public string PlanName { get; set; }
        public string PricingId { get; set; }
        public string SubscriptionId { get; set; }
        public string SubscriptionType { get; set; }
        public string Email { get; set; }
        public CustomerAddressOptions AddressOptions { get; set; }
        public bool? IsSubscriptionDone { get; set; }
        public string PurchaseType { get; set; }
        public int? Noofpurchasedlicences { get; set; }
        public bool? IsRenewal { get; set; }
        public bool? IsCancelled { get; set; }
        public bool? IsUpdate { get; set; }
        public decimal TotalAmountPaid { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public DateTime? CancelledDate { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int OriginalPurchases { get; set; }
        public string InvoiceId { get; set; }
        public string TransactionName { get; set; }
    }
    public class CustomerAddressOptions
    {
        public string Address_line1 { get; set; }
        public string Address_zip { get; set; }
        public string Address_city { get; set; }
        public string Address_state { get; set; }
        public string Address_country { get; set; }
        public string Brand { get; set; }
        public string Name { get; set; }
    }
}

