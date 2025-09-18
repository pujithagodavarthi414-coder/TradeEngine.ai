using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels
{
    public class DataSetConversionOutputModel
    {
        public object FormData { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? BrokerId { get; set; }
        public bool IsSelectPercentage { get; set; }
        public bool IsSelectCommodityBroker { get; set; }
        public bool IsSelectValue { get; set; }
        public int BrokeragePercentage { get; set; }
        public int BrokerageValue { get; set; }
        public string ContractType { get; set; }
        public string UniqueNumber { get; set; }
        public string BrokerageComments { get; set; }
        public string SellerComments { get; set; }
        public string SignatureComments { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? TemplateTypeId { get; set; }
        public Guid? AcceptedByClientUserId { get; set; }
        public Guid? AcceptedByTraderUserId { get; set; }
        public int? Version { get; set; }
        public int? RFQId { get; set; }
        public string RFQUniqueId { get; set; }
        public string InvoiceId { get; set; }
        public bool IsSwitchBl { get; set; }
    }
}
