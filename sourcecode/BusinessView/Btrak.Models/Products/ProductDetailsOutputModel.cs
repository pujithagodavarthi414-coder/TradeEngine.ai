using System;
using System.Text;

namespace Btrak.Models.Products
{
    public class ProductDetailsOutputModel
    {
        public Guid? ProductDetailsId { get; set; }
        public Guid? ProductId { get; set; }
        public Guid? SupplierId { get; set; }
        public string ProductCode { get; set; }
        public string ManufacturerCode { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string CreatedOn { get; set; }
        public string ProductName { get; set; }
        public string SupplierName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ProductId = " + ProductId);
            stringBuilder.Append(", ProductDetailsId = " + ProductDetailsId);
            stringBuilder.Append(", SupplierId = " + SupplierId);
            stringBuilder.Append(", ProductCode = " + ProductCode);
            stringBuilder.Append(", ManufacturerCode = " + ManufacturerCode);
            stringBuilder.Append(", CreatedDate = " + CreatedDate);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", ProductName = " + ProductName);
            stringBuilder.Append(", SupplierName = " + SupplierName);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
