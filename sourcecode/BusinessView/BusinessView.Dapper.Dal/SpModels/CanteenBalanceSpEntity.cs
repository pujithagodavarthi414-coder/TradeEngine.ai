using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class CanteenBalanceSpEntity
    {
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public string CreditedAmount { get; set; }
        public string AmountDebited { get; set; }
        public string AmountRemaining { get; set; }
    }
}
