using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class ProfessionTaxReturnsOutputModel
    {
        public string Ranges { get; set; }
        public string CompanyName { get; set; }
        public string Address { get; set; }
        public int NoOfEmployee { get; set; }
        public float TaxAmount  {get;set;}
        public float TotalTax { get; set; }
        public int TotalRecordsCount { get; set; }
    }
}
