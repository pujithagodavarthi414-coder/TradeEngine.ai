using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class MemberShipSpEntity
    {
        public Guid Id { get; set; }
        public Guid EmployeeId { get; set; }
        public Guid MemberShipId { get; set; }
        public string MemberShipName { get; set; }
        public Guid SubscriptionId { get; set; }
        public string SubscriptionName { get; set; }
        public string SubscriptionAmount { get; set; }
        public Guid CurrencyId { get; set; }
        public DateTime CommenceDate { get; set; }
        public DateTime RenewalDate { get; set; }
        public Guid CreatedByUserId { get; set; }
    }
}
