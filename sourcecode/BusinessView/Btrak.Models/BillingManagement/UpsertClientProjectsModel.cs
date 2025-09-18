using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.BillingManagement
{
    public class UpsertClientProjectsModel : InputModelBase
    {
        public UpsertClientProjectsModel() : base(InputTypeGuidConstants.UpsertClientProjectsCommandTypeGuid)
        {
        }

        public Guid? ClientProjectId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? ProjectId { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ClientProjectId" + ClientProjectId);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("ProjectId" + ProjectId);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}