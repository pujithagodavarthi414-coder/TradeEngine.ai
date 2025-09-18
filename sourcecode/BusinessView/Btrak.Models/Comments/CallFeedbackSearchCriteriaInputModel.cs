using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Comments
{
    public class CallFeedbackSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {

        public CallFeedbackSearchCriteriaInputModel() : base(InputTypeGuidConstants.CommentSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? CallFeedbackId { get; set; }
        public Guid? CallFeedbackUserId { get; set; }
        public Guid? ReceiverId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CallFeedbackId = " + CallFeedbackId);
            stringBuilder.Append(", ReceiverId = " + ReceiverId);
            stringBuilder.Append(", CallFeedbackUserId = " + CallFeedbackUserId);
            return stringBuilder.ToString();
        }
    }
}
