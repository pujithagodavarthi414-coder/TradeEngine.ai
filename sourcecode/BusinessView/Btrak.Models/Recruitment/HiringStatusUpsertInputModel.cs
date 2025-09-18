using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class HiringStatusUpsertInputModel : SearchCriteriaInputModelBase
    {
        public HiringStatusUpsertInputModel() : base(InputTypeGuidConstants.HiringStatusUpsertInputCommandTypeGuid)
        {
        }
       
        public Guid? HiringStatusId { get; set; }
        public int Order { get; set; }
        public string Status { get; set; }
        public string Color { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("HiringStatusId = " + HiringStatusId);
            stringBuilder.Append(",Order = " + Order);
            stringBuilder.Append(",Status = " + Status);
            stringBuilder.Append(",Color = " + Color);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
