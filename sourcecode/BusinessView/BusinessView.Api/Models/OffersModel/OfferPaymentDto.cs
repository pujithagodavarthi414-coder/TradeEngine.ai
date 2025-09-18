using System.ComponentModel.DataAnnotations;
namespace BusinessView.Api.Models.OffersModel
{
    public class OfferPaymentDto
    {
        public int UserId { get; set; }
        public int OfferId { get; set; }
        public decimal Amount { get; set; }
        public string AdminName { get; set; }
        [Required(ErrorMessage = "Credit Amount is required")]
        public decimal CreditedAmount { get; set; }
        public string[] UserIds
        {
            get;
            set;
        }
        public int AdminId { get; set; }
        public int IsCreditedByAdmin { get; set; }
    }

    public class NewFoodItem
    {
        [Required]
        public string FoodItemName { get; set; }
        [Required]
        public decimal FoodItemPrice { get; set; }
    }
}