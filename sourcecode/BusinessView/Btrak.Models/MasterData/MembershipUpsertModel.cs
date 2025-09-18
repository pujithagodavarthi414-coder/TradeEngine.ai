using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class MembershipUpsertModel : InputModelBase
    {
        public MembershipUpsertModel() : base(InputTypeGuidConstants.ReportingMethodInputCommandTypeGuid)
        {
        }

        public Guid? MembershipId { get; set; }
        public string MembershipName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ReportingMethodId  = " + MembershipId);
            stringBuilder.Append("ReoirtingMethodName  = " + MembershipName);
            stringBuilder.Append("IsArchived = " + IsArchived);
            stringBuilder.Append("TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}