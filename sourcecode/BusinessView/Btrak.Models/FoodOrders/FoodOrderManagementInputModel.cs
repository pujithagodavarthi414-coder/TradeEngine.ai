using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.FoodOrders
{
    public class FoodOrderManagementInputModel : InputModelBase
    {
        public FoodOrderManagementInputModel() : base(InputTypeGuidConstants.FoodOrderInputCommandTypeGuid)
        {
        }
        public Guid? FoodOrderId { get; set; }
        public DateTime? OrderedDate { get; set; }
        public string FoodOrderItems { get; set; }
        public List<Guid?> MemberId { get; set; }
        public decimal? Amount { get; set; }
        public Guid? CurrencyId { get; set; }
        public string Comment { get; set; }
        public string Reason { get; set; }
        public Guid? StatusId { get; set; }
        public List<FileDetails> File { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("FoodOrderId = " + FoodOrderId);
            stringBuilder.Append(", OrderedDate = " + OrderedDate);
            stringBuilder.Append(", FoodOrderItems = " + FoodOrderItems);
            stringBuilder.Append(", MemberId = " + MemberId);
            stringBuilder.Append(", Amount = " + Amount);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", Comment = " + Comment);
            stringBuilder.Append(", Reason = " + Reason);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", File = " + File);
            return stringBuilder.ToString();
        }
    }

    public class FileDetails
    {
        public string FileName { get; set; }
        public string FileType { get; set; }
        public string FileUrl { get; set; }
    }
}
