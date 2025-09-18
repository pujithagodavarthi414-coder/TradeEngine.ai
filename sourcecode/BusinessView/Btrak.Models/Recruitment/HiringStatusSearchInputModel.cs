using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class HiringStatusSearchInputModel : SearchCriteriaInputModelBase
    {
        public HiringStatusSearchInputModel() : base(InputTypeGuidConstants.HiringStatusSearchInputCommandTypeGuid)
        {
        }

        public Guid? HiringStatusId { get; set; }
        public string Order { get; set; }
        public string Status { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("HiringStatusId = " + HiringStatusId);
            stringBuilder.Append(",Order = " + Order);
            stringBuilder.Append(",Status = " + Status);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
