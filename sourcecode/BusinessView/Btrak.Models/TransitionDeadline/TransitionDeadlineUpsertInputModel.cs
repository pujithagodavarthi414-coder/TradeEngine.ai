using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TransitionDeadline
{
    public class TransitionDeadlineUpsertInputModel : InputModelBase
    {
        public TransitionDeadlineUpsertInputModel() : base(InputTypeGuidConstants.TransitionDeadlineUpsertInputCommandTypeGuid)
        {
        }

        public Guid? TransitionDeadlineId { get; set; }
        public string Deadline { get; set; }
		public bool IsArchived { get; set; }

		public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TransitionDeadlineId = " + TransitionDeadlineId);
            stringBuilder.Append(", Deadline = " + Deadline);
			stringBuilder.Append(", IsArchived = " + IsArchived);
			return stringBuilder.ToString();
        }
    }
}
