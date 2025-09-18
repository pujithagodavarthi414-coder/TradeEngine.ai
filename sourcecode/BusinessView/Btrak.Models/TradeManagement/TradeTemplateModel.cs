using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class TradeTemplateModel
    {
        public Guid? TradeTemplateId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid TemplateTypeId { get; set; }
        public string TradeTemplateName { get; set; }
        public string FormBgColor { get; set; }
        public string FormKeys { get; set; }
        public string TradeTemplateFormJson { get; set; }
        public string FinalTradeTemplateFormJson { get; set; }
        public DateTime InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public object Fields { get; set; }
        public byte[] TimeStamp { get; set; }
    }

    public class FinalTradeTemplateModel
    {
        public string TradeTemplateJson { get; set; }
        public Guid TemplateTypeId { get; set; }
        public Guid? TradeTemplateId { get; set; }

    }
}
