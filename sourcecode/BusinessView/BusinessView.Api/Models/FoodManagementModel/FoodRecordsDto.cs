using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BusinessView.Api.Models.FoodManagementModel
{
    public class FoodRecordsDto
    {
        public int Id { get; set; }
        public int? UserId { get; set; }
        public string ItemName { get; set; }
        public string UserName { get; set; }
        public decimal? ItemPrice { get; set; }
        public int? ItemCount { get; set; }
        public decimal? OfferAmount { get; set; }
        public DateTime? CreatedOn { get; set; }
        public DateTime? PurchasedDate { get; set; }
        public string DateOfPurchase { get; set; }
        public string CreditedDate { get; set; }
        public string AddedOn { get; set; }
        public string AddedBy { get; set; }
        public int? CreatedBy { get; set; }
        public bool? IsCredited { get; set; }
    }

    public class CanteenBalanceModel
    {
        public string UserName
        {
            get; set;
        }

        public string CreditedAmount
        {
            get;
            set;
        }

        public string AmountDebited
        {
            get;
            set;
        }

        public string AmountRemaining
        {
            get;
            set;
        }
    }
}