using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class StepsURLsGetOuputModel
    {
        public Guid? StepId { get; set; }
        public string ContractURLs { get; set; }
        public string SalesContractURLs { get; set; }
        public string StepName { get; set; }
        public string LinkedContractUrl { get; set; }
        public string ReUploadedUrl { get; set; }

        public Guid? DocumentId { get; set; }
        public string DocumentName { get; set; }
        public string DocumentUrl { get; set; }

    }
}
