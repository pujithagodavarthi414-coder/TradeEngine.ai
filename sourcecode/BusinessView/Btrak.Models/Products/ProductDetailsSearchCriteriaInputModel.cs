using System;
using System.Text;
using BTrak.Common;
namespace Btrak.Models.Products
{
    public class ProductDetailsSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public ProductDetailsSearchCriteriaInputModel() : base(InputTypeGuidConstants.ProductDetailsSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? ProductDetailsId { get; set; }
        public Guid? ProductId { get; set; }
        public Guid? SupplierId { get; set; }
        public string SearchProductCode { get; set; }
        public string SearchManufacturerCode { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ProductDetailsId = " + ProductDetailsId);
            stringBuilder.Append(", ProductId = " + ProductId);
            stringBuilder.Append(", SupplierId = " + SupplierId);
            stringBuilder.Append(", SearchProductCode = " + SearchProductCode);
            stringBuilder.Append(", SearchManufacturerCode = " + SearchManufacturerCode);
            return stringBuilder.ToString();
        }
    }
}
