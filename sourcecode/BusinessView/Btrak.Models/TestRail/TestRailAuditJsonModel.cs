using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class TestRailAuditJsonModel
    {
        public string Title { get; set; }
        public Guid? TitleId { get; set; }
        public Guid? UserstoryId { get; set; }
        public string Action { get; set; }
        public string TabName { get; set; }
        public string Status { get; set; }
        public Guid? AssignToId { get; set; }
        public string ColorCode { get; set; }
        public DateTime OperationPerformedDateTime { get; set; }
        public Guid OperationsPerformedBy { get; set; }
        public string PerformedOn { get; set; }
        public string PerformedBy { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Title = " + Title);
            stringBuilder.Append(", TitleId = " + TitleId);
            stringBuilder.Append(", UserstoryId = " + UserstoryId);
            stringBuilder.Append(", Action = " + Action);
            stringBuilder.Append(", TabName = " + TabName);
            stringBuilder.Append(", Status = " + Status);
            stringBuilder.Append(", AssignToId = " + AssignToId);
            stringBuilder.Append(", ColorCode = " + ColorCode);
            stringBuilder.Append(", OperationPerformedDateTime = " + OperationPerformedDateTime);
            stringBuilder.Append(", OperationsPerformedBy = " + OperationsPerformedBy);
            stringBuilder.Append(", PerformedOn = " + PerformedOn);
            stringBuilder.Append(", PerformedBy = " + PerformedBy);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
