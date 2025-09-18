using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class LinkedPurchasesOutputModel
    {

        public string ContractNumber { get; set; }
        public string CommodityName { get; set; }
        public string CommodityDescriptionIfAny { get; set; }
        public string ContractType { get; set; }
        public int QuanityNumber { get; set; }
        public string QuantityMeasurementUnit { get; set; }
        public string SellerName { get; set; }
        public string BuyerName { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? DataSetId { get; set; }
        public Guid? DataSourceId { get; set; }
        public string StatuName { get; set; }
        public Guid? ContractId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? BrokerId { get; set; }

    }

}
