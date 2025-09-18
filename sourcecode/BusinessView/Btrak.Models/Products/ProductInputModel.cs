using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Products
{
    public class ProductInputModel : InputModelBase
    {
        public ProductInputModel() : base(InputTypeGuidConstants.ProductInputCommandTypeGuid)
        {
        }
        public Guid? ProductId { get; set; }
        public string ProductName { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string CreatedOn { get; set; }
        public bool? IsArchived { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ProductId = " + ProductId);
            stringBuilder.Append(", ProductName = " + ProductName);
            stringBuilder.Append(", CreatedDate = " + CreatedDate);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
