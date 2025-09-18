using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class ReportingMethodUpsertModel: InputModelBase
    {
        public ReportingMethodUpsertModel() : base(InputTypeGuidConstants.ReportingMethodInputCommandTypeGuid)
        {
        }

        public Guid? ReportingMethodId { get; set; }
        public string ReportingMethodName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ReportingMethodId  = " + ReportingMethodId);
            stringBuilder.Append("ReoirtingMethodName  = " + ReportingMethodName);
            stringBuilder.Append("IsArchived = " + IsArchived);
            stringBuilder.Append("TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}