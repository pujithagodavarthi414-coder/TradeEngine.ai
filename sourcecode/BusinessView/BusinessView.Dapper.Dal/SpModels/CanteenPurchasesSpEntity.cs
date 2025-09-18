using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class CanteenPurchasesSpEntity
    {
        public Guid UserId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public Guid FoodItemId { get; set; }
        public string FoodItemName { get; set; }
        public decimal? Price { get; set; }
        public int Quantity { get; set; }
        public DateTime PurchasedDateTime { get; set; }
        public Guid CompanyId { get; set; }
    }
}
