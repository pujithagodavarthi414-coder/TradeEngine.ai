using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class FoodItemSpEntity
    {
        public Guid FoodItemId { get; set; }
        public string FoodItemName { get; set; }
        public decimal Price { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CompanyId { get; set; }
    }
}
