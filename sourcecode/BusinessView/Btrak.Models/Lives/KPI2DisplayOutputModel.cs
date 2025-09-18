using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Lives
{
    public class KPI2DisplayOutputModel : SearchCriteriaInputModelBase
    {
        public KPI2DisplayOutputModel() : base(InputTypeGuidConstants.ContractModelInputCommandTypeGuid)
        {
        }
        public string Heading { get; set; }
        public string SubHeading { get; set; }
        public string Month { get; set; }
            
    }

    public class KPI2DisplayInputModel
    {
        public DateTime? From { get; set; }
        public DateTime? To { get; set; }
        public string LocationKPI01 { get; set; }
        public double? numberOfIndependentShFsCertified { get; set; }
        public double? numberOfShFsAttended { get; set; }
    }

    public class KPI2DisplayModel
    {
        public string Month { get; set; }
        public double numberOfShFsAttended { get; set; }
        public double NumberofTrainingCamps { get; set; }
    }
}
