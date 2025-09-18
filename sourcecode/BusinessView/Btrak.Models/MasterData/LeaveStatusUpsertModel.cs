using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class LeaveStatusUpsertModel : InputModelBase
    {
        public LeaveStatusUpsertModel() : base(InputTypeGuidConstants.LeaveStatusUpsertInputCommandTypeGuid)
        {
        }

        public Guid? LeaveStatusId { get; set; }
        public string LeaveStatusName { get; set; }
        public bool IsArchived { get; set; }
        public string LeaveStatusColour { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PaymentTypeId= " + LeaveStatusId);
            stringBuilder.Append(", PaymentTypeName= " + LeaveStatusName);
            stringBuilder.Append(", IsArchived= " + IsArchived);
            stringBuilder.Append(", TimeStamp= " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}