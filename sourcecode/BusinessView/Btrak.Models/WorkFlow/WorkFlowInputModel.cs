using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowInputModel: InputModelBase
    {
        public WorkFlowInputModel() : base(InputTypeGuidConstants.WorkFlowInputCommandTypeGuid)
        {
        }

        public Guid? WorkFlowId { get; set; }
        public string WorkFlowName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", WorkFlowName = " + WorkFlowName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
