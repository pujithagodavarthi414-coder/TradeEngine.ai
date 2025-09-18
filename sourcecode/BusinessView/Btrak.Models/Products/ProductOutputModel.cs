using System;
using System.Text;

namespace Btrak.Models.Products
{
    public class ProductOutputModel
    {
        public Guid? ProductId { get; set; }
        public string ProductName { get; set; }
        public DateTime? CreatedDate	 { get; set; }
        public string CreatedOn { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public string TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ProductId = " + ProductId);
            stringBuilder.Append(", ProductName = " + ProductName);
            stringBuilder.Append(", CreatedDate = " + CreatedDate);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
