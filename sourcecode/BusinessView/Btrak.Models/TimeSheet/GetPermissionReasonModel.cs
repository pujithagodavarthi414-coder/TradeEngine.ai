using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.TimeSheet
{
    public class GetPermissionReasonModel: SearchCriteriaInputModelBase
    {
        public GetPermissionReasonModel() : base(InputTypeGuidConstants.GetFeedbackTypes)
        {
            
        }

        public Guid? PermissionReasonId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PermissionReasonId= " + PermissionReasonId);
            return stringBuilder.ToString();
        }
    }
}