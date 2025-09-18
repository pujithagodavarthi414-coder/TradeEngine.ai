using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Status
{
    public class UpsertUserStoryReplanTypeInputModel : InputModelBase
    {
        public UpsertUserStoryReplanTypeInputModel() : base(InputTypeGuidConstants.UpsertUserStoryReplanTypeCommandTypeGuid)
        {
        }

        public Guid? UserStoryReplanTypeId { get; set; }
        public string ReplanTypeName { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? OperationsPerformedBy { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryReplanTypeId = " + UserStoryReplanTypeId);
            stringBuilder.Append(", ReplanTypeName = " + ReplanTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
