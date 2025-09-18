using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TransitionDeadline
{
    public class TransitionDeadlineInputModel : InputModelBase
    {
        public TransitionDeadlineInputModel() : base(InputTypeGuidConstants.TransitionDeadlineInputCommandTypeGuid)
        {
        }

        public Guid? TransitionDeadlineId { get; set; }
        public string Deadline { get; set; }
		public bool? IsArchived { get; set; }

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
