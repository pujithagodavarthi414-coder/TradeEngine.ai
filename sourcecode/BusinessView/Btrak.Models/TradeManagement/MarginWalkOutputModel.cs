using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class MarginWalkOutputModel
    {
        public decimal Gross_Margin { get; set; }
        public decimal Commission { get; set; }
        public decimal Surveyor_Fees { get; set; }
        public decimal Bank_Charges { get; set; }
        public decimal BLAgent_Fees { get; set; }
        public decimal Demurrage { get; set; }
        public decimal Legal_Expensess { get; set; }
        public decimal Quality_Related_Charges { get; set; }
        public decimal Net_Margin { get; set; }
    }
}
