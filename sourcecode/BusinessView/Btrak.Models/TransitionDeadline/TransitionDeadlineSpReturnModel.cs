using System;

namespace Btrak.Models.TransitionDeadline
{
    public class TransitionDeadlineSpReturnModel
    {
        public Guid? TransitionDeadlineId { get; set; }
        public string Deadline { get; set; }

		public int TotalCount { get; set; }
		public DateTimeOffset CreatedDateTime { get; set; }
		public bool IsArchived { get; set; }
		public byte[] TimeStamp { get; set; }
	}
}
