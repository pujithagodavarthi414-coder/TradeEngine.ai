using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{


    public class QuestionOptionsForExport
    {
        public bool Result { get; set; }

        public int? Order { get; set; }

        public string OptionName { get; set; }

        public float OptionScore { get; set; }

    }
}
