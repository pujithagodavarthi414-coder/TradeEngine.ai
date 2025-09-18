using System;


namespace Btrak.Models.TradeManagement
{
    public class ClientAccessModel
    {
        public Guid? ClientId { get; set; }
        public bool CanHaveAcess { get; set; }
    }
}
