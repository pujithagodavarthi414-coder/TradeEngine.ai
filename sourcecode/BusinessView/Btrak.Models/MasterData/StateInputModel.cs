using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class StateInputModel : InputModelBase
    {
        public StateInputModel() : base(InputTypeGuidConstants.StateInputCommandTypeGuid)
        {
        }
       
        public Guid? StateId { get; set; }
        public string StateName { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" StateId = " + StateId);
            stringBuilder.Append(", StateName = " + StateName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
