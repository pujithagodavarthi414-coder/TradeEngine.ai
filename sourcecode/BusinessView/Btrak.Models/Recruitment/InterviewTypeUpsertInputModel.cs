using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Recruitment
{
    public class InterviewTypeUpsertInputModel : SearchCriteriaInputModelBase
    {
        public InterviewTypeUpsertInputModel() : base(InputTypeGuidConstants.InterviewTypeUpsertInputCommandTypeGuid)
        {
        }

        public Guid? InterviewTypeId { get; set; }
        public string InterviewTypeName { get; set; }
        public string Color { get; set; }
        public bool? IsVideo { get; set; }
        public bool? IsPhone { get; set; }
        public List<Guid?> RoleId { get; set; }
        public string RoleIds { get; set; }
        public Guid? InterviewTypeRoleCofigurationId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InterviewTypeId = " + InterviewTypeId);
            stringBuilder.Append(",InterviewTypeName = " + InterviewTypeName);
            stringBuilder.Append(",Color = " + Color);
            stringBuilder.Append(",IsVideo = " + IsVideo);
            stringBuilder.Append(",IsAudio = " + IsPhone);
            stringBuilder.Append(",RoleId = " + RoleId);
            stringBuilder.Append(",RoleIds = " + RoleIds);
            stringBuilder.Append(",InterviewTypeRoleCofigurationId = " + InterviewTypeRoleCofigurationId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
