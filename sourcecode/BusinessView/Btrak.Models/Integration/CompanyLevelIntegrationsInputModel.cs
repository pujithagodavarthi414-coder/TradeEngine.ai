using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Integration
{
    public class CompanyLevelIntegrationsInputModel
    {
        public bool IsArchived { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
