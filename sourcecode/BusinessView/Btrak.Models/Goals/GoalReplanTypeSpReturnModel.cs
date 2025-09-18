using System;

namespace Btrak.Models.Goals
{
    public class GoalReplanTypeSpReturnModel
    {
        public Guid? GoalReplanTypeId { get; set; }
        public string GoalReplanTypeName { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }

        public DateTimeOffset CreatedDateTime { get; set; }

        public byte[] TimeStamp { get; set; }
    }
}
