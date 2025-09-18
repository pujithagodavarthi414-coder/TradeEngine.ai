using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class JobOpeningStatusSearchInputModel : SearchCriteriaInputModelBase
    {
        public JobOpeningStatusSearchInputModel() : base(InputTypeGuidConstants.JobOpeningStatusSearchInputCommandTypeGuid)
        {
        }

        public Guid? JobOpeningStatusId { get; set; }
        public string Status { get; set; }
        public int Order { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanySettingsId = " + JobOpeningStatusId);
            stringBuilder.Append(",Order = " + Order);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }

    }
}
