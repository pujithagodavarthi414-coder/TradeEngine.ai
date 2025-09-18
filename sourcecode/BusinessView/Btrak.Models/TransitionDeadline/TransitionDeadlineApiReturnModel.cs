using System;
using System.Text;

namespace Btrak.Models.TransitionDeadline
{
    public class TransitionDeadlineApiReturnModel
    {
        public Guid? TransitionDeadlineId { get; set; }
        public string Deadline { get; set; }

        public int TotalCount { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
		public bool IsArchived { get; set; }
		public byte[] TimeStamp { get; set; }

		public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TransitionDeadlineId = " + TransitionDeadlineId);
            stringBuilder.Append(", Deadline = " + Deadline);
			stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
			stringBuilder.Append(", IsArchived = " + IsArchived);
			stringBuilder.Append(", TimeStamp = " + TimeStamp);
			stringBuilder.Append(", TotalCount = " + TotalCount);
			return stringBuilder.ToString();
        }
    }
}
