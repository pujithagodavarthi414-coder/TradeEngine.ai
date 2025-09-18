using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Recruitment
{
    public class JobTypeUpsertInputModel : InputModelBase
    {
        public JobTypeUpsertInputModel() : base(InputTypeGuidConstants.JobTypeInputCommandTypeGuid)
        {
        }

        public Guid? JobTypeId { get; set; }
        public string JobTypeName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("JobTypeId = " + JobTypeId);
            stringBuilder.Append(",JobTypeName = " + JobTypeName);
            return stringBuilder.ToString();
        }
    }
}
