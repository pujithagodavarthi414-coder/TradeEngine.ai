using System;

namespace Btrak.Models.Products
{
    public class ProductModel
    {
        public Guid? ProductId { get; set; }
        public string ProductName { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string CreatedOn { get; set; }
        public Guid? OperationPerformedBy { get; set; }
    }

    public class ProductDetailsModel
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
        public Guid? OperationPerformedBy { get; set; }
    }
}
