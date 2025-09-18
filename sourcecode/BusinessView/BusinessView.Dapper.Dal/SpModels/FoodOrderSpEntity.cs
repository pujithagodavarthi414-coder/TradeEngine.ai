using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class FoodOrderSpEntity
    {
        public Guid OrderId { get; set; }
        public string FoodItemName { get; set; }
        public decimal? Amount { get; set; }
        public string Comment { get; set; }
        public Guid ClaimedByUserId { get; set; }
        public string ClaimedByUserFirstName { get; set; }
        public string ClaimedByUserSurName { get; set; }
        public Guid StatusSetByUserId { get; set; }
        public string ApprovedByUserFirstName { get; set; }
        public string ApprovedByUserSurName { get; set; }
        public Guid FoodOrderStatusId { get; set; }
        public string Status { get; set; }
        public DateTime OrderedDateTime { get; set; }
        public DateTime StatusSetDateTime { get; set; }
        public Guid UserId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public Guid CompanyId { get; set; }
        public string Reason { get; set; }
    }
}
