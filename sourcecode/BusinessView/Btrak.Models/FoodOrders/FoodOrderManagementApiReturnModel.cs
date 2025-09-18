using System;
using System.Text;

namespace Btrak.Models.FoodOrders
{
    public class FoodOrderManagementApiReturnModel
    {
        public Guid? FoodOrderId { get; set; }
        public Guid? CompanyId { get; set; }
        public string FoodItemName { get; set; }
        public decimal? Amount { get; set; }
        public Guid? CurrencyId { get; set; }
        public string CurrencyName { get; set; }
        public string Symbol { get; set; }
        public string Comment { get; set; }
        public Guid? ClaimedByUserId  { get; set; }
        public string ClaimedByUserName  { get; set; }
        public string ClaimedByUserProfileImage { get; set; }
        public Guid? FoodOrderStatusId  { get; set; }
        public string Status { get; set; }
        public Guid? StatusSetByUserId  { get; set; }
        public string StatusSetByUserName { get; set; }
        public string StatusSetByUserProfileImage { get; set; }
        public DateTime? OrderedDateTime { get; set; }
        public DateTime? StatusSetDateTime { get; set; }
        public string Reason { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string EmployeesName { get; set; }
        public int EmployeesCount { get; set; }
        public string Receipts { get; set; }
        public int TotalCount  { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", FoodOrderId = " + FoodOrderId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", FoodItemName = " + FoodItemName);
            stringBuilder.Append(", Amount = " + Amount);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", Comment = " + Comment);
            stringBuilder.Append(", ClaimedByUserId = " + ClaimedByUserId);
            stringBuilder.Append(", ClaimedByUserName = " + ClaimedByUserName);
            stringBuilder.Append(", ClaimedByUserProfileImage = " + ClaimedByUserProfileImage);
            stringBuilder.Append(", FoodOrderStatusId = " + FoodOrderStatusId);
            stringBuilder.Append(", Status = " + Status);
            stringBuilder.Append(", StatusSetByUserId = " + StatusSetByUserId);
            stringBuilder.Append(",StatusSetByUserName = " + StatusSetByUserName);
            stringBuilder.Append(",StatusSetByUserProfileImage" + StatusSetByUserProfileImage);
            stringBuilder.Append(", OrderedDateTime = " + OrderedDateTime);
            stringBuilder.Append(", StatusSetDateTime = " + StatusSetDateTime);
            stringBuilder.Append(", Reason = " + Reason);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", EmployeesName = " + EmployeesName);
            stringBuilder.Append(", EmployeesCount = " + EmployeesCount);
            stringBuilder.Append(", Receipts = " + Receipts);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
